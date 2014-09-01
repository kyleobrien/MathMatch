//
//  MMXGameData.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.23.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

FOUNDATION_EXPORT NSString * const kMMXUserDefaultsEnabledCards;

typedef NS_ENUM(NSUInteger, MMXGameType)
{
    MMXGameTypeNone,
    MMXGameTypeCourse,
    MMXGameTypePractice,
    MMXGameTypeHowToPlay
};

typedef NS_ENUM(NSUInteger, MMXArithmeticType)
{
    MMXArithmeticTypeNone,
    MMXArithmeticTypeAddition,
    MMXArithmeticTypeSubtraction,
    MMXArithmeticTypeMultiplication,
    MMXArithmeticTypeDivision
};

typedef NS_ENUM(NSUInteger, MMXStartingPositionType)
{
    MMXStartingPositionTypeFaceUp,
    MMXStartingPositionTypeMemorize,
    MMXStartingPositionTypeFaceDown
};

typedef NS_ENUM(NSUInteger, MMXMusicTrack)
{
    MMXMusicTrackOff,
    MMXMusicTrackEasy,
    MMXMusicTrackMedium,
    MMXMusicTrackHard
};

typedef NS_ENUM(NSUInteger, MMXCardStyle)
{
    MMXCardStyleNone = 0,
    MMXCardStyleBeach = 1,
    MMXCardStyleCheckers = 2,
    MMXCardStyleCitrus = 3,
    MMXCardStyleCupcake = 4,
    MMXCardStyleEmerald = 5,
    MMXCardStyleGrass = 6,
    MMXCardStyleHoney = 7,
    MMXCardStyleMoon = 8,
    MMXCardStyleStars = 9,
    MMXCardStyleSteel = 10,
    MMXCardStyleSushi = 11,
    MMXCardStyleThatch = 12,
    MMXCardStyleVelvet = 13,
    MMXCardStyleCount = 14,
    MMXCardStyleOverlook = 237
};

@interface MMXGameData : NSManagedObject

@property (nonatomic, assign) MMXGameType gameType;
@property (nonatomic, strong) NSNumber *lessonID;

@property (nonatomic, strong) NSNumber *targetNumber;
@property (nonatomic, strong) NSNumber *numberOfCards;
@property (nonatomic, strong) NSString *cardValuesSeparatedByCommas;
@property (nonatomic, assign) MMXArithmeticType arithmeticType;
@property (nonatomic, assign) MMXStartingPositionType startingPositionType;
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
+ (NSString *)imageNameForStyle:(MMXCardStyle)cardStyle;

- (void)resetGameStatistics;

@end
