//
//  MMXGameData.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.23.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

typedef NS_ENUM(NSUInteger, MMXGameType)
{
    MMXGameTypeNone,
    MMXGameTypeCourse,
    MMXGameTypePractice
};

typedef NS_ENUM(NSUInteger, MMXArithmeticType)
{
    MMXArithmeticTypeNone,
    MMXArithmeticTypeAddition,
    MMXArithmeticTypeSubtraction,
    MMXArithmeticTypeMultiplication,
    MMXArithmeticTypeDivision
};

typedef NS_ENUM(NSUInteger, MMXMemorySpeed)
{
    MMXMemorySpeedNone,
    MMXMemorySpeedSlow,
    MMXMemorySpeedFast
};

typedef NS_ENUM(NSUInteger, MMXMusicTrack)
{
    MMXMusicTrackOff,
    MMXMusicTrack1,
    MMXMusicTrack2,
    MMXMusicTrack3
};

typedef NS_ENUM(NSUInteger, MMXCardStyle)
{
    MMXCardStyleNone,
    MMXCardStyleBeach,
    MMXCardStyleCheckers,
    MMXCardStyleCitrus,
    MMXCardStyleCupcake,
    MMXCardStyleEmerald,
    MMXCardStyleGrass,
    MMXCardStyleHoney,
    MMXCardStyleMoon,
    MMXCardStyleStars,
    MMXCardStyleSteel,
    MMXCardStyleSushi,
    MMXCardStyleThatch,
    MMXCardStyleVelvet,
    MMXCardStyleCount,
    MMXCardStyleOverlook
};

@interface MMXGameData : NSManagedObject

@property (nonatomic, assign) MMXGameType gameType;
@property (nonatomic, strong) NSNumber *lessonID;

@property (nonatomic, strong) NSNumber *targetNumber;
@property (nonatomic, strong) NSNumber *numberOfCards;
@property (nonatomic, strong) NSString *cardsValuesSeparatedByCommas;
@property (nonatomic, assign) MMXArithmeticType arithmeticType;
@property (nonatomic, assign) MMXMemorySpeed memorySpeed;
@property (nonatomic, assign) MMXMusicTrack musicTrack;
@property (nonatomic, assign) MMXCardStyle cardStyle;

@property (nonatomic, strong) NSNumber *penaltyMultiplier;
@property (nonatomic, strong) NSNumber *twoStarTime;
@property (nonatomic, strong) NSNumber *threeStarTime;

@property (nonatomic, strong) NSNumber *completionTime;
@property (nonatomic, strong) NSNumber *attemptedMatches;
@property (nonatomic, strong) NSNumber *incorrectMatches;

@property (nonatomic, strong) NSNumber *completionTimeWithPenalty;
@property (nonatomic, strong) NSNumber *starRating;

+ (MMXCardStyle)selectRandomCardStyle;

- (void)resetGameStatistics;

@end
