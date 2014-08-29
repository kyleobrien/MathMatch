//
//  MMXClassesViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.5.18.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXClassesViewController.h"
#import "MMXClassProgressTableViewCell.h"
#import "MMXClassStarTableViewCell.h"
#import "MMXLessonsViewController.h"
#import "MMXResultsViewController.h"
#import "MMXTopScore.h"

@interface MMXClassesViewController ()

@property (nonatomic, strong) NSArray *classesFromJSON;
@property (nonatomic, strong) NSMutableArray *accessoryLabelsForCells;

@end

@implementation MMXClassesViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        NSError *error = nil;
        
        NSData *jsonData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"classes" withExtension:@"json"]];
        self.classesFromJSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:0
                                                                 error:&error];
        
        NSAssert(error == nil, @"JSON Parse Error!");
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kMMXResultsDidSaveGameNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note)
                                                      {
                                                          [self generateAccessoryLabels];
                                                          [self.tableView reloadData];
                                                      }];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Classes", nil);
    
    [self generateAccessoryLabels];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_blueColor];
    
    // Doesn't deselect on swipe back (bug?) so doing it manually.
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_blackColor];
    
    if (self.isMovingFromParentViewController)
    {
        [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapBackward;
        [[MMXAudioManager sharedManager] playSoundEffect];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MMXProgressCellToLessonsSegue"] || [segue.identifier isEqualToString:@"MMXStarCellToLessonsSegue"])
    {
        [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapForward;
        [[MMXAudioManager sharedManager] playSoundEffect];
        
        NSDictionary *class = self.classesFromJSON[self.tableView.indexPathForSelectedRow.row];
        
        MMXLessonsViewController *lessonsViewController = (MMXLessonsViewController *)segue.destinationViewController;
        lessonsViewController.title = class[@"title"];
        lessonsViewController.managedObjectContext = self.managedObjectContext;
        lessonsViewController.lessons = class[@"lessons"];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classesFromJSON.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *class = self.classesFromJSON[indexPath.row];
    
    if (indexPath.row < self.accessoryLabelsForCells.count)
    {
        NSDictionary *accessoryLabels = self.accessoryLabelsForCells[indexPath.row];
        
        NSNumber *shouldShowStars = accessoryLabels[@"shouldShowStars"];
        if (shouldShowStars.boolValue)
        {
            MMXClassStarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMXClassStarCell" forIndexPath:indexPath];
            cell.classTitleLabel.text = class[@"title"];
            cell.starCountLabel.text = accessoryLabels[@"label"];
            
            NSString *pluralStars = @"Stars";
            if ([cell.starCountLabel.text isEqualToString:@"1"])
            {
                pluralStars = @"Star";
            }
            cell.accessibilityLabel = [NSString stringWithFormat:@"%@, %@ %@", cell.classTitleLabel.text, cell.starCountLabel.text, pluralStars];
            
            return cell;
        }
        else
        {
            MMXClassProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMXClassProgressCell" forIndexPath:indexPath];
            cell.classTitleLabel.text = class[@"title"];
            cell.progressDescriptionLabel.text = accessoryLabels[@"label"];
            
            cell.accessibilityLabel = nil;
            
            return cell;
        }
    }
    else
    {
        MMXClassProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMXClassProgressCell" forIndexPath:indexPath];
        cell.classTitleLabel.text = class[@"title"];
        
        cell.accessibilityLabel = nil;
        
        return cell;
    }
}

#pragma mark - Helpers

- (void)generateAccessoryLabels
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MMXTopScore"
                                                         inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSError *fetchError = nil;
    NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    
    self.accessoryLabelsForCells = [NSMutableArray arrayWithCapacity:self.classesFromJSON.count];
    
    for (NSDictionary *class in self.classesFromJSON)
    {
        NSInteger completedLessons = 0;
        NSInteger minimumStarRating = 3;
        
        NSArray *lessons = class[@"lessons"];
        for (NSDictionary *lesson in lessons)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lessonID == %@", lesson[@"lessonID"]];
            NSArray *filteredLesson = [fetchedResults filteredArrayUsingPredicate:predicate];
            if (filteredLesson.count > 0)
            {
                MMXTopScore *topScore = filteredLesson[0];
                NSInteger starRating = topScore.stars.integerValue;
                if (starRating < minimumStarRating)
                {
                    minimumStarRating = starRating;
                }
                
                completedLessons += 1;
            }
        }
        
        NSDictionary *cellLabel;
        if ((lessons.count == 0) || (completedLessons < lessons.count))
        {
            NSString *label = [NSString stringWithFormat:@"%ld of %ld", (long)completedLessons, (long)lessons.count];
            cellLabel = @{@"shouldShowStars": @NO, @"label": label};
        }
        else
        {
            NSString *label = [NSString stringWithFormat:@"%ld", (long)minimumStarRating];
            cellLabel = @{@"shouldShowStars": @YES, @"label": label};
        }
        
        [self.accessoryLabelsForCells addObject:cellLabel];
    }
}

@end
