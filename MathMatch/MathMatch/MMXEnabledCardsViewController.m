//
//  MMXEnabledCardsViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.6.23.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXEnabledCardCell.h"
#import "MMXEnabledCardsViewController.h"

@interface MMXEnabledCardsViewController ()

@property (nonatomic, strong) NSMutableArray *enabledCards;

@end

@implementation MMXEnabledCardsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        NSArray *arrayFromDefaults = [[NSUserDefaults standardUserDefaults] arrayForKey:kMMXUserDefaultsEnabledCards];
        self.enabledCards = [NSMutableArray arrayWithArray:arrayFromDefaults];
        
        if (!arrayFromDefaults)
        {
            self.enabledCards = [NSMutableArray arrayWithCapacity:MMXCardStyleCount];
            
            // Adding a dummy object to the front so that the enabled cards array lines up with the card style enum.
            for (NSInteger i = 0; i < MMXCardStyleCount; i++)
            {
                [self.enabledCards addObject:@YES];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:self.enabledCards forKey:kMMXUserDefaultsEnabledCards];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.allowsMultipleSelection = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] setObject:self.enabledCards forKey:kMMXUserDefaultsEnabledCards];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Subtracting 1 from the count since we don't want to show the 'None' style.
    return MMXCardStyleCount - 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMXEnabledCardCell *cell = (MMXEnabledCardCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MMXEnabledCardCell"
                                                                                               forIndexPath:indexPath];
    
    NSNumber *enabled = self.enabledCards[indexPath.row + 1];
    UIImage *image = [UIImage imageNamed:[MMXGameData imageNameForStyle:(indexPath.row + 1)]];
    
    cell.cardImageView.backgroundColor = [UIColor colorWithPatternImage:image];
    cell.disabledCardView.hidden = enabled.boolValue;
    cell.checkmarkImageView.hidden = !enabled.boolValue;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self flipEnabledForIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self flipEnabledForIndexPath:indexPath];
}

#pragma mark - Helpers

- (void)flipEnabledForIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *enabled = self.enabledCards[indexPath.row + 1];
    self.enabledCards[indexPath.row + 1] = [NSNumber numberWithBool:!enabled.boolValue];
    
    MMXEnabledCardCell *cell = (MMXEnabledCardCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (!enabled.boolValue)
    {
        cell.disabledCardView.hidden = YES;
        cell.checkmarkImageView.hidden = NO;
    }
    else
    {
        cell.disabledCardView.hidden = NO;
        cell.checkmarkImageView.hidden = YES;
    }
}

@end
