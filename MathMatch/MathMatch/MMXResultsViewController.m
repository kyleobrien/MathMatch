//
//  MMXResultsViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.4.18.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXResultsViewController.h"
#import "MMXTimeIntervalFormatter.h"
#import "MMXTopScore.h"

@interface MMXResultsViewController ()

@end

NSString * const kMMXResultsDidSaveGameNotification = @"MMXResultsDidSaveGameNotification";

@implementation MMXResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.timeLabel.text = [MMXTimeIntervalFormatter stringWithInterval:self.gameData.completionTime.doubleValue
                                                         forFormatType:MMXTimeIntervalFormatTypeLong];
    self.incorrectMatchesLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gameData.incorrectMatches.integerValue];
    self.penaltyMultiplierLabel.text = [NSString stringWithFormat:@"x %2.1fs", self.gameData.penaltyMultiplier.floatValue];
    
    NSTimeInterval penaltyTime = self.gameData.incorrectMatches.integerValue * self.gameData.penaltyMultiplier.floatValue;
    self.gameData.completionTimeWithPenalty = [NSNumber numberWithDouble:penaltyTime];
    self.penaltyTimeLabel.text = [MMXTimeIntervalFormatter stringWithInterval:penaltyTime
                                                                forFormatType:MMXTimeIntervalFormatTypeLong];
    
    self.gameData.completionTimeWithPenalty = @(self.gameData.completionTime.doubleValue + penaltyTime);
    self.totalTimeLabel.text = [MMXTimeIntervalFormatter stringWithInterval:self.gameData.completionTimeWithPenalty.floatValue
                                                              forFormatType:MMXTimeIntervalFormatTypeLong];
    
    if (self.gameData.gameType == MMXGameTypeCourse)
    {
        if (self.gameData.completionTimeWithPenalty.floatValue < self.gameData.threeStarTime.floatValue)
        {
            self.gameData.starRating = @3;
        }
        else if (self.gameData.completionTimeWithPenalty.floatValue < self.gameData.twoStarTime.floatValue)
        {
            self.gameData.starRating = @2;
        }
        else
        {
            self.gameData.starRating = @1;
        }
    }
    
    
    // TODO: actaully implement the logic to show "new record".
    self.recordLabel.hidden = YES;
    
    // TODO: Make the best time bigger if it's a record, just like total time.
    
    
    
    if (self.gameData.gameType == MMXGameTypeCourse)
    {
        // Pull out top score.
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MMXTopScore"
                                                             inManagedObjectContext:self.managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entityDescription];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lessonID == %@", self.gameData.lessonID];
        [fetchRequest setPredicate:predicate];
        
        NSError *fetchError = nil;
        NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
        
        MMXTopScore *topScoreForLesson;
        if (fetchedResults.count > 0)
        {
            topScoreForLesson = fetchedResults[0];
            if (topScoreForLesson.time < self.gameData.completionTimeWithPenalty)
            {
                topScoreForLesson.lessonID = [self.gameData.lessonID copy];
                topScoreForLesson.time = [self.gameData.completionTimeWithPenalty copy];
                topScoreForLesson.stars = [self.gameData.starRating copy];
                topScoreForLesson.gameData = self.gameData;
            }
        }
        else
        {
            topScoreForLesson = [NSEntityDescription insertNewObjectForEntityForName:@"MMXTopScore"
                                                              inManagedObjectContext:self.managedObjectContext];
            
            topScoreForLesson.lessonID = self.gameData.lessonID;
            topScoreForLesson.time = self.gameData.completionTimeWithPenalty;
            topScoreForLesson.stars = self.gameData.starRating;
            topScoreForLesson.gameData = self.gameData;
        }
    }
    
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    if (error)
    {
        NSLog(@"MOC: %@", error.description);
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kMMXResultsDidSaveGameNotification object:nil];
    }
    
    if (self.gameData.gameType == MMXGameTypeCourse)
    {
        [self.menuButton changeButtonToColor:[UIColor mmx_blueColor]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playerTappedMenuButton:(id)sender
{
    NSString *secondOption;
    if (self.gameData.gameType == MMXGameTypePractice)
    {
        secondOption = NSLocalizedString(@"Change Settings", nil);
    }
    else
    {
        secondOption = NSLocalizedString(@"Show Lessons", nil);
    }
    
    NSString *message = NSLocalizedString(@"The game is over. What would you like to do?", nil);
    NSArray *otherButtonTitles = @[NSLocalizedString(@"Main Menu", nil), NSLocalizedString(@"Try Again", nil), secondOption];
    KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:message
                                                                    delegate:self
                                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                           otherButtonTitles:otherButtonTitles];
    decisionView.fontName = @"Futura-Medium";
    
    [decisionView showAndDimBackgroundWithPercent:0.50];
}

#pragma mark - KMODecisionViewDelegate

- (void)decisionView:(KMODecisionView *)decisionView tappedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // Player cancelled. Do nothing.
    }
    else if (buttonIndex == 1) // Player decided to return to the main menu.
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (buttonIndex == 2) // Player wants to try again.
    {
         [self performSegueWithIdentifier:@"MMXUnwindToGameSegue" sender:self];
    }
    else if (buttonIndex == 3)
    {
        // Player wanted to change the settings or the course.
        if (self.gameData.gameType == MMXGameTypePractice)
        {
            [self performSegueWithIdentifier:@"MMXUnwindToPracticeConfigurationSegue" sender:self];
        }
        else // Player wanted to view the list of lessons for the current course.
        {
            [self performSegueWithIdentifier:@"MMXUnwindToLessonsSegue" sender:self];
        }
    }
}

@end
