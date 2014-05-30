//
//  MMXResultsViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.4.18.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXResultsViewController.h"
#import "MMXTimeIntervalFormatter.h"

@interface MMXResultsViewController ()

@end

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
    
    NSTimeInterval totalTime = self.gameData.completionTime.doubleValue + penaltyTime;
    self.totalTimeLabel.text = [MMXTimeIntervalFormatter stringWithInterval:totalTime
                                                              forFormatType:MMXTimeIntervalFormatTypeLong];
    
    // TODO: actaully implement the logic to show "new record".
    self.recordLabel.hidden = YES;
    
    // TODO: Make the best time bigger if it's a record, just like total time.
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
