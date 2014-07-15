//
//  MMXGameData.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.23.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXGameData.h"

@implementation MMXGameData

NSString * const kMMXUserDefaultsEnabledCards = @"MMXUserDefaultsEnabledCards";

@dynamic lessonID;

@dynamic targetNumber;
@dynamic numberOfCards;
@dynamic cardValuesSeparatedByCommas;

@dynamic penaltyMultiplier;
@dynamic twoStarTime;
@dynamic threeStarTime;

@dynamic completionTime;
@dynamic attemptedMatches;
@dynamic incorrectMatches;

@dynamic completionTimeWithPenalty;
@dynamic starRating;

+ (MMXCardStyle)selectRandomCardStyle
{
    NSArray *enabledCards = [[NSUserDefaults standardUserDefaults] arrayForKey:kMMXUserDefaultsEnabledCards];
    if (!enabledCards)
    {
        // They've never visited the enabled section of settings, so all cards are valid.
        return arc4random_uniform(MMXCardStyleCount - 1) + 1;
    }
    
    // Box up all the enabled card styles so we can randomly choose one from an array.
    NSMutableArray *enabledStylesBag = [NSMutableArray array];
    for (NSInteger i = 1; i < enabledCards.count; i++)
    {
        NSNumber *enabled = enabledCards[i];
        if (enabled.boolValue)
        {
            [enabledStylesBag addObject:@(i)];
        }
    }
    
    // Randomly choose from the bag if it's not empty.
    if (enabledStylesBag.count == 0)
    {
        return MMXCardStyleNone;
    }
    else
    {
        NSNumber *choosenStyle = enabledStylesBag[arc4random_uniform((u_int32_t)enabledStylesBag.count)];
        
        return choosenStyle.integerValue;
    }
}

+ (NSString *)imageNameForStyle:(MMXCardStyle)cardStyle
{
    NSString *imageName = nil;
    if (cardStyle == MMXCardStyleBeach)
    {
        imageName = @"MMXCardStyleBeach";
    }
    else if (cardStyle == MMXCardStyleCheckers)
    {
        imageName = @"MMXCardStyleCheckers";
    }
    else if (cardStyle == MMXCardStyleCitrus)
    {
        imageName = @"MMXCardStyleCitrus";
    }
    else if (cardStyle == MMXCardStyleCupcake)
    {
        imageName = @"MMXCardStyleCupcake";
    }
    else if (cardStyle == MMXCardStyleEmerald)
    {
        imageName = @"MMXCardStyleEmerald";
    }
    else if (cardStyle == MMXCardStyleGrass)
    {
        imageName = @"MMXCardStyleGrass";
    }
    else if (cardStyle == MMXCardStyleHoney)
    {
        imageName = @"MMXCardStyleHoney";
    }
    else if (cardStyle == MMXCardStyleMoon)
    {
        imageName = @"MMXCardStyleMoon";
    }
    else if (cardStyle == MMXCardStyleStars)
    {
        imageName = @"MMXCardStyleStars";
    }
    else if (cardStyle == MMXCardStyleSteel)
    {
        imageName = @"MMXCardStyleSteel";
    }
    else if (cardStyle == MMXCardStyleSushi)
    {
        imageName = @"MMXCardStyleSushi";
    }
    else if (cardStyle == MMXCardStyleThatch)
    {
        imageName = @"MMXCardStyleThatch";
    }
    else if (cardStyle == MMXCardStyleVelvet)
    {
        imageName = @"MMXCardStyleVelvet";
    }
    else if (cardStyle == MMXCardStyleOverlook)
    {
        imageName = @"MMXCardStyleOverlook";
    }
    
    return imageName;
}

- (void)resetGameStatistics
{
    self.completionTime = @0.0;
    self.attemptedMatches = @0;
    self.incorrectMatches = @0;
    
    self.completionTimeWithPenalty = @0.0;
    self.starRating = @0;
}

#pragma mark - Enum Properties for Core Data

- (void)setGameType:(enum MMXGameType)gameType
{
    [self willChangeValueForKey:@"gameType"];
    [self setPrimitiveValue:@(gameType) forKey:@"gameType"];
    [self didChangeValueForKey:@"gameType"];
}

- (enum MMXGameType)gameType
{
    [self willAccessValueForKey:@"gameType"];
    NSNumber *number = [self primitiveValueForKey:@"gameType"];
    [self didAccessValueForKey:@"gameType"];
    
    return (enum MMXGameType)number.integerValue;
}

- (void)setArithmeticType:(MMXArithmeticType)arithmeticType
{
    [self willChangeValueForKey:@"arithmeticType"];
    [self setPrimitiveValue:@(arithmeticType) forKey:@"arithmeticType"];
    [self didChangeValueForKey:@"arithmeticType"];
}

- (MMXArithmeticType)arithmeticType
{
    [self willAccessValueForKey:@"arithmeticType"];
    NSNumber *number = [self primitiveValueForKey:@"arithmeticType"];
    [self didAccessValueForKey:@"arithmeticType"];
    
    return number.integerValue;
}

- (void)setStartingPositionType:(MMXStartingPositionType)startingPositionType
{
    [self willChangeValueForKey:@"startingPositionType"];
    [self setPrimitiveValue:@(startingPositionType) forKey:@"startingPositionType"];
    [self didChangeValueForKey:@"startingPositionType"];
}

- (MMXStartingPositionType)startingPositionType
{
    [self willAccessValueForKey:@"startingPositionType"];
    NSNumber *number = [self primitiveValueForKey:@"startingPositionType"];
    [self didAccessValueForKey:@"startingPositionType"];
    
    return number.integerValue;
}

- (void)setMusicTrack:(MMXMusicTrack)musicTrack
{
    [self willChangeValueForKey:@"musicTrack"];
    [self setPrimitiveValue:@(musicTrack) forKey:@"musicTrack"];
    [self didChangeValueForKey:@"musicTrack"];
}

- (MMXMusicTrack)musicTrack
{
    [self willAccessValueForKey:@"musicTrack"];
    NSNumber *number = [self primitiveValueForKey:@"musicTrack"];
    [self didAccessValueForKey:@"musicTrack"];
    
    return number.integerValue;
}

- (void)setCardStyle:(MMXCardStyle)cardStyle
{
    [self willChangeValueForKey:@"cardStyle"];
    [self setPrimitiveValue:@(cardStyle) forKey:@"cardStyle"];
    [self didChangeValueForKey:@"cardStyle"];
}

- (MMXCardStyle)cardStyle
{
    [self willAccessValueForKey:@"cardStyle"];
    NSNumber *number = [self primitiveValueForKey:@"cardStyle"];
    [self didAccessValueForKey:@"cardStyle"];
    
    return number.integerValue;
}

@end
