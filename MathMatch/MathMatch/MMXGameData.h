//
//  MMXGameData.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.23.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

typedef NS_ENUM(NSUInteger, MMXGameType)
{
    MMXGameTypeCourse,
    MMXGameTypePractice
};

typedef NS_ENUM(NSUInteger, MMXArithmeticType)
{
    MMXArithmeticTypeAddition,
    MMXArithmeticTypeSubtraction,
    MMXArithmeticTypeMultiplication,
    MMXArithmeticTypeDivision
};

typedef NS_ENUM(NSUInteger, MMXMemorySpeed)
{
    MMXMemorySpeedSlow,
    MMXMemorySpeedFast,
    MMXMemorySpeedNone
};

typedef NS_ENUM(NSUInteger, MMXMusicTrack)
{
    MMXMusicTrack1,
    MMXMusicTrack2,
    MMXMusicTrack3,
    MMXMusicTrackOff
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
@property (nonatomic, strong) NSArray *cardsValues;
@property (nonatomic, assign) MMXArithmeticType arithmeticType;
@property (nonatomic, assign) MMXMemorySpeed memorySpeed;
@property (nonatomic, assign) MMXMusicTrack musicTrack;
@property (nonatomic, assign) MMXCardStyle cardStyle;

@property (nonatomic, strong) NSNumber *completionTime;
@property (nonatomic, strong) NSNumber *attemptedMatches;
@property (nonatomic, strong) NSNumber *incorrectMatches;
@property (nonatomic, strong) NSNumber *penaltyMultiplier;

@property (nonatomic, strong) NSNumber *completionTimeWithPenalty;
@property (nonatomic, strong) NSNumber *starRating;

+ (instancetype)gameConfigurationFromLesson:(NSDictionary *)lesson;

+ (MMXCardStyle)selectRandomCardStyle;

- (void)resetGameStatistics;

@end
