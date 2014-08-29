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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        NSArray *arrayFromDefaults = [[NSUserDefaults standardUserDefaults] arrayForKey:kMMXUserDefaultsEnabledCards];
        self.enabledCards = [NSMutableArray arrayWithArray:arrayFromDefaults];
        
        if (!arrayFromDefaults)
        {
            self.enabledCards = [NSMutableArray arrayWithCapacity:MMXCardStyleCount];
            
            // Including an enabled card for the 'none' style, since we don't ever want that disabled.
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
    
    self.collectionView.allowsMultipleSelection = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController)
    {
        [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapBackward;
        [[MMXAudioManager sharedManager] playSoundEffect];
    }
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] setObject:self.enabledCards forKey:kMMXUserDefaultsEnabledCards];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Subtracting 1 from the count since we don't want to show the 'none' style.
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
    
    cell.isAccessibilityElement = YES;
    cell.accessibilityLabel = [self cardTitleForCardStyle:(indexPath.row + 1)];
    
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
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
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

- (NSString *)cardTitleForCardStyle:(MMXCardStyle)cardStyle
{
    NSString *cardTitle = nil;
    
    if (cardStyle == MMXCardStyleBeach)
    {
        cardTitle = NSLocalizedString(@"Beach", nil);
    }
    else if (cardStyle == MMXCardStyleCheckers)
    {
        cardTitle = NSLocalizedString(@"Checkers", nil);
    }
    else if (cardStyle == MMXCardStyleCitrus)
    {
        cardTitle = NSLocalizedString(@"Citrus", nil);
    }
    else if (cardStyle == MMXCardStyleCupcake)
    {
        cardTitle = NSLocalizedString(@"Cupcake", nil);
    }
    else if (cardStyle == MMXCardStyleEmerald)
    {
        cardTitle = NSLocalizedString(@"Emerald", nil);
    }
    else if (cardStyle == MMXCardStyleGrass)
    {
        cardTitle = NSLocalizedString(@"Grass", nil);
    }
    else if (cardStyle == MMXCardStyleHoney)
    {
        cardTitle = NSLocalizedString(@"Honey", nil);
    }
    else if (cardStyle == MMXCardStyleMoon)
    {
        cardTitle = NSLocalizedString(@"Moon", nil);
    }
    else if (cardStyle == MMXCardStyleStars)
    {
        cardTitle = NSLocalizedString(@"Stars", nil);
    }
    else if (cardStyle == MMXCardStyleSteel)
    {
        cardTitle = NSLocalizedString(@"Steel", nil);
    }
    else if (cardStyle == MMXCardStyleSushi)
    {
        cardTitle = NSLocalizedString(@"Sushi", nil);
    }
    else if (cardStyle == MMXCardStyleThatch)
    {
        cardTitle = NSLocalizedString(@"Thatch", nil);
    }
    else if (cardStyle == MMXCardStyleVelvet)
    {
        cardTitle = NSLocalizedString(@"Velvet", nil);
    }
    
    
    return cardTitle;
}

@end
