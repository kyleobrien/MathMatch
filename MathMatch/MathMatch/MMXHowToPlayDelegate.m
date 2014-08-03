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
@property (nonatomic, weak) MMXCardViewController *currentCardViewController;
@property (nonatomic, weak) MMXCard *currentCard;

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
        case MMXTutorialStep03:
        {
            [self.currentCardViewController removeGlow];
            
            message = NSLocalizedString(@"Nice. Now find the number that adds with 6 to make 10.", nil);
            cancelButtonTitle = NSLocalizedString(@"Got it.", nil);
            
            break;
        }
        case MMXTutorialStep04:
        {
            [self.currentCardViewController removeGlow];
            
            message = NSLocalizedString(@"Good job! 6 plus 4 equals 10. Let's do one more to see if you've got the hang of it. This time you can pick any card you like.", nil);
            cancelButtonTitle = NSLocalizedString(@"Cool.", nil);
            
            break;
        }
        case MMXTutorialStep05:
        {
            message = [NSString stringWithFormat:NSLocalizedString(@"%ld? Good choice! Remember your next choice needs to add together with %ld to make 10.", nil), (long)self.currentCard.value, (long)self.currentCard.value];
            cancelButtonTitle = NSLocalizedString(@"Yeah, yeah.", nil);
            
            break;
        }
        case MMXTutorialStep06:
        {
            [self.suggestionTimer invalidate];
            [self.currentCardViewController removeGlow];
            
            message = NSLocalizedString(@"Success! You've got some serious math skills. Ready for something a little harder?", nil);
            cancelButtonTitle = NSLocalizedString(@"Let's do it.", nil);
            
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

- (BOOL)shouldFlipCard:(MMXCard *)card
{
    BOOL shouldFlip = NO;
    
    switch (self.currentStep)
    {
        case MMXTutorialStep03:
        {
            if (card.value == 6)
            {
                shouldFlip = YES;
            }
            
            break;
        }
        case MMXTutorialStep04:
        {
            if (card.value == 4)
            {
                shouldFlip = YES;
            }
            
            break;
        }
        case MMXTutorialStep05:
        {
            self.currentCard = card;
            
            shouldFlip = YES;
            
            break;
        }
        case MMXTutorialStep06:
        {
            if (card.value == (10 - self.currentCard.value))
            {
                shouldFlip = YES;
            }
            
            break;
        }
        default:
        {
            break;
        }
    }
    
    return shouldFlip;
}

- (void)showSuggestion:(NSTimer *)timer
{
    [self.suggestionTimer invalidate];
    
    switch (self.currentStep)
    {
        case MMXTutorialStep06:
        {
            [self.currentCardViewController applyGLow];
            
            break;
        }
        default:
        {
            break;
        }
    }
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
                    self.currentCardViewController = cardViewController;
                    
                    [cardViewController applyGLow];
                    [self.currentGameViewController allowPlayerInputAndStartGame];
                }
            }
            
            break;
        }
        case MMXTutorialStep03:
        {
            for (MMXCardViewController *cardViewController in self.currentGameViewController.cardsList)
            {
                if (cardViewController.card.value == 4)
                {
                    self.currentCardViewController = cardViewController;
                    
                    [cardViewController applyGLow];
                }
            }
            
            break;
        }
        case MMXTutorialStep04:
        {
            break;
        }
        case MMXTutorialStep05:
        {
            for (MMXCardViewController *cardViewController in self.currentGameViewController.cardsList)
            {
                if (cardViewController.card.value == (10 - self.currentCard.value))
                {
                    self.currentCardViewController = cardViewController;
                    
                    self.suggestionTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                                            target:self
                                                                          selector:@selector(showSuggestion:)
                                                                          userInfo:nil
                                                                           repeats:NO];
                }
            }
        }
        default:
        {
            break;
        }
    }
    
    self.currentStep += 1;
}

@end
