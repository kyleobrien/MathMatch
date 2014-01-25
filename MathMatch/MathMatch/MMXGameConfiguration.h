//
//  MMXGameConfiguration.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.23.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

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

@interface MMXGameConfiguration : NSObject

@property (assign) NSInteger targetNumber;
@property (assign) NSInteger numberOfCards;
@property (assign) MMXArithmeticType arithmeticType;
@property (assign) MMXMemorySpeed memorySpeed;
@property (assign) MMXMusicTrack musicTrack;

@end
