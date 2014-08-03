//
//  MMXHowToPlayDelegate.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.7.29.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXCardViewController.h"
#import "MMXHowToPlayDelegate.h"

@interface MMXHowToPlayDelegate ()

@property (nonatomic, assign) MMXTutorialStep currentStep;

@property (nonatomic, weak) MMXGameViewController *currentGameViewController;

@end

@implementation MMXHowToPlayDelegate

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.currentStep = MMXTutorialStep01;
    }
    
    return self;
}

- (void)advanceTutorialForGameViewController:(MMXGameViewController *)gameViewControlller
{
    self.currentGameViewController = gameViewControlller;
    
    NSString *message;
    NSString *cancelButtonTitle;
    
    switch (self.currentStep)
    {
        case MMXTutorialStep01:
        {
            message = NSLocalizedString(@"Hey, listen! We're going to learn how to play Math Match. Tap the button below when you're ready.", nil);
            cancelButtonTitle = NSLocalizedString(@"Let's get started!", nil);
            
            break;
        }
        case MMXTutorialStep02:
        {
            message = NSLocalizedString(@"Your job is to pick two cards that make the equation true. Let's start by picking the card with the number 6.", nil);
            cancelButtonTitle = NSLocalizedString(@"Okay!", nil);
            
            break;
        }
        default:
        {
            break;
        }
    }
    
    KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:message
                                                                    delegate:self
                                                           cancelButtonTitle:cancelButtonTitle
                                                           otherButtonTitles:nil];
    [decisionView showAndDimBackgroundWithPercent:0.25];
}

#pragma mark - KMODecisionViewDelegate

- (void)decisionView:(KMODecisionView *)decisionView tappedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (self.currentStep)
    {
        case MMXTutorialStep01:
        {
            [self.currentGameViewController arrangDeckOntoTableauAndStartDealing];
                        
            break;
        }
        case MMXTutorialStep02:
        {
            for (MMXCardViewController *cardViewController in self.currentGameViewController.cardsList)
            {
                if (cardViewController.card.value == 6)
                {
                    [cardViewController applyGLow];
                }
            }
            
            break;
        }
        default:
        {
            break;
        }
    }
    
    self.currentStep += 1;
}

@end
