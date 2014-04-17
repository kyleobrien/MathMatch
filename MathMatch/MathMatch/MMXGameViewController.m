//
//  MMXGameViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.25.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXCard.h"
#import "MMXGameViewController.h"

@interface MMXGameViewController ()

@property (nonatomic, assign) MMXGameState gameState;

@property (nonatomic, strong) MMXCardViewController *firstCardViewController;
@property (nonatomic, strong) MMXCardViewController *secondCardViewController;

@property (nonatomic, strong) NSMutableArray *deck;
@property (nonatomic, strong) NSMutableArray *deck2;

@property (nonatomic, strong) UILabel *customNavigationBarTitle;

@property (nonatomic, assign) CGFloat cardWidth;
@property (nonatomic, assign) CGFloat cardHeight;
@property (nonatomic, assign) CGFloat cardFontSize;

@property (nonatomic, strong) NSArray *numberOfCardsInRow;

@property (nonatomic, strong) NSTimer *gameClockTimer;
@property (nonatomic, strong) NSTimer *memorySpeedTimer;
@property (nonatomic, assign) CGFloat memoryTimeRemaining;

@property (nonatomic, assign) NSInteger matchesAttempted;
@property (nonatomic, assign) NSInteger matchesFailed;
@property (nonatomic, assign) NSTimeInterval elapsedTime;

@end

@implementation MMXGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    // Draw bottom borders on the parts of the formula that the player provides.
    
    if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction) ||
        (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision))
    {
        CALayer *bottomBorderZ = [CALayer layer];
        bottomBorderZ.frame = CGRectMake(0.0, self.zNumberLabel.frame.size.height - 2.0, self.zNumberLabel.frame.size.width, 2.0);
        bottomBorderZ.backgroundColor = [UIColor colorWithRed:(43.0/255.0) green:(43.0/255.0) blue:(43.0/255.0) alpha:1.0].CGColor;
        
        [self.zNumberLabel.layer addSublayer:bottomBorderZ];
    }
    else if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition) ||
             (self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication))
    {
        CALayer *bottomBorderX = [CALayer layer];
        bottomBorderX.frame = CGRectMake(0.0, self.xNumberLabel.frame.size.height - 2.0, self.xNumberLabel.frame.size.width, 2.0);
        bottomBorderX.backgroundColor = [UIColor colorWithRed:(43.0/255.0) green:(43.0/255.0) blue:(43.0/255.0) alpha:1.0].CGColor;
        
        [self.xNumberLabel.layer addSublayer:bottomBorderX];
    }
    
    CALayer *bottomBorderY = [CALayer layer];
    bottomBorderY.frame = CGRectMake(0.0, self.yNumberLabel.frame.size.height - 2.0, self.yNumberLabel.frame.size.width, 2.0);
    bottomBorderY.backgroundColor = [UIColor colorWithRed:(43.0/255.0) green:(43.0/255.0) blue:(43.0/255.0) alpha:1.0].CGColor;
    
    [self.yNumberLabel.layer addSublayer:bottomBorderY];
    
    // Update the UI to reflect the current operation.
    
    if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition)
    {
        self.aFormulaLabel.text = @"+";
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction)
    {
        self.aFormulaLabel.text = @"−";
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication)
    {
        self.aFormulaLabel.text = @"×";
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision)
    {
        self.aFormulaLabel.text = @"÷";
    }
    
    [self startNewGame];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self arrangDeckOntoPlaySpace];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"unwindToPracticeConfigurationSegue"])
    {
        [self terminateCurrentGame];
    }
}

#pragma mark - Player Action

- (IBAction)playerTappedPauseButton:(id)sender
{
    [self.gameClockTimer invalidate];
    
    NSString *secondOption;
    if (self.gameConfiguration.gameType == MMXGameTypePractice)
    {
        secondOption = NSLocalizedString(@"Change Settings", nil);
    }
    else
    {
        // TODO: WHAT SHOULD WE DO?
    }
    
    KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:NSLocalizedString(@"The game is paused. What would you like to do?", nil)
                                                                    delegate:self
                                                           cancelButtonTitle:NSLocalizedString(@"Keep Playing", nil)
                                                           otherButtonTitles:@[@"Quit", secondOption]];
    decisionView.fontName = @"Futura-Medium";
    
    [decisionView showAndDimBackgroundWithPercent:0.50];
}

#pragma mark - Game State

- (void)startNewGame
{
    [self removeDeckFromPlaySpace];
    
    // TODO: Make sure these are all the variables that need to be reset.
    
    self.firstCardViewController = nil;
    self.secondCardViewController = nil;
    
    self.matchesAttempted = 0;
    self.matchesFailed = 0;
    self.elapsedTime = 0.0;
    
    self.xNumberLabel.text = @"";
    self.yNumberLabel.text = @"";
    self.zNumberLabel.text = @"";
    
    if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition)
    {
        self.zNumberLabel.text = [NSString stringWithFormat:@"%ld", self.gameConfiguration.targetNumber];
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction)
    {
        self.xNumberLabel.text = [NSString stringWithFormat:@"%ld", self.gameConfiguration.targetNumber];
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication)
    {
        self.zNumberLabel.text = [NSString stringWithFormat:@"%ld", self.gameConfiguration.targetNumber];
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision)
    {
        self.xNumberLabel.text = [NSString stringWithFormat:@"%ld", self.gameConfiguration.targetNumber];
    }
    
    self.customNavigationBarTitle.text = @"";
    
    self.pauseBarButtonItem.enabled = NO;
    
    self.gameState = MMXGameStatePreGame;
    
    [self createDeck];
    
    [self.gameClockTimer invalidate];
}

- (void)allowPlayerInput
{
    self.gameState = MMXGameStateStart;
    
    self.pauseBarButtonItem.enabled = YES;
    
    [self generateCustomNavigationBarViewForTitle:NSLocalizedString(@"Time - 00:00", nil)];
    
    self.gameClockTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60.0)
                                                           target:self
                                                         selector:@selector(updateClock)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)terminateCurrentGame
{
    // TODO: ALL the things! (tear them down)
}

- (void)createDeck
{
    self.deck2 = [NSMutableArray arrayWithCapacity:self.gameConfiguration.numberOfCards];
    
    if (self.gameConfiguration.numberOfCards == 8)
    {
        self.cardWidth = 88.0;
        self.cardHeight = 88.0;
        self.cardFontSize = 33.0;
        
        self.numberOfCardsInRow = @[@3, @2, @3];
    }
    else if (self.gameConfiguration.numberOfCards == 12)
    {
        self.cardWidth = 77.0;
        self.cardHeight = 77.0;
        self.cardFontSize = 33.0;
        
        self.numberOfCardsInRow = @[@3, @3, @3, @3];
    }
    else if (self.gameConfiguration.numberOfCards == 16)
    {
        self.cardWidth = 66.0;
        self.cardHeight = 66.0;
        self.cardFontSize = 22.0;
        
        self.numberOfCardsInRow = @[@4, @4, @4, @4];
    }
    else if (self.gameConfiguration.numberOfCards == 20)
    {
        self.cardWidth = 55.0;
        self.cardHeight = 55.0;
        self.cardFontSize = 22.0;
        
        self.numberOfCardsInRow = @[@4, @4, @4, @4, @4];
    }
    else if (self.gameConfiguration.numberOfCards == 24)
    {
        self.cardWidth = 55.0;
        self.cardHeight = 55.0;
        self.cardFontSize = 22.0;
        
        self.numberOfCardsInRow = @[@4, @4, @4, @4, @4, @4];
    }
    else
    {
        self.cardWidth = 88.0;
        self.cardHeight = 88.0;
        self.cardFontSize = 33.0;
        
        self.numberOfCardsInRow = @[@3, @2, @3];
    }
    
    NSMutableArray *unshuffledCardValues = [NSMutableArray arrayWithCapacity:0];
    
    if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition) ||
        (self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction))
    {
        u_int32_t maxCardValue = floor(self.gameConfiguration.targetNumber / 2.0);
        
        while (unshuffledCardValues.count < self.gameConfiguration.numberOfCards)
        {
            NSInteger randomValue = arc4random_uniform(maxCardValue + 1);
 
            [unshuffledCardValues addObject:[NSNumber numberWithInteger:randomValue]];
            [unshuffledCardValues addObject:[NSNumber numberWithInteger:(self.gameConfiguration.targetNumber - randomValue)]];
        }
    }
    else if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication) ||
             (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision))
    {
        NSMutableArray *factors = [self factorizeNumber:self.gameConfiguration.targetNumber];
        
        // Use the factors to populate the unshuffled deck.
        if (factors.count > self.gameConfiguration.numberOfCards)
        {
            // Select without replacement.
            while (unshuffledCardValues.count < self.gameConfiguration.numberOfCards)
            {
                NSInteger randomIndex = arc4random_uniform(factors.count);
                NSInteger randomValue = ((NSNumber *)factors[randomIndex]).integerValue;

                [unshuffledCardValues addObject:[NSNumber numberWithInteger:randomValue]];
                [unshuffledCardValues addObject:[NSNumber numberWithInteger:(self.gameConfiguration.targetNumber / randomValue)]];
                
                [factors removeObjectAtIndex:randomIndex];
            }
        }
        else
        {
            while ((unshuffledCardValues.count + factors.count) < self.gameConfiguration.numberOfCards)
            {
                [unshuffledCardValues addObjectsFromArray:factors];
            }
            
            while (unshuffledCardValues.count < self.gameConfiguration.numberOfCards)
            {
                // Select without replacement.
                while (unshuffledCardValues.count < self.gameConfiguration.numberOfCards)
                {
                    NSInteger randomIndex = arc4random_uniform(factors.count);
                    NSInteger randomValue = ((NSNumber *)factors[randomIndex]).integerValue;
                    
                    [unshuffledCardValues addObject:[NSNumber numberWithInteger:randomValue]];
                    [unshuffledCardValues addObject:[NSNumber numberWithInteger:(self.gameConfiguration.targetNumber / randomValue)]];
                    
                    [factors removeObjectAtIndex:randomIndex];
                }
            }
        }
    }
    
    NSMutableArray *freshDeck = [NSMutableArray arrayWithCapacity:self.numberOfCardsInRow.count];
    
    for (int i = 0; i < self.numberOfCardsInRow.count; i++)
    {
        NSInteger numberOfCardsInThisRow = ((NSNumber *)self.numberOfCardsInRow[i]).integerValue;
        
        NSMutableArray *column = [NSMutableArray arrayWithCapacity:numberOfCardsInThisRow];
        
        for (int j = 0; j < numberOfCardsInThisRow; j++)
        {
            int randomIndex = arc4random() % [unshuffledCardValues count];
            MMXCard *card = [[MMXCard alloc] initWithValue:[[unshuffledCardValues objectAtIndex:randomIndex] integerValue]];
            MMXCardViewController *cvc = [[MMXCardViewController alloc] initWithNibName:@"MMXCardViewController"
                                                                           bundle:[NSBundle mainBundle]];
            cvc.card = card;
            cvc.delegate = self;
            cvc.fontSize = self.cardFontSize;
            
            [unshuffledCardValues removeObjectAtIndex:randomIndex];
            
            [column addObject:cvc];
            [self.deck2 addObject:cvc];
        }
        
        [freshDeck addObject:column];
    }
    
    self.deck = freshDeck;
}

#pragma mark - Board layout

- (void)arrangDeckOntoPlaySpace
{
    for (NSInteger i = 0; i < self.numberOfCardsInRow.count; i++)
    {
        NSMutableArray *rows = self.deck[i];
        
        NSInteger numberOfCardsInThisRow = ((NSNumber *)self.numberOfCardsInRow[i]).integerValue;
        
        for (NSInteger j = 0; j < numberOfCardsInThisRow; j++)
        {
            MMXCardViewController *cvc = rows[j];
            
            cvc.view.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height, self.cardWidth, self.cardHeight);
            
            cvc.row = i;
            
            [self.view addSubview:cvc.view];
        }
    }
    
    // I want the horizontal gaps to be the same, otherwise it looks weird.
    // So I'm going to loop once and choose the smallest gap.
    // This should only affect the 8 card layout.
    
    CGFloat widthOfGap = 1000.0;
    for (NSInteger i = 0; i < self.numberOfCardsInRow.count; i++)
    {
        NSInteger numberOfCardsInThisRow = ((NSNumber *)self.numberOfCardsInRow[i]).integerValue;
        
        CGFloat horizontalSpaceRemaining = self.view.bounds.size.width - (numberOfCardsInThisRow * self.cardWidth);
        CGFloat widthOfGapCandidate = horizontalSpaceRemaining / (numberOfCardsInThisRow + 1);
    
        if (widthOfGapCandidate < widthOfGap)
        {
            widthOfGap = widthOfGapCandidate;
        }
    }
    // END TRANSMISSION.
    
    CGFloat verticalSpaceAlreadyTaken = self.equationContainerView.frame.size.height + (self.numberOfCardsInRow.count * self.cardHeight);
    CGFloat verticalSpaceRemaining = self.view.bounds.size.height - verticalSpaceAlreadyTaken;
    CGFloat heightOfGap = verticalSpaceRemaining / (self.numberOfCardsInRow.count + 1);
    CGFloat yCoordinate = self.equationContainerView.frame.origin.x + self.equationContainerView.frame.size.height + heightOfGap;
    
    for (NSInteger i = 0; i < self.numberOfCardsInRow.count; i++)
    {
        NSMutableArray *rows = self.deck[i];
        
        NSInteger numberOfCardsInThisRow = ((NSNumber *)self.numberOfCardsInRow[i]).integerValue;
        
        CGFloat totalWidthOfCardsAndSpaced = (numberOfCardsInThisRow * self.cardWidth) + ((numberOfCardsInThisRow - 1) * widthOfGap);
        CGFloat xCoordinate = floorf((self.view.bounds.size.width - totalWidthOfCardsAndSpaced) / 2);
        
        for (NSInteger j = 0; j < numberOfCardsInThisRow; j++)
        {
            MMXCardViewController *cvc = rows[j];
            
            cvc.tableLocation = CGPointMake(roundf(xCoordinate), roundf(yCoordinate));
            cvc.cardSize = CGSizeMake(self.cardWidth, self.cardHeight);
            
            xCoordinate += self.cardWidth + widthOfGap;
        }
        
        yCoordinate += self.cardHeight + heightOfGap;
    }
    
    [self dealCardWithIndex:0];
}

- (void)dealCardWithIndex:(NSInteger)index
{
    MMXCardViewController *cvc = self.deck2[index];
    
    CGFloat animationDuration = 0.25 - (cvc.row * 0.02); // 0.02 is just a fudge factor based on what looks good.
    
    CGFloat center = self.view.frame.size.width / 2.0;
    cvc.view.frame = CGRectMake(center - cvc.view.frame.size.width + arc4random_uniform(cvc.view.frame.size.width),
                                cvc.view.frame.origin.y,
                                cvc.view.frame.size.width,
                                cvc.view.frame.size.height);
    
    
    // TODO: This looks a little wonky...
    NSInteger randomAngle = arc4random_uniform(15);
    //randomAngle += 30;
    if (arc4random_uniform(2) == 0)
    {
        randomAngle = -randomAngle;
    }
    
    cvc.view.transform = CGAffineTransformMakeRotation(randomAngle * M_PI / 180);
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
                     {
                         cvc.view.transform = CGAffineTransformIdentity;
                         
                         cvc.view.frame = CGRectMake(cvc.tableLocation.x,
                                                     cvc.tableLocation.y,
                                                     cvc.cardSize.width,
                                                     cvc.cardSize.height);
                     }
                     completion:^(BOOL finished)
                     {
                         if (finished && (index == (self.deck2.count - 1)))
                         {
                             if ((self.gameConfiguration.memorySpeed == MMXMemorySpeedSlow) ||
                                 (self.gameConfiguration.memorySpeed == MMXMemorySpeedFast))
                             {
                                 [self showFaceOfCardWithIndex:0];
                             }
                             else
                             {
                                 [self allowPlayerInput];
                             }
                         }
                     }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((animationDuration / 2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            if (index < (self.deck2.count - 1))
            {
                [self dealCardWithIndex:(index + 1)];
            }
        });
    });
}

- (void)showFaceOfCardWithIndex:(NSInteger)index
{
    MMXCardViewController *cvc = self.deck2[index];
    
    [cvc flipCardFaceUp];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            if (index < (self.deck2.count - 1))
            {
                [self showFaceOfCardWithIndex:(index + 1)];
            }
            else
            {
                [self showMemorySpeedCountdownTimer];
            }
        });
    });
}

- (void)showMemorySpeedCountdownTimer
{
    if (self.memorySpeedTimer)
    {
        if (self.memoryTimeRemaining <= 0.0)
        {
            self.customNavigationBarTitle.text = @"";
            
            [self showBackOfCardWithIndex:0];
        }
        else
        {
            self.memoryTimeRemaining -= 1.0 / 60.0;
            if (self.memoryTimeRemaining <= 0.0)
            {
                NSString *title = NSLocalizedString(@"Memorize - 0.00", nil);
                self.customNavigationBarTitle.text = title;
            }
            else
            {
                self.customNavigationBarTitle.text = [NSString stringWithFormat:@"%@ %01.2f", NSLocalizedString(@"Memorize -", nil), self.memoryTimeRemaining];
            }
            
            self.memorySpeedTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 60.0
                                                                     target:self
                                                                   selector:@selector(showMemorySpeedCountdownTimer)
                                                                   userInfo:nil
                                                                    repeats:NO];
        }
    }
    else
    {
        self.memoryTimeRemaining = 5.0;
        if (self.gameConfiguration.memorySpeed == MMXMemorySpeedSlow)
        {
            self.memoryTimeRemaining = 10.0;
        }
        
        [self generateCustomNavigationBarViewForTitle:NSLocalizedString(@"Memorize - 0:00", nil)];
        self.customNavigationBarTitle.text = [NSString stringWithFormat:@"%@ %01.2f", NSLocalizedString(@"Memorize -", nil), self.memoryTimeRemaining];
        self.memorySpeedTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 60.0
                                                                 target:self
                                                               selector:@selector(showMemorySpeedCountdownTimer)
                                                               userInfo:nil
                                                                repeats:NO];
    }
}

- (void)showBackOfCardWithIndex:(NSInteger)index
{
    MMXCardViewController *cvc = self.deck2[index];
    
    [cvc flipCardFaceDown];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           if (index < (self.deck2.count - 1))
                           {
                               [self showBackOfCardWithIndex:(index + 1)];
                           }
                           else
                           {
                               [self allowPlayerInput];
                           }
                       });
    });
}

- (void)removeDeckFromPlaySpace
{
    for (int i = 0; i < self.numberOfCardsInRow.count; i++)
    {
        NSMutableArray *rows = self.deck[i];
        NSInteger numberOfCardsInThisRow = ((NSNumber *)self.numberOfCardsInRow[i]).integerValue;
        
        for (int j = 0; j < numberOfCardsInThisRow; j++)
        {
            MMXCardViewController *cvc = rows[j];
            [cvc.view removeFromSuperview];
        }
    }
    
    self.deck = nil;
}

- (void)evaluateFormula
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        NSInteger result;
        BOOL success;
        
        if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition)
        {
            result = self.firstCardViewController.card.value + self.secondCardViewController.card.value;
            
            //self.zNumberLabel.text = [NSString stringWithFormat:@"%ld", result];
        }
        else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction)
        {
            result = self.firstCardViewController.card.value + self.secondCardViewController.card.value;
            
            //self.xNumberLabel.text = [NSString stringWithFormat:@"%ld", result];
        }
        else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication)
        {
            result = self.firstCardViewController.card.value * self.secondCardViewController.card.value;
            
            //self.zNumberLabel.text = [NSString stringWithFormat:@"%ld", result];
        }
        else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision)
        {
            result = self.firstCardViewController.card.value * self.secondCardViewController.card.value;
            
            //self.xNumberLabel.text = [NSString stringWithFormat:@"%ld", result];
        }
        
        if (result == self.gameConfiguration.targetNumber)
        {
            success = YES;
        }
        else
        {
            success = NO;
            
            self.matchesFailed += 1;
        }
        
        self.matchesAttempted += 1;
        
        if (success)
        {
            [UIView animateWithDuration:0.1 animations:^
             {
                 self.equationCorrectnessView.backgroundColor = [UIColor colorWithRed:(76.0 / 255.0)
                                                                                green:(217.0 / 255.0)
                                                                                 blue:(100.0 / 255.)
                                                                                alpha:1.0];
             }];
        }
        else
        {
            [UIView animateWithDuration:0.1 animations:^
             {
                 self.equationCorrectnessView.backgroundColor = [UIColor colorWithRed:(255.0 / 255.0)
                                                                                green:(0.0 / 255.0)
                                                                                 blue:(64.0 / 255.)
                                                                                alpha:1.0];
             }];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
        {
            [self proceedToNextTurnAfterSuccessfulMatch:success];
        });
    });
}

- (void)proceedToNextTurnAfterSuccessfulMatch:(BOOL)success
{
    [UIView animateWithDuration:0.1 animations:^
    {
        self.equationCorrectnessView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    }];
    
    if (success)
    {
        // Check if there are any cards on the table still face down, let the game continue.
        
        BOOL stopPlaying = YES;
        for (int i = 0; i < self.numberOfCardsInRow.count; i++)
        {
            NSMutableArray *rows = self.deck[i];
            NSInteger numberOfCardsInThisRow = ((NSNumber *)self.numberOfCardsInRow[i]).integerValue;
            
            for (int j = 0; j < numberOfCardsInThisRow; j++)
            {
                MMXCardViewController *cvc = rows[j];
                if (!cvc.card.isFaceUp)
                {
                    stopPlaying = NO;
                }
            }
        }
        
        if (stopPlaying)
        {
            [self endGame];
            
            return;
        }
    }
    
    if (success)
    {
        self.gameState = MMXGameStateAnimating;
        
        [self.view bringSubviewToFront:self.firstCardViewController.view];
        [self.view bringSubviewToFront:self.secondCardViewController.view];
        
        self.firstCardViewController.view.transform = CGAffineTransformIdentity;
        self.secondCardViewController.view.transform = CGAffineTransformIdentity;
        
        // Want to make sure that the state reset happens when the last card leaves the table.
        BOOL firstCardExitsLast = YES;
        if (self.secondCardViewController.row < self.firstCardViewController.row)
        {
            firstCardExitsLast = NO;
        }
        
        CGFloat animationDurationFirstCard = 0.30 - (self.firstCardViewController.row * 0.02);
        CGFloat animationDurationSecondCard = 0.30 - (self.secondCardViewController.row * 0.02);
        
        [UIView animateWithDuration:animationDurationFirstCard
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^
                         {
                             CGFloat center = self.view.frame.size.width / 2.0;
                             CGFloat randomX = center - self.firstCardViewController.view.frame.size.width + arc4random_uniform(self.firstCardViewController.view.frame.size.width);
                             self.firstCardViewController.view.frame = CGRectMake(randomX,
                                                                                  [UIScreen mainScreen].bounds.size.height,
                                                                                  self.firstCardViewController.view.bounds.size.width,
                                                                                  self.firstCardViewController.view.bounds.size.height);
                             
                             NSInteger randomAngle = arc4random_uniform(20);
                             randomAngle += 10;
                             if (arc4random_uniform(2) == 0)
                             {
                                 randomAngle = -randomAngle;
                             }
                             
                             self.firstCardViewController.view.transform = CGAffineTransformMakeRotation(randomAngle * M_PI / 180);
                         }
                         completion:^(BOOL finished)
                         {
                             if (finished)
                             {
                                 [self.firstCardViewController removeCardFromTable];
                                 
                                 if (firstCardExitsLast)
                                 {
                                     [self resetFormulaForNewMatch];
                                     
                                     self.gameState = MMXGameStateNoCardsFlipped;
                                 }
                             }
                         }];
        
        [UIView animateWithDuration:animationDurationSecondCard
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^
                         {
                             CGFloat center = self.view.frame.size.width / 2.0;
                             CGFloat randomX = center - self.secondCardViewController.view.frame.size.width + arc4random_uniform(self.secondCardViewController.view.frame.size.width);
                             self.secondCardViewController.view.frame = CGRectMake(randomX,
                                                                                   [UIScreen mainScreen].bounds.size.height,
                                                                                   self.secondCardViewController.view.bounds.size.width,
                                                                                   self.secondCardViewController.view.bounds.size.height);
                             
                             NSInteger randomAngle = arc4random_uniform(20);
                             randomAngle += 10;
                             if (arc4random_uniform(2) == 0)
                             {
                                 randomAngle = -randomAngle;
                             }
                             
                             self.secondCardViewController.view.transform = CGAffineTransformMakeRotation(randomAngle * M_PI / 180);
                         }
                         completion:^(BOOL finished)
                         {
                             if (finished)
                             {
                                 [self.secondCardViewController removeCardFromTable];
                                 
                                 if (!firstCardExitsLast)
                                 {
                                     [self resetFormulaForNewMatch];
                                     
                                     self.gameState = MMXGameStateNoCardsFlipped;
                                 }
                             }
                         }];
    }
    else
    {
        [self.firstCardViewController flipCardFaceDown];
        [self.secondCardViewController flipCardFaceDown];
        
        [self resetFormulaForNewMatch];
        
        self.gameState = MMXGameStateNoCardsFlipped;
    }
}

- (void)resetFormulaForNewMatch
{
    self.firstCardViewController = nil;
    self.secondCardViewController = nil;
    
    if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition) ||
        (self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication))
    {
        self.xNumberLabel.text = @"";
        self.yNumberLabel.text = @"";
        self.zNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gameConfiguration.targetNumber];
    }
    else if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction) ||
             (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision))
    {
        self.xNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gameConfiguration.targetNumber];
        self.yNumberLabel.text = @"";
        self.zNumberLabel.text = @"";
    }
}

- (void)endGame
{
    [self.gameClockTimer invalidate];
    
    self.gameState = MMXGameStateOver;
    
    [self performSegueWithIdentifier:@"MMXSegueFromGameToResults" sender:nil];
}

- (void)updateClock
{
    // TODO: basic timer, but this is not a reliable way of calculating time!
    
    self.elapsedTime += 1.0/60.0;
    
    CGFloat minutes = floor(self.elapsedTime / 60);
    CGFloat seconds = floorf(self.elapsedTime - minutes * 60);
    
    if ((seconds >= 60.0) && (seconds < 61.0))
    {
        minutes += 1.0;
        seconds = 0.0;
    }
    
    NSString *text = [NSString stringWithFormat:@"Time - %02.0f:%02.0f", minutes, seconds];
    self.customNavigationBarTitle.text = text;
}

- (void)generateCustomNavigationBarViewForTitle:(NSString *)title
{
    // Hack to prevent the label from recentering. This is the widest it will be, so set the label based on it.
    // Will mean the countdown is slightly off center, but fuck it.
    
    UIFont *font = [UIFont fontWithName:@"Futura-Medium" size:17.0];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: font}];
    
    self.customNavigationBarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
    self.customNavigationBarTitle.textAlignment = NSTextAlignmentJustified;
    self.customNavigationBarTitle.textColor = [UIColor whiteColor];
    self.customNavigationBarTitle.font = font;
    self.navigationItem.titleView = self.customNavigationBarTitle;
}

#pragma mark - CardViewControllerDelegate

- (BOOL)playerRequestedFlipFor:(MMXCardViewController *)cardViewController
{
    BOOL shouldFlip = NO;
    
    if (self.gameState == MMXGameStatePreGame)
    {
        shouldFlip = YES;
    }
    else if ((self.gameState == MMXGameStateStart) || (self.gameState == MMXGameStateNoCardsFlipped))
    {
        shouldFlip = YES;
        
        self.gameState = MMXGameStateOneCardFlipped;
        
        self.firstCardViewController = cardViewController;
    }
    else if (self.gameState == MMXGameStateOneCardFlipped)
    {
        shouldFlip = YES;
        
        self.gameState = MMXGameStateTwoCardsFlipped;
        
        self.secondCardViewController = cardViewController;
    }
    else if ((self.gameState == MMXGameStateTwoCardsFlipped) || (self.gameState == MMXGameStateAnimating) || (self.gameState == MMXGameStateOver))
    {
        shouldFlip = NO;
    }
    
    return shouldFlip;
}

- (void)finishedFlippingFor:(MMXCardViewController *)cardViewController
{
    if (self.gameState == MMXGameStatePreGame)
    {
        // Don't need to do anything.
        
        return;
    }
    else if (self.gameState == MMXGameStateAnimating)
    {
        // Don't do anything.
        
        return;
    }
    else if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition) ||
             (self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication))
    {
        if ([cardViewController isEqual:self.firstCardViewController])
        {
            self.xNumberLabel.text = [NSString stringWithFormat:@"%ld", cardViewController.card.value];
        }
        else if ([cardViewController isEqual:self.secondCardViewController])
        {
            self.yNumberLabel.text = [NSString stringWithFormat:@"%ld", cardViewController.card.value];
        }
    }
    else if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction) ||
             (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision))
    {
        if ([cardViewController isEqual:self.firstCardViewController])
        {
            self.yNumberLabel.text = [NSString stringWithFormat:@"%ld", cardViewController.card.value];
        }
        else if ([cardViewController isEqual:self.secondCardViewController])
        {
            self.zNumberLabel.text = [NSString stringWithFormat:@"%ld", cardViewController.card.value];
        }
    }
    
    if (self.firstCardViewController && [self.secondCardViewController isEqual:cardViewController])
    {
        [self evaluateFormula];
    }
}

#pragma mark - KMODecisionViewDelegate

- (void)decisionView:(KMODecisionView *)decisionView tappedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // Player decided to keep playing. Resume.
        self.gameClockTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60.0)
                                                               target:self
                                                             selector:@selector(updateClock)
                                                             userInfo:nil
                                                              repeats:YES];
    }
    else if (buttonIndex == 1)
    {
        // Player quit.
        [self terminateCurrentGame];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (buttonIndex == 2)
    {
        // Player wanted to change the settings or the course.
        if (self.gameConfiguration.gameType == MMXGameTypePractice)
        {
            [self performSegueWithIdentifier:@"unwindToPracticeConfigurationSegue" sender:self];
        }
        else
        {
            // TODO: Action for course.
        }
    }
}

#pragma mark - Pull this into another class

- (NSMutableArray *)factorizeNumber:(NSInteger)number
{
    NSMutableArray *factors = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 1; i <= number; i++)
    {
        if ((number % i) == 0)
        {
            [factors addObject:[NSNumber numberWithInteger:i]];
        }
    }
    
    // If the target number is a perfect square, we need to duplicate the square root factor, or we will have a missing pair!
    if ((factors.count % 2) != 0)
    {
        NSInteger squareRoot = (NSInteger)sqrt(number);
        [factors addObject:[NSNumber numberWithInteger:squareRoot]];
    }
    
    return factors;
}

@end
