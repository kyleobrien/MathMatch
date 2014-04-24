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
    return arc4random_uniform(MMXCardStyleCount);
}

@end
