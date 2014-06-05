//
//  MMXLessonsViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.5.19.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXGameViewController.h"
#import "MMXLessonTableViewCell.h"
#import "MMXLessonsViewController.h"
#import "MMXTopScore.h"

@interface MMXLessonsViewController ()

@property (nonatomic, strong) NSArray *fetchedTopScores;

@end

@implementation MMXLessonsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchTopScoresForLessonsInThisClass];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_blueColor];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lessons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *lesson = self.lessons[indexPath.row];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lessonID == %@", lesson[@"lessonID"]];
    NSArray *results = [self.fetchedTopScores filteredArrayUsingPredicate:predicate];
    
    MMXLessonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMXLessonCell" forIndexPath:indexPath];
    cell.lessonTitleLabel.text = lesson[@"title"];
    
    if (results.count > 0)
    {
        MMXTopScore *topScore = results[0];
        cell.starCountLabel.text = [NSString stringWithFormat:@"%ld", (long)topScore.stars.integerValue];
    }
    else
    {
        cell.starCountLabel.hidden = YES;
        cell.starImageView.hidden = YES;
    }
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MMXBeginLessonSegue"])
    {
        NSDictionary *lesson = self.lessons[self.tableView.indexPathForSelectedRow.row];
        MMXGameData *gameConfiguration = [self gameConfigurationFromLesson:lesson];
        
        MMXGameViewController *gameViewController = (MMXGameViewController *)segue.destinationViewController;
        gameViewController.managedObjectContext = self.managedObjectContext;
        gameViewController.gameData = gameConfiguration;
    }
}

- (IBAction)unwindToLessonsSegue:(UIStoryboardSegue *)unwindSegue
{
    
}

#pragma mark - Helpers

- (void)fetchTopScoresForLessonsInThisClass
{
    NSMutableArray *lessonIDsInThisClass = [NSMutableArray arrayWithCapacity:self.lessons.count];
    for (NSDictionary *lesson in self.lessons)
    {
        [lessonIDsInThisClass addObject:lesson[@"lessonID"]];
    }
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MMXTopScore"
                                                         inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"lessonID IN %@", lessonIDsInThisClass]];
    
    NSError *fetchError = nil;
    self.fetchedTopScores = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
}

- (MMXGameData *)gameConfigurationFromLesson:(NSDictionary *)lesson
{
    MMXGameData *gameConfiguration = [NSEntityDescription insertNewObjectForEntityForName:@"MMXGameData"
                                                                   inManagedObjectContext:self.managedObjectContext];
    
    gameConfiguration.gameType = MMXGameTypeCourse;
    gameConfiguration.lessonID = lesson[@"lessonID"];
    
    gameConfiguration.targetNumber = lesson[@"targetNumber"];
    gameConfiguration.numberOfCards = lesson[@"numberOfCards"];
    
    if ([lesson[@"arithmeticType"] isEqualToString:@"addition"])
    {
        gameConfiguration.arithmeticType = MMXArithmeticTypeAddition;
    }
    else if ([lesson[@"arithmeticType"] isEqualToString:@"subtraction"])
    {
        gameConfiguration.arithmeticType = MMXArithmeticTypeSubtraction;
    }
    else if ([lesson[@"arithmeticType"] isEqualToString:@"multiplication"])
    {
        gameConfiguration.arithmeticType = MMXArithmeticTypeMultiplication;
    }
    else if ([lesson[@"arithmeticType"] isEqualToString:@"division"])
    {
        gameConfiguration.arithmeticType = MMXArithmeticTypeDivision;
    }
    else
    {
        NSAssert(YES, @"MMX: Arithmetic Type in JSON is not valid.");
    }
    
    if ([lesson[@"memorySpeed"] isEqualToString:@"fast"])
    {
        gameConfiguration.memorySpeed = MMXMemorySpeedFast;
    }
    else if ([lesson[@"memorySpeed"] isEqualToString:@"slow"])
    {
        gameConfiguration.memorySpeed = MMXMemorySpeedSlow;
    }
    else if ([lesson[@"memorySpeed"] isEqualToString:@"none"])
    {
        gameConfiguration.memorySpeed = MMXMemorySpeedNone;
    }
    else
    {
        NSAssert(YES, @"MMX: Memory Speed in JSON is not valid.");
    }
    
    // TODO: Need music tracks .
    
    gameConfiguration.cardStyle = [MMXGameData selectRandomCardStyle];
    
    gameConfiguration.penaltyMultiplier = lesson[@"penaltyMultiplier"];
    
    NSArray *starTimes = lesson[@"starTimes"];
    gameConfiguration.twoStarTime = starTimes[0];
    gameConfiguration.threeStarTime = starTimes[1];
    
    return gameConfiguration;
}

@end
