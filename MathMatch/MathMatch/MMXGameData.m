//
//  MMXGameData.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.23.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXGameData.h"

@implementation MMXGameData

@dynamic lessonID;

@dynamic targetNumber;
@dynamic numberOfCards;
@dynamic cardsValuesSeparatedByCommas;

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
    return arc4random_uniform(MMXCardStyleCount - 1) + 1;
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

- (void)setMemorySpeed:(MMXMemorySpeed)memorySpeed
{
    [self willChangeValueForKey:@"memorySpeed"];
    [self setPrimitiveValue:@(memorySpeed) forKey:@"memorySpeed"];
    [self didChangeValueForKey:@"memorySpeed"];
}

- (MMXMemorySpeed)memorySpeed
{
    [self willAccessValueForKey:@"memorySpeed"];
    NSNumber *number = [self primitiveValueForKey:@"memorySpeed"];
    [self didAccessValueForKey:@"memorySpeed"];
    
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
