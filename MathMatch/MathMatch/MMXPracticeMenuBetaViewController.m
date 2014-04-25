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

@property (nonatomic, assign) NSInteger targetNumber;

@property (nonatomic, assign) BOOL haveAnyButtonsBeenTapped;

@end

@implementation MMXPracticeMenuBetaViewController

NSString * const kMMXUserDefaultsPracticeTargetNumber = @"MMXUserDefaultsPracticeTargetNumber";

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.haveAnyButtonsBeenTapped = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sanity check to make sure the stored target number isn't something crazy.
    
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
    
    self.targetNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gameConfiguration.targetNumber];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_orangeColor];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MMXGameViewController *gameViewController = (MMXGameViewController *)segue.destinationViewController;
    gameViewController.gameConfiguration = self.gameConfiguration;
}

#pragma mark - Player Action

- (IBAction)numberButtonWasTapped:(id)sender
{
    UIButton *numberButton = (UIButton *)sender;
    NSInteger digit = numberButton.tag - 10;
    
    if (digit == 10)
    {
        // Player tapped "Clear" button.
        
        self.haveAnyButtonsBeenTapped = YES;
        self.targetNumber = 0;
        
        self.startBarButtonItem.enabled = NO;
        self.targetNumberLabel.text = @"0";
    }
    else
    {
        // Player tapped one of the 0 - 9 buttons.
        
        if (self.haveAnyButtonsBeenTapped)
        {
            // Capping the target at 999 by ignoring input if it would make the target greater or equal to 100.
            if (((self.targetNumber > 0) || (digit > 0)) && (self.targetNumber < 100))
            {
                self.targetNumber = (self.targetNumber * 10) + digit;
            }
        }
        else
        {
            self.haveAnyButtonsBeenTapped = YES;
            self.targetNumber = digit;
        }
        
        // Don't let the player start the game if they target number is 0.
        
        if ((self.targetNumber == 0) && (digit == 0))
        {
            self.startBarButtonItem.enabled = NO;
        }
        else
        {
            self.startBarButtonItem.enabled = YES;
            
            [[NSUserDefaults standardUserDefaults] setInteger:self.targetNumber forKey:kMMXUserDefaultsPracticeTargetNumber];
            self.gameConfiguration.targetNumber = self.targetNumber;
        }
        
        self.targetNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.targetNumber];
    }
}

@end
