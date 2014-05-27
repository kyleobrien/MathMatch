//
//  MMXGameConfiguration.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.23.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXGameConfiguration.h"

@implementation MMXGameConfiguration

+ (instancetype)gameConfigurationFromLesson:(NSDictionary *)lesson
{
    MMXGameConfiguration *gameConfiguration = [[MMXGameConfiguration alloc] init];
    
    gameConfiguration.targetNumber = ((NSNumber *)lesson[@"targetNumber"]).integerValue;
    gameConfiguration.numberOfCards = ((NSNumber *)lesson[@"numberOfCards"]).integerValue;
    
    gameConfiguration.gameType = MMXGameTypeCourse;
    
    if ([lesson[@"arithmeticType"] isEqualToString:@"addition"])
    {
        gameConfiguration.arithmeticType = MMXArithmeticTypeAddition;
    }
    else if ([lesson[@"arithmeticType"] isEqualToString:@"subtraction"])
    {
        gameConfiguration.arithmeticType = MMXArithmeticTypeSubtraction;
    }
    else if ([lesson[@"arithmeticType"] isEqualToString:@"multiplication"])
    {
        gameConfiguration.arithmeticType = MMXArithmeticTypeMultiplication;
    }
    else if ([lesson[@"arithmeticType"] isEqualToString:@"division"])
    {
        gameConfiguration.arithmeticType = MMXArithmeticTypeDivision;
    }
    else
    {
        NSAssert(YES, @"MMX: Arithmetic Type in JSON is not valid.");
    }
    
    if ([lesson[@"memorySpeed"] isEqualToString:@"fast"])
    {
        gameConfiguration.memorySpeed = MMXMemorySpeedFast;
    }
    else if ([lesson[@"memorySpeed"] isEqualToString:@"slow"])
    {
        gameConfiguration.memorySpeed = MMXMemorySpeedSlow;
    }
    else if ([lesson[@"memorySpeed"] isEqualToString:@"none"])
    {
        gameConfiguration.memorySpeed = MMXMemorySpeedNone;
    }
    else
    {
        NSAssert(YES, @"MMX: Memory Speed in JSON is not valid.");
    }
    
    // TODO: Need music tracks first.
    //"musicTrack" : ""
    
    gameConfiguration.cardStyle = [MMXGameConfiguration selectRandomCardStyle];
    
    gameConfiguration.penaltyMultiplier = ((NSNumber *)lesson[@"penaltyMultiplier"]).floatValue;
    
    return gameConfiguration;
}

+ (MMXCardStyle)selectRandomCardStyle
{
    return arc4random_uniform(MMXCardStyleCount - 1) + 1;
}

- (void)resetGameStatistics
{
    self.totalElapsedTime = 0.0;
    self.attemptedMatches = 0;
    self.incorrectMatches = 0;
}

@end
