//
//  MMXGameConfiguration.h
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
    MMXCardStyleThatch,
    MMXCardStyle01,
    MMXCardStyle02,
    MMXCardStyle03,
    MMXCardStyle04,
    MMXCardStyle05,
    MMXCardStyleCount
};

@interface MMXGameConfiguration : NSObject

@property (nonatomic, assign) NSInteger targetNumber;
@property (nonatomic, assign) NSInteger numberOfCards;

@property (nonatomic, assign) MMXGameType gameType;
@property (nonatomic, assign) MMXArithmeticType arithmeticType;
@property (nonatomic, assign) MMXMemorySpeed memorySpeed;
@property (nonatomic, assign) MMXMusicTrack musicTrack;

@property (nonatomic, assign) MMXCardStyle cardStyle;

@property (nonatomic, assign) CGFloat penaltyMultiplier;

@property (nonatomic, assign) NSTimeInterval totalElapsedTime;
@property (nonatomic, assign) NSInteger attemptedMatches;
@property (nonatomic, assign) NSInteger incorrectMatches;

+ (MMXCardStyle)selectRandomCardStyle;

- (void)resetGameStatistics;

@end
