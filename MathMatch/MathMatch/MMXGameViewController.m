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

@property (nonatomic, assign) CGFloat cardWidth;
@property (nonatomic, assign) CGFloat cardHeight;

@property (nonatomic, strong) NSArray *numberOfCardsInRow;

@property (nonatomic, strong) NSTimer *clockTimer;

@property (nonatomic, assign) NSInteger matchesAttempted;
@property (nonatomic, assign) NSInteger matchesFailed;
@property (nonatomic, assign) NSTimeInterval elapsedTime;

@end

@implementation MMXGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    CALayer *bottomBorderX = [CALayer layer];
    bottomBorderX.frame = CGRectMake(0.0, self.xNumberLabel.frame.size.height - 2.0, self.xNumberLabel.frame.size.width, 2.0);
    bottomBorderX.backgroundColor = [UIColor colorWithRed:(43.0/255.0) green:(43.0/255.0) blue:(43.0/255.0) alpha:1.0].CGColor;
    
    CALayer *bottomBorderY = [CALayer layer];
    bottomBorderY.frame = CGRectMake(0.0, self.yNumberLabel.frame.size.height - 2.0, self.yNumberLabel.frame.size.width, 2.0);
    bottomBorderY.backgroundColor = [UIColor colorWithRed:(43.0/255.0) green:(43.0/255.0) blue:(43.0/255.0) alpha:1.0].CGColor;
    
    [self.xNumberLabel.layer addSublayer:bottomBorderX];
    [self.yNumberLabel.layer addSublayer:bottomBorderY];
    
    if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition)
    {
        self.mathOperatorLabel.text = @"+";
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction)
    {
        self.mathOperatorLabel.text = @"−";
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication)
    {
        self.mathOperatorLabel.text = @"×";
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision)
    {
        self.mathOperatorLabel.text = @"÷";
    }
    else
    {
        self.mathOperatorLabel.text = @"?";
    }
    
    self.resultNumberLabel.text = [NSString stringWithFormat:@"%ld", self.gameConfiguration.targetNumber];
    
    [self startNewGame];
}


- (IBAction)playerTappedQuitButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    // TODO: Need to show a menu.
}

- (void)updateClock
{
    // TODO: basic timer, but this is not a reliable way of calculating time!
    
    self.elapsedTime += 1.0/60.0;
    
    double minutes = floor(self.elapsedTime / 60);
    double seconds = round(self.elapsedTime - minutes * 60);
    
    self.navigationItem.title = [NSString stringWithFormat:@"Time - %02.0f:%02.0f", minutes, seconds];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self arrangDeckOntoPlaySpace];
}

- (void)startNewGame
{
    [self removeDeckFromPlaySpace];
    
    self.gameState = MMXGameStateStart;
    
    self.firstCardViewController = nil;
    self.secondCardViewController = nil;
    
    self.matchesAttempted = 0;
    self.matchesFailed = 0;
    self.elapsedTime = 0;
    
    self.xNumberLabel.text = @"";
    self.yNumberLabel.text = @"";
    self.resultNumberLabel.text = [NSString stringWithFormat:@"%ld", self.gameConfiguration.targetNumber];
    self.navigationItem.title = @"Time - 00:00";
    
    [self createDeck];
    [self arrangDeckOntoPlaySpace];
    
    [self.clockTimer invalidate];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60.0)
                                                      target:self
                                                    selector:@selector(updateClock)
                                                    userInfo:nil
                                                     repeats:YES];
    self.clockTimer = timer;
}


#pragma mark - Board layout

- (void)createDeck
{
    if (self.gameConfiguration.numberOfCards == 8)
    {
        self.cardWidth = 88.0;
        self.cardHeight = 88.0;
        
        self.numberOfCardsInRow = @[@3, @2, @3];
    }
    else if (self.gameConfiguration.numberOfCards == 12)
    {
        self.cardWidth = 66.0;
        self.cardHeight = 66.0;
        
        self.numberOfCardsInRow = @[@3, @3, @3, @3];
    }
    else if (self.gameConfiguration.numberOfCards == 16)
    {
        self.cardWidth = 66.0;
        self.cardHeight = 66.0;
        
        self.numberOfCardsInRow = @[@4, @4, @4, @4];
    }
    else if (self.gameConfiguration.numberOfCards == 20)
    {
        self.cardWidth = 44.0;
        self.cardHeight = 44.0;
        
        self.numberOfCardsInRow = @[@4, @4, @4, @4, @4];
    }
    else if (self.gameConfiguration.numberOfCards == 24)
    {
        self.cardWidth = 44.0;
        self.cardHeight = 44.0;
        
        self.numberOfCardsInRow = @[@4, @4, @4, @4, @4, @4];
    }
    else
    {
        self.cardWidth = 88.0;
        self.cardHeight = 88.0;
        
        self.numberOfCardsInRow = @[@3, @2, @3];
    }
    
    NSMutableArray *unshuffledCardValues = [NSMutableArray arrayWithCapacity:0];
    
    if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition)
    {
        NSInteger maxCardValue = floor(self.gameConfiguration.targetNumber / 2.0);
        
        while (unshuffledCardValues.count < self.gameConfiguration.numberOfCards)
        {
            NSInteger randomValue = arc4random_uniform(maxCardValue + 1);
 
            [unshuffledCardValues addObject:[NSNumber numberWithInteger:randomValue]];
            [unshuffledCardValues addObject:[NSNumber numberWithInteger:(self.gameConfiguration.targetNumber - randomValue)]];
        }
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction)
    {
        while (unshuffledCardValues.count < self.gameConfiguration.numberOfCards)
        {
            NSInteger randomValue = arc4random_uniform(self.gameConfiguration.targetNumber + 1);
            
            [unshuffledCardValues addObject:[NSNumber numberWithInteger:randomValue]];
            [unshuffledCardValues addObject:[NSNumber numberWithInteger:(self.gameConfiguration.targetNumber + randomValue)]];
        }
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication)
    {
        // Pull out all the factors for the target number.
        NSMutableArray *factors = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 1; i <= self.gameConfiguration.targetNumber; i++)
        {
            if ((self.gameConfiguration.targetNumber % i) == 0)
            {
                [factors addObject:[NSNumber numberWithInteger:i]];
            }
        }
        
        // If the target number is a perfect square, we need to duplicate the square root factor, or we will have a missing pair!
        if ((factors.count % 2) != 0)
        {
            NSInteger squareRoot = (NSInteger)sqrt(self.gameConfiguration.targetNumber);
            [factors addObject:[NSNumber numberWithInteger:squareRoot]];
        }
        
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
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision)
    {
        while (unshuffledCardValues.count < self.gameConfiguration.numberOfCards)
        {
            NSInteger randomValue = arc4random_uniform(self.gameConfiguration.numberOfCards) + 1;
            
            [unshuffledCardValues addObject:[NSNumber numberWithInteger:randomValue]];
            [unshuffledCardValues addObject:[NSNumber numberWithInteger:(self.gameConfiguration.targetNumber * randomValue)]];
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
            
            [unshuffledCardValues removeObjectAtIndex:randomIndex];
            
            [column addObject:cvc];
        }
        
        [freshDeck addObject:column];
    }
    
    self.deck = freshDeck;
}

- (void)arrangDeckOntoPlaySpace
{
    CGFloat existingHeight = self.equationContainerView.frame.size.height + (self.numberOfCardsInRow.count * self.cardHeight);
    CGFloat verticalSpaceRemaining = self.view.bounds.size.height - existingHeight;
    CGFloat verticalGap = verticalSpaceRemaining / (self.numberOfCardsInRow.count + 1);
    CGFloat yCoordinate = self.equationContainerView.frame.origin.x + self.equationContainerView.frame.size.height + verticalGap;
    
    for (NSInteger i = 0; i < self.numberOfCardsInRow.count; i++)
    {
        NSMutableArray *rows = self.deck[i];
        
        NSInteger numberOfCardsInThisRow = ((NSNumber *)self.numberOfCardsInRow[i]).integerValue;
        
        CGFloat horizontalSpaceRemaining = self.view.bounds.size.width - (numberOfCardsInThisRow * self.cardWidth);
        CGFloat horizontalGap = horizontalSpaceRemaining / (numberOfCardsInThisRow + 1);
        CGFloat xCoordinate = horizontalGap;
        
        for (NSInteger j = 0; j < numberOfCardsInThisRow; j++)
        {
            MMXCardViewController *cvc = rows[j];
            
            CGRect frame = cvc.view.frame;
            frame.origin.x = xCoordinate;
            frame.origin.y = yCoordinate;
            frame.size.width = self.cardWidth;
            frame.size.height = self.cardHeight;
            cvc.view.frame = frame;
            
            [self.view addSubview:cvc.view];
            
            xCoordinate += self.cardWidth + horizontalGap;
        }
        
        yCoordinate += self.cardHeight + verticalGap;
    }
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
    NSInteger result;
    BOOL success;
    
    if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeAddition)
    {
        result = self.firstCardViewController.card.value + self.secondCardViewController.card.value;
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction)
    {
        result = self.firstCardViewController.card.value - self.secondCardViewController.card.value;
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication)
    {
        result = self.firstCardViewController.card.value * self.secondCardViewController.card.value;
    }
    else if (self.gameConfiguration.arithmeticType == MMXArithmeticTypeDivision)
    {
        result = self.firstCardViewController.card.value / self.secondCardViewController.card.value;
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
    
    self.resultNumberLabel.text = [NSString stringWithFormat:@"%ld", result];
    
    self.matchesAttempted += 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        [self proceedToNextTurnAfterSuccessfulMatch:success];
    });
}

- (void)proceedToNextTurnAfterSuccessfulMatch:(BOOL)success
{
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
        [self.firstCardViewController removeCardFromTable];
        [self.secondCardViewController removeCardFromTable];
    }
    else
    {
        [self.firstCardViewController flipCardFaceDown];
        [self.secondCardViewController flipCardFaceDown];
    }
    
    self.gameState = MMXGameStateNoCardsFlipped;
    
    self.firstCardViewController = nil;
    self.secondCardViewController = nil;
    
    self.xNumberLabel.text = @"";
    self.yNumberLabel.text = @"";
    self.resultNumberLabel.text = [NSString stringWithFormat:@"%ld", self.gameConfiguration.targetNumber];
}

- (void)endGame
{
    [self.clockTimer invalidate];
    
    self.gameState = MMXGameStateOver;
    
    [self performSegueWithIdentifier:@"MMXSegueFromGameToResults" sender:nil];
}

#pragma mark CardViewControllerDelegate

- (BOOL)playerRequestedFlipFor:(MMXCardViewController *)cardViewController
{
    BOOL shouldFlip = NO;
    
    if ((self.gameState == MMXGameStateStart) || (self.gameState == MMXGameStateNoCardsFlipped))
    {
        shouldFlip = YES;
        
        self.firstCardViewController = cardViewController;
        
        self.gameState = MMXGameStateOneCardFlipped;
    }
    else if (self.gameState == MMXGameStateOneCardFlipped)
    {
        shouldFlip = YES;
        
        self.secondCardViewController = cardViewController;
        
        self.gameState = MMXGameStateTwoCardsFlipped;
    }
    else if ((self.gameState == MMXGameStateTwoCardsFlipped) || (self.gameState == MMXGameStateAnimating) || (self.gameState == MMXGameStateOver))
    {
        shouldFlip = NO;
    }
    
    return shouldFlip;
}

- (void)finishedFlippingFor:(MMXCardViewController *)cardViewController
{
    if ([cardViewController isEqual:self.firstCardViewController])
    {
        self.xNumberLabel.text = [NSString stringWithFormat:@"%ld", cardViewController.card.value];
    }
    else if ([cardViewController isEqual:self.secondCardViewController])
    {
        self.yNumberLabel.text = [NSString stringWithFormat:@"%ld", cardViewController.card.value];
        
        [self evaluateFormula];
    }
}

@end
