//
//  MMXTableauViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.4.24.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXTableauViewController.h"

@interface MMXTableauViewController ()

@end

@implementation MMXTableauViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)createDeckWithConfiguration:(MMXGameConfiguration *)gameConfiguration
{
    MMXCardStyle randomStyle = [MMXGameConfiguration selectRandomCardStyle];
    
    CGSize size;
    CGFloat fontSize;
    NSArray *numberOfCardsInRow;
    
    if (gameConfiguration.numberOfCards == 8)
    {
        size = CGSizeMake(88.0, 88.0);
        fontSize = 33.0;
        numberOfCardsInRow = @[@3, @2, @3];
    }
    else if (gameConfiguration.numberOfCards == 12)
    {
        size = CGSizeMake(77.0, 77.0);
        fontSize = 33.0;
        numberOfCardsInRow = @[@3, @3, @3, @3];
    }
    else if (gameConfiguration.numberOfCards == 16)
    {
        size = CGSizeMake(66.0, 66.0);
        fontSize = 22.0;
        numberOfCardsInRow = @[@4, @4, @4, @4];
    }
    else if (gameConfiguration.numberOfCards == 20)
    {
        size = CGSizeMake(55.0, 55.0);
        fontSize = 22.0;
        numberOfCardsInRow = @[@4, @4, @4, @4, @4];
    }
    else if (gameConfiguration.numberOfCards == 24)
    {
        size = CGSizeMake(55.0, 55.0);
        fontSize = 22.0;
        numberOfCardsInRow = @[@4, @4, @4, @4, @4, @4];
    }
    else
    {
        NSAssert(YES, @"MMX: Invalid number of cards in deck.");
    }
    
    NSMutableArray *unshuffledCardValues = [NSMutableArray arrayWithCapacity:0];
    
    if ((gameConfiguration.arithmeticType == MMXArithmeticTypeAddition) ||
        (gameConfiguration.arithmeticType == MMXArithmeticTypeSubtraction))
    {
        u_int32_t maxCardValue = floor(gameConfiguration.targetNumber / 2.0);
        
        while (unshuffledCardValues.count < gameConfiguration.numberOfCards)
        {
            NSInteger randomValue = arc4random_uniform(maxCardValue + 1);
            
            [unshuffledCardValues addObject:[NSNumber numberWithInteger:randomValue]];
            [unshuffledCardValues addObject:[NSNumber numberWithInteger:(gameConfiguration.targetNumber - randomValue)]];
        }
    }
    else if ((gameConfiguration.arithmeticType == MMXArithmeticTypeMultiplication) ||
             (gameConfiguration.arithmeticType == MMXArithmeticTypeDivision))
    {
        NSMutableArray *factors = [self factorizeNumber:gameConfiguration.targetNumber];
        
        // Make sure the bucket we're selecting from has enough factors to choose from.
        if (factors.count < gameConfiguration.numberOfCards)
        {
            while ((unshuffledCardValues.count + factors.count) < gameConfiguration.numberOfCards)
            {
                [unshuffledCardValues addObjectsFromArray:factors];
            }
        }
        
        // Use the factors to populate the unshuffled deck.
        while (unshuffledCardValues.count < gameConfiguration.numberOfCards)
        {
            // Select without replacement.
            while (unshuffledCardValues.count < gameConfiguration.numberOfCards)
            {
                NSInteger randomIndex = arc4random_uniform((u_int32_t)factors.count);
                NSInteger randomValue = ((NSNumber *)factors[randomIndex]).integerValue;
                
                [unshuffledCardValues addObject:[NSNumber numberWithInteger:randomValue]];
                [unshuffledCardValues addObject:[NSNumber numberWithInteger:(gameConfiguration.targetNumber / randomValue)]];
                
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
