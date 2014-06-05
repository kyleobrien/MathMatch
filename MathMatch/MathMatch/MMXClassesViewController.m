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
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Classes", nil);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
            NSNumber *lessonID = lesson[@"lessonID"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lessonID == %@", lessonID];
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
            // Show X of Y
            NSString *label = [NSString stringWithFormat:@"%ld of %ld", completedLessons, lessons.count];
            cellLabel = @{@"shouldShowStars": @NO, @"label": label};
        }
        else
        {
            // Show star rating
            NSString *label = [NSString stringWithFormat:@"%ld", minimumStarRating];
            cellLabel = @{@"shouldShowStars": @YES, @"label": label};
        }
        
        [self.accessoryLabelsForCells addObject:cellLabel];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_blueColor];
    
    // Doesn't deselect on sipe back (bug?) so doing it manually.
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
    // TODO: Need to update these if player finishes a game, then backs up to this screen.
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_blackColor];
    
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MMXProgressCellToLessonsSegue"] ||
        [segue.identifier isEqualToString:@"MMXStarCellToLessonsSegue"])
    {
        NSDictionary *class = self.classesFromJSON[self.tableView.indexPathForSelectedRow.row];
        
        MMXLessonsViewController *lessonsViewController = (MMXLessonsViewController *)segue.destinationViewController;
        lessonsViewController.title = class[@"title"];
        lessonsViewController.managedObjectContext = self.managedObjectContext;
        lessonsViewController.lessons = class[@"lessons"];
    }
}

#pragma mark - Table view data source

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
    NSDictionary *accessoryLabels = self.accessoryLabelsForCells[indexPath.row];
    
    NSNumber *shouldShowStars = accessoryLabels[@"shouldShowStars"];
    if (shouldShowStars.boolValue)
    {
        MMXClassStarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMXClassStarCell" forIndexPath:indexPath];
        cell.classTitleLabel.text = class[@"title"];
        cell.starCountLabel.text = accessoryLabels[@"label"];
        
        return cell;
    }
    else
    {
        MMXClassProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMXClassProgressCell" forIndexPath:indexPath];
        cell.classTitleLabel.text = class[@"title"];
        cell.progressDescriptionLabel.text = accessoryLabels[@"label"];
        
        return cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
