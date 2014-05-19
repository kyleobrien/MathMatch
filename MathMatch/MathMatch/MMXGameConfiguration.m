//
//  MMXGameConfiguration.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.23.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXGameConfiguration.h"

@implementation MMXGameConfiguration

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
