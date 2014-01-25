//
//  MMXPracticeMenuBetaViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.24.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXGameViewController.h"
#import "MMXPracticeMenuBetaViewController.h"

@interface MMXPracticeMenuBetaViewController ()

@property (assign) NSInteger targetNumber;

@end

@implementation MMXPracticeMenuBetaViewController

NSString * const kMMXUserDefaultsPracticeTargetNumber = @"MMXUserDefaultsPracticeTargetNumber";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Make sure the stored target number isn't something crazy.
    
    NSInteger targetNumber = [[NSUserDefaults standardUserDefaults] integerForKey:kMMXUserDefaultsPracticeTargetNumber];
    if (targetNumber <= 0)
    {
        targetNumber = 10;
    }
    else if (targetNumber > 999)
    {
        targetNumber = 10;
    }
    
    self.targetNumber = targetNumber;
    self.gameConfiguration.targetNumber = targetNumber;
    self.targetNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)targetNumber];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(3.0 / 255.0)
                                                                           green:(228.0 / 255.0)
                                                                            blue:(90.0 / 255.0)
                                                                           alpha:1.0];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MMXGameViewController *gameViewController = (MMXGameViewController *)segue.destinationViewController;
    gameViewController.gameConfiguration = self.gameConfiguration;
}

#pragma mark - User Action

- (IBAction)numberButtonWasTapped:(id)sender
{
    UIButton *numberButton = (UIButton *)sender;
    NSInteger digit = numberButton.tag - 10;
    
    if (digit == 10)
    {
        // Player tapped "Clear" button.
        
        self.startBarButtonItem.enabled = NO;
        self.targetNumberLabel.text = @"0";
        
        self.targetNumber = 0;
    }
    else
    {
        // Player tapped one of the 0 - 9 buttons.
        
        if (((self.targetNumber > 0) || (digit > 0)) && (self.targetNumber < 100))
        {
            self.targetNumber = (self.targetNumber * 10) + digit;
            
            self.gameConfiguration.targetNumber = self.targetNumber;
            
            [[NSUserDefaults standardUserDefaults] setInteger:self.targetNumber forKey:kMMXUserDefaultsPracticeTargetNumber];
            self.gameConfiguration.targetNumber = self.targetNumber;
            
            self.targetNumberLabel.text = [NSString stringWithFormat:@"%ld", self.targetNumber];
            self.startBarButtonItem.enabled = YES;
        }
    }
}

@end
