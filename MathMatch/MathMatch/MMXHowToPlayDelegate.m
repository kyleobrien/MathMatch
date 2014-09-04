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
    
    BOOL shouldShowPrompt = YES;
    
    [self.suggestionTimer invalidate];
    
    switch (self.currentStep)
    {
        case MMXTutorialStep01:
        {
            message = NSLocalizedString(@"Time to learn how to play Math Match.", nil);
            cancelButtonTitle = NSLocalizedString(@"Let's get started!", nil);
            
            break;
        }
        case MMXTutorialStep02:
        {
            message = NSLocalizedString(@"Your job is to pick two cards that make the equation true. Start by picking the number 6.", nil);
            cancelButtonTitle = NSLocalizedString(@"Okay!", nil);
            
            break;
        }
        case MMXTutorialStep03:
        {
            [self.currentCardViewController removeGlow];
            
            message = NSLocalizedString(@"Nice. Now 6 plus what number equals 10?", nil);
            cancelButtonTitle = NSLocalizedString(@"Got it.", nil);
            
            break;
        }
        case MMXTutorialStep04:
        {
            [self.currentCardViewController removeGlow];
            
            message = NSLocalizedString(@"Good job! 6 + 4 = 10. Let’s do one more. Choose any card.", nil);
            cancelButtonTitle = NSLocalizedString(@"Cool.", nil);
            
            break;
        }
        case MMXTutorialStep05:
        {
            message = [NSString stringWithFormat:NSLocalizedString(@"%ld? Good choice! %ld plus what number equals 10?", nil), (long)self.currentCard.value, (long)self.currentCard.value];
            cancelButtonTitle = NSLocalizedString(@"Ready to choose.", nil);
            
            break;
        }
        case MMXTutorialStep06:
        {
            [self.currentCardViewController removeGlow];
            
            message = NSLocalizedString(@"Success! You've got some serious math skills. Ready for something a little harder?", nil);
            cancelButtonTitle = NSLocalizedString(@"Let's do it.", nil);
            
            break;
        }
        case MMXTutorialStep07:
        {
            message = NSLocalizedString(@"Same game as before, but now the cards are only face up for 5 seconds and then they flip over. Ready to memorize?", nil);
            cancelButtonTitle = NSLocalizedString(@"Ready.", nil);
            
            break;
        }
        case MMXTutorialStep08:
        {
            message = NSLocalizedString(@"Find the 7.", nil);
            cancelButtonTitle = NSLocalizedString(@"Okay.", nil);
            
            break;
        }
        case MMXTutorialStep09:
        {
            [self.currentCardViewController removeGlow];
            
            message = NSLocalizedString(@"Great! Now what number added to 7 makes 10? 7 + 3 = 10. Find the 3.", nil);
            cancelButtonTitle = NSLocalizedString(@"Will do.", nil);
            
            break;
        }
        case MMXTutorialStep10:
        {
            [self.currentCardViewController removeGlow];
            
            message = NSLocalizedString(@"See, that wasn't so bad. Try one more time. You can pick any card you like.", nil);
            cancelButtonTitle = NSLocalizedString(@"Done and done.", nil);
            
            break;
        }
        case MMXTutorialStep11:
        {
            message = [NSString stringWithFormat:NSLocalizedString(@"What adds together with %ld to make 10?", nil), (long)self.currentCard.value];
            cancelButtonTitle = NSLocalizedString(@"Hang on.", nil);
            
            break;
        }
        case MMXTutorialStep12:
        {
            [self.currentCardViewController removeGlow];
            
            message = NSLocalizedString(@"Hooray! We’re almost done. One more type of game.", nil);
            cancelButtonTitle = NSLocalizedString(@"Alright.", nil);
            
            break;
        }
        case MMXTutorialStep13:
        {
            message = NSLocalizedString(@"Same game as before, but now the cards all start face down. Good luck!", nil);
            cancelButtonTitle = NSLocalizedString(@"Yeah!", nil);
            
            break;
        }
        case MMXTutorialStep14:
        {
            shouldShowPrompt = NO;
            
            [self.currentGameViewController allowPlayerInputAndStartGame];
            
            break;
        }
        default:
        {
            break;
        }
    }
    
    if (shouldShowPrompt)
    {
        KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:message
                                                                        delegate:self
                                                               cancelButtonTitle:cancelButtonTitle
                                                               otherButtonTitles:nil];
        [decisionView showInViewController:self.currentGameViewController.navigationController andDimBackgroundWithPercent:0.50];
    }
}

- (void)respondToIncorrectSelectionOfCardViewController:(MMXCardViewController *)cardViewController
                                  andGameViewController:(MMXGameViewController *)gameViewController;
{    
    switch (self.currentStep)
    {
        case MMXTutorialStep03:
        case MMXTutorialStep04:
        case MMXTutorialStep06:
        {
            [cardViewController selectCard];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                [cardViewController deselectCard];
            });
            
            break;
        }
        case MMXTutorialStep09:
        case MMXTutorialStep10:
        case MMXTutorialStep12:
        {
            [cardViewController flipCardFaceUp];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                [cardViewController flipCardFaceDown];
            });
            
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)finishedClearingTableauForGameViewController:(MMXGameViewController *)gameViewController
{
    switch (self.currentStep)
    {
        case MMXTutorialStep07:
        {
            gameViewController.gameData.startingPositionType = MMXStartingPositionTypeMemorize;
            gameViewController.gameData.cardStyle = MMXCardStyleVelvet;
            
            [gameViewController startNewGame];
            [self advanceTutorialForGameViewController:gameViewController];
            
            break;
        }
        case MMXTutorialStep13:
        {
            gameViewController.gameData.startingPositionType = MMXStartingPositionTypeFaceDown;
            gameViewController.gameData.cardStyle = MMXCardStyleCitrus;
            
            [gameViewController startNewGame];
            [self advanceTutorialForGameViewController:gameViewController];
            
            break;
        }
        default:
        {
            break;
        }
    }
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
        case MMXTutorialStep09:
        {
            if (card.value == 7)
            {
                shouldFlip = YES;
            }
            
            break;
        }
        case MMXTutorialStep10:
        {
            if (card.value == 3)
            {
                shouldFlip = YES;
            }
            
            break;
        }
        case MMXTutorialStep11:
        {
            self.currentCard = card;
            
            shouldFlip = YES;
            
            break;
        }
        case MMXTutorialStep12:
        {
            if (card.value == (10 - self.currentCard.value))
            {
                shouldFlip = YES;
            }
            
            break;
        }
        case MMXTutorialStep13:
        case MMXTutorialStep14:
        {
            shouldFlip = YES;
            
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
        case MMXTutorialStep09:
        case MMXTutorialStep10:
        case MMXTutorialStep12:
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

- (void)completedGameForGameViewController:(MMXGameViewController *)gameViewController
{    
    NSString *message = NSLocalizedString(@"You made it through the tutorial! Now get started matching!", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"YEAH!", nil);
    
    KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:message
                                                                    delegate:self
                                                           cancelButtonTitle:cancelButtonTitle
                                                           otherButtonTitles:nil];
    [decisionView showInViewController:self.currentGameViewController.navigationController andDimBackgroundWithPercent:0.50];
}

#pragma mark - KMODecisionViewDelegate

- (void)decisionView:(KMODecisionView *)decisionView tappedButtonAtIndex:(NSInteger)buttonIndex
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    switch (self.currentStep)
    {
        case MMXTutorialStep01:
        {
            [self.currentGameViewController arrangDeckOntoTableauAndStartDealing:YES];
                        
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
                }
            }
            
            [self.currentGameViewController allowPlayerInputAndStartGame];
            
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
                    
                    self.suggestionTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                                            target:self
                                                                          selector:@selector(showSuggestion:)
                                                                          userInfo:nil
                                                                           repeats:NO];
                }
            }
            
            break;
        }
        case MMXTutorialStep06:
        {
            [self.currentGameViewController clearEquation];
            [self.currentGameViewController removeCardFromTableauWithIndex:0];
            
            break;
        }
        case MMXTutorialStep07:
        {
            [self.currentGameViewController arrangDeckOntoTableauAndStartDealing:YES];
            
            break;
        }
        case MMXTutorialStep08:
        {
            for (MMXCardViewController *cardViewController in self.currentGameViewController.cardsList)
            {
                if (cardViewController.card.value == 7)
                {
                    self.currentCardViewController = cardViewController;
                    
                    self.suggestionTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                                            target:self
                                                                          selector:@selector(showSuggestion:)
                                                                          userInfo:nil
                                                                           repeats:NO];
                }
            }
            
            [self.currentGameViewController allowPlayerInputAndStartGame];
            
            break;
        }
        case MMXTutorialStep09:
        {
            for (MMXCardViewController *cardViewController in self.currentGameViewController.cardsList)
            {
                if (cardViewController.card.value == 3)
                {
                    self.currentCardViewController = cardViewController;
                    
                    self.suggestionTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                                            target:self
                                                                          selector:@selector(showSuggestion:)
                                                                          userInfo:nil
                                                                           repeats:NO];
                }
            }
            
            break;
        }
        case MMXTutorialStep10:
        {
            break;
        }
        case MMXTutorialStep11:
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
            
            break;
        }
        case MMXTutorialStep12:
        {
            [self.currentGameViewController clearEquation];
            [self.currentGameViewController removeCardFromTableauWithIndex:0];
            
            break;
        }
        case MMXTutorialStep13:
        {
            [self.currentGameViewController arrangDeckOntoTableauAndStartDealing:YES];
            
            break;
        }
        case MMXTutorialStep14:
        {
            [self.currentGameViewController.navigationController popViewControllerAnimated:YES];
            
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
