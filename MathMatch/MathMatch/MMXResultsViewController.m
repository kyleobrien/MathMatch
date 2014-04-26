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
    
    CGFloat minutes = floor(self.gameConfiguration.totalElapsedTime / 60);
    CGFloat seconds = floorf(self.gameConfiguration.totalElapsedTime - minutes * 60);
    
    if ((seconds >= 60.0) && (seconds < 61.0))
    {
        minutes += 1.0;
        seconds = 0.0;
    }
    
    self.timeLabel.text = [MMXTimeIntervalFormatter stringWithInterval:self.gameConfiguration.totalElapsedTime
                                                         forFormatType:MMXTimeIntervalFormatTypeLong];
    self.incorrectMatchesLabel.text = [NSString stringWithFormat:@"%ld", self.gameConfiguration.incorrectMatches];
    self.penaltyMultiplierLabel.text = [NSString stringWithFormat:@"x %2.1fs", self.gameConfiguration.penaltyMultiplier];
    
    NSTimeInterval penaltyTime = self.gameConfiguration.incorrectMatches * self.gameConfiguration.penaltyMultiplier;
    self.penaltyTimeLabel.text = [MMXTimeIntervalFormatter stringWithInterval:penaltyTime
                                                                forFormatType:MMXTimeIntervalFormatTypeLong];
    
    NSTimeInterval totalTime = self.gameConfiguration.totalElapsedTime + penaltyTime;
    self.totalTimeLabel.text = [MMXTimeIntervalFormatter stringWithInterval:totalTime
                                                              forFormatType:MMXTimeIntervalFormatTypeLong];
    
    // TODO: actaully implement the logic to show "new record".
    self.recordLabel.hidden = YES;
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
    if (self.gameConfiguration.gameType == MMXGameTypePractice)
    {
        secondOption = NSLocalizedString(@"Change Settings", nil);
    }
    else
    {
        // TODO: WHAT SHOULD WE DO?
    }
    
    NSArray *otherButtonTitles = @[NSLocalizedString(@"Main Menu", nil), NSLocalizedString(@"Play Again", nil), secondOption];
    KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:NSLocalizedString(@"What would you like to do?", nil)
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
    else if (buttonIndex == 1)
    {
        // Player decided to return to the main menu.
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (buttonIndex == 2)
    {
         [self performSegueWithIdentifier:@"MMXUnwindToGameSegue" sender:self];
    }
    else if (buttonIndex == 3)
    {
        // Player wanted to change the settings or the course.
        if (self.gameConfiguration.gameType == MMXGameTypePractice)
        {
            [self performSegueWithIdentifier:@"MMXUnwindToPracticeConfigurationSegue" sender:self];
        }
        else
        {
            // TODO: Action for course.
        }
    }
}

@end
