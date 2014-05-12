//
//  MMXGameViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.25.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXGameViewController.h"
#import "MMXResultsViewController.h"
#import "MMXTimeIntervalFormatter.h"

@interface MMXGameViewController ()

@property (nonatomic, assign) MMXGameState gameState;

@property (nonatomic, strong) MMXCardViewController *firstCardViewController;
@property (nonatomic, strong) MMXCardViewController *secondCardViewController;

@property (nonatomic, strong) NSMutableArray *cardsGrid;
@property (nonatomic, strong) NSMutableArray *cardsList;

@property (nonatomic, strong) NSTimer *gameClockTimer;
@property (nonatomic, strong) NSTimer *memorySpeedTimer;
@property (nonatomic, assign) NSTimeInterval memoryTimeRemaining;

@property (nonatomic, assign) BOOL haveAlreadyArrangedOnce;
@property (nonatomic, assign) BOOL shouldEndGameAfterAnimation;

@property (nonatomic, strong) UILabel *customNavigationBarTitle;

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
        bottomBorderZ.backgroundColor = [UIColor mmx_blackColor].CGColor;
        
        [self.zNumberLabel.layer addSublayer:bottomBorderZ];
    }
    else if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition) ||
             (self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication))
    {
        CALayer *bottomBorderX = [CALayer layer];
        bottomBorderX.frame = CGRectMake(0.0, self.xNumberLabel.frame.size.height - 2.0, self.xNumberLabel.frame.size.width, 2.0);
        bottomBorderX.backgroundColor = [UIColor mmx_blackColor].CGColor;
        
        [self.xNumberLabel.layer addSublayer:bottomBorderX];
    }
    
    CALayer *bottomBorderY = [CALayer layer];
    bottomBorderY.frame = CGRectMake(0.0, self.yNumberLabel.frame.size.height - 2.0, self.yNumberLabel.frame.size.width, 2.0);
    bottomBorderY.backgroundColor = [UIColor mmx_blackColor].CGColor;
    
    [self.yNumberLabel.layer addSublayer:bottomBorderY];
    
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
    
    if (!self.haveAlreadyArrangedOnce)
    {
        self.haveAlreadyArrangedOnce = YES;
        [self arrangDeckOntoTableauAndStartDealing];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MMXResultsSegue"])
    {
        MMXResultsViewController *resultsViewController = (MMXResultsViewController *)segue.destinationViewController;
        resultsViewController.gameConfiguration = self.gameConfiguration;
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
        secondOption = NSLocalizedString(@"Show Lessons", nil);
    }
    
    NSString *message = NSLocalizedString(@"The game is paused. What would you like to do?", nil);
    NSArray *otherButtonTitles = @[NSLocalizedString(@"Keep Playing", nil), NSLocalizedString(@"Try Again", nil), secondOption];
    KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:message
                                                                    delegate:self
                                                           cancelButtonTitle:NSLocalizedString(@"Quit", nil)
                                                           otherButtonTitles:otherButtonTitles];
    decisionView.fontName = @"Futura-Medium";
    
    // Need to make sure the animation is smooth, so disabling temporarily.
    // Turning back off as soon as the decision view disappears.
    self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.view.layer.shouldRasterize = YES;
    
    [decisionView showAndDimBackgroundWithPercent:0.50];
}

- (IBAction)unwindToGame:(UIStoryboardSegue *)unwindSegue;
{
    self.customNavigationBarTitle.text = @"";
    [self removeCardFromTableauWithIndex:0];
}

#pragma mark - Deck Management

- (void)createDeck
{
    MMXCardStyle randomStyle = [MMXGameConfiguration selectRandomCardStyle];
    
    // EEGG: The shining card style if the target number is 237.
    if (self.gameConfiguration.targetNumber == 237)
    {
        randomStyle = MMXCardStyleOverlook;
    }
    
    CGSize size;
    CGFloat fontSize;
    NSArray *numberOfCardsInRow;
    
    if (self.gameConfiguration.numberOfCards == 8)
    {
        size = CGSizeMake(90.0, 90.0);
        fontSize = 33.0;
        numberOfCardsInRow = @[@3, @2, @3];
    }
    else if (self.gameConfiguration.numberOfCards == 12)
    {
        size = CGSizeMake(80.0, 80.0);
        fontSize = 33.0;
        numberOfCardsInRow = @[@3, @3, @3, @3];
    }
    else if (self.gameConfiguration.numberOfCards == 16)
    {
        size = CGSizeMake(70.0, 70.0);
        fontSize = 22.0;
        numberOfCardsInRow = @[@4, @4, @4, @4];
    }
    else if (self.gameConfiguration.numberOfCards == 20)
    {
        size = CGSizeMake(60.0, 60.0);
        fontSize = 22.0;
        numberOfCardsInRow = @[@4, @4, @4, @4, @4];
    }
    else if (self.gameConfiguration.numberOfCards == 24)
    {
        size = CGSizeMake(60.0, 60.0);
        fontSize = 22.0;
        numberOfCardsInRow = @[@4, @4, @4, @4, @4, @4];
    }
    else
    {
        NSAssert(YES, @"MMX: Invalid number of cards in deck.");
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
        
        // Make sure the bucket we're selecting from has enough factors to choose from.
        if (factors.count < self.gameConfiguration.numberOfCards)
        {
            while ((unshuffledCardValues.count + factors.count) < self.gameConfiguration.numberOfCards)
            {
                [unshuffledCardValues addObjectsFromArray:factors];
            }
        }
        
        // Use the factors to populate the unshuffled deck.
        while (unshuffledCardValues.count < self.gameConfiguration.numberOfCards)
        {
            // Select without replacement.
            while (unshuffledCardValues.count < self.gameConfiguration.numberOfCards)
            {
                NSInteger randomIndex = arc4random_uniform((u_int32_t)factors.count);
                NSInteger randomValue = ((NSNumber *)factors[randomIndex]).integerValue;
                
                [unshuffledCardValues addObject:[NSNumber numberWithInteger:randomValue]];
                [unshuffledCardValues addObject:[NSNumber numberWithInteger:(self.gameConfiguration.targetNumber / randomValue)]];
                
                [factors removeObjectAtIndex:randomIndex];
            }
        }
    }
    else
    {
        NSAssert(YES, @"MMX: Arithmetic Type not set.");
    }
    
    
    self.cardsList = [NSMutableArray arrayWithCapacity:self.gameConfiguration.numberOfCards];
    self.cardsGrid = [NSMutableArray arrayWithCapacity:numberOfCardsInRow.count];
    
    for (NSInteger i = 0; i < numberOfCardsInRow.count; i++)
    {
        NSInteger numberOfCardsInThisRow = ((NSNumber *)numberOfCardsInRow[i]).integerValue;
        NSMutableArray *rowOfCards = [NSMutableArray arrayWithCapacity:numberOfCardsInThisRow];
        
        for (NSInteger j = 0; j < numberOfCardsInThisRow; j++)
        {
            NSInteger randomIndex = arc4random_uniform((u_int32_t)unshuffledCardValues.count);
            MMXCard *card = [[MMXCard alloc] initWithValue:[[unshuffledCardValues objectAtIndex:randomIndex] integerValue]];
            
            MMXCardViewController *cardViewController;
            if (self.gameConfiguration.cardStyle == MMXCardStyleNone)
            {
                cardViewController = [[MMXCardViewController alloc] initWithCardStyle:randomStyle];
            }
            else
            {
                cardViewController = [[MMXCardViewController alloc] initWithCardStyle:self.gameConfiguration.cardStyle];
            }
            cardViewController.card = card;
            cardViewController.delegate = self;
            cardViewController.cardSize = size;
            cardViewController.fontSize = fontSize;
            
            [unshuffledCardValues removeObjectAtIndex:randomIndex];
            
            [rowOfCards addObject:cardViewController];
            [self.cardsList addObject:cardViewController];
        }
        
        [self.cardsGrid addObject:rowOfCards];
    }
}

- (void)arrangDeckOntoTableauAndStartDealing
{
    MMXCardViewController *prototypeCardViewController = self.cardsList[0];
    
    // I want the horizontal gaps to be the same, otherwise it looks weird.
    // So I'm going to loop once and choose the smallest gap.
    // This should only affect the 8 card layout.
    
    CGFloat widthOfGap = 1000.0;
    for (NSInteger i = 0; i < self.cardsGrid.count; i++)
    {
        NSMutableArray *row = self.cardsGrid[i];
        
        CGFloat horizontalSpaceRemaining = self.view.bounds.size.width - (row.count * prototypeCardViewController.cardSize.width);
        CGFloat widthOfGapCandidate = horizontalSpaceRemaining / (row.count + 1);
        
        if (widthOfGapCandidate < widthOfGap)
        {
            widthOfGap = widthOfGapCandidate;
        }
    }
    
    CGFloat cardHeight = prototypeCardViewController.cardSize.height;
    CGFloat verticalSpaceAlreadyTaken = self.equationContainerView.frame.size.height + (self.cardsGrid.count * cardHeight);
    CGFloat verticalSpaceRemaining = self.view.bounds.size.height - verticalSpaceAlreadyTaken;
    CGFloat heightOfGap = verticalSpaceRemaining / (self.cardsGrid.count + 1);
    CGFloat yCoordinate = self.equationContainerView.frame.origin.x + self.equationContainerView.frame.size.height + heightOfGap;
    
    for (NSInteger i = 0; i < self.cardsGrid.count; i++)
    {
        NSMutableArray *row = self.cardsGrid[i];
        
        CGFloat totalWidthOfCardsAndSpaces = (row.count * prototypeCardViewController.cardSize.width) + ((row.count - 1) * widthOfGap);
        CGFloat xCoordinate = floorf((self.view.bounds.size.width - totalWidthOfCardsAndSpaces) / 2);
        
        for (NSInteger j = 0; j < row.count; j++)
        {
            MMXCardViewController *cardViewController = row[j];
            
            cardViewController.view.frame = CGRectMake(0.0,
                                                       [UIScreen mainScreen].bounds.size.height,
                                                       cardViewController.cardSize.width,
                                                       cardViewController.cardSize.height);
            cardViewController.row = i;
            cardViewController.tableLocation = CGPointMake(roundf(xCoordinate), roundf(yCoordinate));
            
            //[self.view addSubview:cardViewController.view];
            
            xCoordinate += cardViewController.cardSize.width + widthOfGap;
        }
        
        yCoordinate += prototypeCardViewController.cardSize.height + heightOfGap;
    }
    
    [self dealCardWithIndex:0];
}

#pragma mark - Game State

- (void)startNewGame
{
    self.gameState = MMXGameStatePreGame;
    
    self.firstCardViewController = nil;
    self.secondCardViewController = nil;
    
    self.cardsGrid = nil;
    self.cardsList = nil;
    
    self.gameClockTimer = nil;
    self.memorySpeedTimer = nil;
    self.memoryTimeRemaining = 0.0;
    
    self.shouldEndGameAfterAnimation = NO;
    
    [self.gameConfiguration resetGameStatistics];
    
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
    
    [self createDeck];
}

- (void)allowPlayerInputAndStartGame
{
    self.gameState = MMXGameStateStarted;
    
    self.pauseBarButtonItem.enabled = YES;
    
    [self generateCustomNavigationBarViewForTitle:NSLocalizedString(@"Time - 00:00", nil)];
    
    self.gameClockTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
                                                           target:self
                                                         selector:@selector(updateClock)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)updateClock
{
    self.gameConfiguration.totalElapsedTime += 1.0 / 60.0;
    
    NSString *time = [MMXTimeIntervalFormatter stringWithInterval:self.gameConfiguration.totalElapsedTime
                                                    forFormatType:MMXTimeIntervalFormatTypeShort];
    self.customNavigationBarTitle.text = [NSString stringWithFormat:@"Time - %@", time];
}

- (void)evaluateFormula
{
    NSInteger result = -1;
    if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition) ||
        (self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction))
    {
        result = self.firstCardViewController.card.value + self.secondCardViewController.card.value;
    }
    else if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication) ||
             (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision))
    {
        result = self.firstCardViewController.card.value * self.secondCardViewController.card.value;
    }
    else
    {
        NSAssert(YES, @"MMX: Arithmetic Type not set.");
    }
    
    self.gameConfiguration.attemptedMatches += 1;
    
    if (result == self.gameConfiguration.targetNumber)
    {
        [self highlightCorrectnessViewOnSuccess:YES];
        
        // Check if there are any cards on the table still face down, let the game continue.
        
        BOOL stopPlaying = YES;
        for (NSInteger i = 0; i < self.cardsGrid.count; i++)
        {
            NSMutableArray *row = self.cardsGrid[i];
            for (NSInteger j = 0; j < row.count; j++)
            {
                MMXCardViewController *cardViewController = row[j];
                if (!cardViewController.card.isFaceUp)
                {
                    stopPlaying = NO;
                }
            }
        }
        
        if (stopPlaying)
        {
            [self.gameClockTimer invalidate];
            self.shouldEndGameAfterAnimation = YES;
        }
        
        [self animateCardsAfterEvaluationSuccess:YES];
    }
    else
    {
        self.gameConfiguration.incorrectMatches += 1;
        
        [self highlightCorrectnessViewOnSuccess:NO];
        [self animateCardsAfterEvaluationSuccess:NO];
    }
}

- (void)terminateGameBeforeFinishing
{
    self.gameState = MMXGameStateOver;
    
    [self.gameClockTimer invalidate];
}

- (void)endGameAndShowResults
{
    self.gameState = MMXGameStateOver;
    
    [self.gameClockTimer invalidate];
    
    [self performSegueWithIdentifier:@"MMXResultsSegue" sender:nil];
}

#pragma mark - Animation

- (void)dealCardWithIndex:(NSInteger)index
{
    MMXCardViewController *cardViewController = self.cardsList[index];
    [cardViewController prepareCardForDealingInView:self.view];
    
    [self.view addSubview:cardViewController.view];
    
    CGFloat animationDuration = 0.25 - (cardViewController.row * 0.02); // 0.02 is just a fudge factor based on what looks good.
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
                     {
                         [cardViewController dealCard];
                     }
                     completion:^(BOOL finished)
                     {
                         if (finished && (index == (self.cardsList.count - 1)))
                         {
                             if (self.gameConfiguration.memorySpeed != MMXMemorySpeedNone)
                             {
                                 [self flipCardFaceUpWithIndex:0];
                             }
                             else
                             {
                                 [self allowPlayerInputAndStartGame];
                             }
                         }
                     }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((animationDuration / 2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        if (index < (self.cardsList.count - 1))
        {
            [self dealCardWithIndex:(index + 1)];
        }
    });
}

- (void)flipCardFaceUpWithIndex:(NSInteger)index
{
    MMXCardViewController *cardViewController = self.cardsList[index];
    [cardViewController flipCardFaceUp];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        if (index < (self.cardsList.count - 1))
        {
            [self flipCardFaceUpWithIndex:(index + 1)];
        }
    });
}

- (void)tickMemorySpeedCountdownTimer
{
    if (self.memorySpeedTimer)
    {
        if (self.memoryTimeRemaining <= 0.0)
        {
            self.customNavigationBarTitle.text = @"";
            
            [self flipCardFaceDownWithIndex:0];
        }
        else
        {
            self.memoryTimeRemaining -= 1.0 / 60.0;
            if (self.memoryTimeRemaining <= 0.0)
            {
                self.customNavigationBarTitle.text = NSLocalizedString(@"Memorize - 0.00", nil);
            }
            else
            {
                self.customNavigationBarTitle.text = [NSString stringWithFormat:@"%@ %01.2f", NSLocalizedString(@"Memorize -", nil), self.memoryTimeRemaining];
            }
            
            self.memorySpeedTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
                                                                     target:self
                                                                   selector:@selector(tickMemorySpeedCountdownTimer)
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
                                                               selector:@selector(tickMemorySpeedCountdownTimer)
                                                               userInfo:nil
                                                                repeats:NO];
    }
}

- (void)flipCardFaceDownWithIndex:(NSInteger)index
{
    MMXCardViewController *cardViewController = self.cardsList[index];
    [cardViewController flipCardFaceDown];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        if (index < (self.cardsList.count - 1))
        {
            [self flipCardFaceDownWithIndex:(index + 1)];
        }
    });
}

- (void)highlightCorrectnessViewOnSuccess:(BOOL)success
{
    if (success)
    {
        [UIView animateWithDuration:0.1 animations:^
        {
            self.equationCorrectnessView.backgroundColor = [UIColor mmx_greenColor];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^
        {
            self.equationCorrectnessView.backgroundColor = [UIColor mmx_redColor];
        }];
    }
}

- (void)animateCardsAfterEvaluationSuccess:(BOOL)success
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        [UIView animateWithDuration:0.1 animations:^
        {
            self.equationCorrectnessView.backgroundColor = [UIColor mmx_whiteColor];
            
            if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition) ||
                (self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication))
            {
                self.xNumberLabel.text = @"";
                self.yNumberLabel.text = @"";
            }
            else if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction) ||
                    (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision))
            {
                self.yNumberLabel.text = @"";
                self.zNumberLabel.text = @"";
            }
        }];
                       
        if (success)
        {
            self.gameState = MMXGameStateAnimating;
            
            self.firstCardViewController.view.transform = CGAffineTransformIdentity;
            self.secondCardViewController.view.transform = CGAffineTransformIdentity;
                               
            [self.view bringSubviewToFront:self.firstCardViewController.view];
            [self.view bringSubviewToFront:self.secondCardViewController.view];
                               
            // We want to make sure that the state change happens when the last card animates off the table.
            BOOL firstCardExitsLast = YES;
            if (self.secondCardViewController.row < self.firstCardViewController.row)
            {
                firstCardExitsLast = NO;
            }
            
            // Remember, 0.02 is a fudge factor based on what looks the best.
            CGFloat animationDurationFirstCard = 0.30 - (self.firstCardViewController.row * 0.02);
            CGFloat animationDurationSecondCard = 0.30 - (self.secondCardViewController.row * 0.02);
                               
            [UIView animateWithDuration:animationDurationFirstCard
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^
                             {
                                 CGFloat center = self.view.frame.size.width / 2.0;
                                 CGFloat randomOffset = arc4random_uniform(self.firstCardViewController.view.frame.size.width);
                                 CGFloat randomX = center - self.firstCardViewController.view.frame.size.width + randomOffset;
                                 self.firstCardViewController.view.frame = CGRectMake(randomX,
                                                                                      [UIScreen mainScreen].bounds.size.height,
                                                                                      self.firstCardViewController.view.bounds.size.width,
                                                                                      self.firstCardViewController.view.bounds.size.height);
                                    
                                NSInteger randomAngle = arc4random_uniform(20) + 10;
                                if (arc4random_uniform(2) == 0)
                                {
                                    randomAngle = -randomAngle;
                                }
                                    
                                self.firstCardViewController.view.transform = CGAffineTransformMakeRotation(randomAngle * M_PI / 180.0);
                            }
                            completion:^(BOOL finished)
                            {
                                if (finished)
                                {
                                    [self.firstCardViewController removeCardFromTable];
                                    
                                    if (firstCardExitsLast)
                                    {
                                        self.firstCardViewController = nil;
                                        self.secondCardViewController = nil;
                                        
                                        if (self.shouldEndGameAfterAnimation)
                                        {
                                            [self endGameAndShowResults];
                                        }
                                        else
                                        {
                                            self.gameState = MMXGameStateNoCardsFlipped;
                                        }
                                    }
                                }
                            }];
                               
            [UIView animateWithDuration:animationDurationSecondCard
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^
                             {
                                 CGFloat center = self.view.frame.size.width / 2.0;
                                 CGFloat randomOffset = arc4random_uniform(self.secondCardViewController.view.frame.size.width);
                                 CGFloat randomX = center - self.secondCardViewController.view.frame.size.width + randomOffset;
                                 self.secondCardViewController.view.frame = CGRectMake(randomX,
                                                                                          [UIScreen mainScreen].bounds.size.height,
                                                                                          self.secondCardViewController.view.bounds.size.width,
                                                                                          self.secondCardViewController.view.bounds.size.height);
                                    
                                NSInteger randomAngle = arc4random_uniform(20) + 10;
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
                                        self.firstCardViewController = nil;
                                        self.secondCardViewController = nil;
                                        
                                        if (self.shouldEndGameAfterAnimation)
                                        {
                                            [self endGameAndShowResults];
                                        }
                                        else
                                        {
                                            self.gameState = MMXGameStateNoCardsFlipped;
                                        }
                                    }
                                }
                            }];
        }
        else
        {
            [self.firstCardViewController flipCardFaceDown];
            [self.secondCardViewController flipCardFaceDown];
                               
            self.firstCardViewController = nil;
            self.secondCardViewController = nil;
                               
            self.gameState = MMXGameStateNoCardsFlipped;
        }
    });
}

- (void)removeCardFromTableauWithIndex:(NSInteger)index
{
    MMXCardViewController *cardViewController = self.cardsList[index];
    NSTimeInterval waitTimeBeforeNextCardRemoval;
    
    if (cardViewController.view.superview)
    {
        waitTimeBeforeNextCardRemoval = 0.1;
        CGFloat animationDuration = 0.30 - (cardViewController.row * 0.02); // 0.02 is just a fudge factor based on what looks good.
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            cardViewController.view.transform = CGAffineTransformIdentity;
            [self.view bringSubviewToFront:cardViewController.view];
            
            [UIView animateWithDuration:animationDuration
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^
                             {
                                 CGFloat center = self.view.frame.size.width / 2.0;
                                 CGFloat randomOffset = arc4random_uniform(cardViewController.view.frame.size.width);
                                 CGFloat randomX = center - cardViewController.view.frame.size.width + randomOffset;
                                 cardViewController.view.frame = CGRectMake(randomX,
                                                                            [UIScreen mainScreen].bounds.size.height,
                                                                            cardViewController.view.bounds.size.width,
                                                                            cardViewController.view.bounds.size.height);
                                 
                                 NSInteger randomAngle = arc4random_uniform(20) + 10;
                                 if (arc4random_uniform(2) == 0)
                                 {
                                     randomAngle = -randomAngle;
                                 }
                                 
                                 cardViewController.view.transform = CGAffineTransformMakeRotation(randomAngle * M_PI / 180.0);
                             }
                             completion:^(BOOL finished)
                             {
                                 if (finished)
                                 {
                                     [cardViewController removeCardFromTable];
                                 }
                             }];
        });
    }
    else
    {
        waitTimeBeforeNextCardRemoval = 0.0;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waitTimeBeforeNextCardRemoval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        if (index < (self.cardsList.count - 1))
        {
            [self removeCardFromTableauWithIndex:(index + 1)];
        }
        else
        {
            [self startNewGame];
            [self arrangDeckOntoTableauAndStartDealing];
        }
    });
}

#pragma mark - Helpers

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

#pragma mark - CardViewControllerDelegate

- (BOOL)requestedFlipFor:(MMXCardViewController *)cardViewController
{    
    BOOL shouldFlip = NO;
    
    if (self.gameState == MMXGameStatePreGame)
    {
        shouldFlip = YES;
    }
    else if ((self.gameState == MMXGameStateStarted) || (self.gameState == MMXGameStateNoCardsFlipped))
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
    
    return shouldFlip;
}

- (void)finishedFlippingFaceDownFor:(MMXCardViewController *)cardViewController
{
    if ((self.gameState == MMXGameStatePreGame) && (cardViewController == self.cardsList.lastObject))
    {
        [self allowPlayerInputAndStartGame];
    }
}

- (void)finishedFlippingFaceUpFor:(MMXCardViewController *)cardViewController
{
    if ((self.gameState == MMXGameStatePreGame) && (cardViewController == self.cardsList.lastObject))
    {
        [self tickMemorySpeedCountdownTimer];
    }
    else if (self.gameState == MMXGameStateAnimating)
    {
        return;
    }
    else if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition) ||
             (self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication))
    {
        if ([cardViewController isEqual:self.firstCardViewController])
        {
            self.xNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)cardViewController.card.value];
        }
        else if ([cardViewController isEqual:self.secondCardViewController])
        {
            self.yNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)cardViewController.card.value];
        }
    }
    else if ((self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction) ||
             (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision))
    {
        if ([cardViewController isEqual:self.firstCardViewController])
        {
            self.yNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)cardViewController.card.value];
        }
        else if ([cardViewController isEqual:self.secondCardViewController])
        {
            self.zNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)cardViewController.card.value];
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
    if (buttonIndex == 0) // Player quit.
    {
        [self terminateGameBeforeFinishing];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (buttonIndex == 1) // Player decided to keep playing. Resume.
    {
        self.gameClockTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
                                                               target:self
                                                             selector:@selector(updateClock)
                                                             userInfo:nil
                                                              repeats:YES];
    }
    else if (buttonIndex == 2) // Player wanted to try again.
    {
        [self terminateGameBeforeFinishing];
        [self removeCardFromTableauWithIndex:0];
    }
    else if (buttonIndex == 3)
    {
        [self terminateGameBeforeFinishing];
        
        if (self.gameConfiguration.gameType == MMXGameTypePractice) // Player wanted to change the settings.
        {
            [self performSegueWithIdentifier:@"MMXUnwindToPracticeConfigurationSegue" sender:self];
        }
        else // Player wanted to view the list of lessons for the current course.
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)decisionView:(KMODecisionView *)decisionView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.view.layer.shouldRasterize = NO;
}

@end
