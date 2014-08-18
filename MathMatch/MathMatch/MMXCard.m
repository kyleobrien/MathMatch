//
//  MMXCard.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.2.11.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXCard.h"

@implementation MMXCard

- (instancetype)initWithValue:(NSInteger)value
{
    self = [super init];
    if (self)
    {
        self.value = value;
    }
    
    return self;
}

- (void)flip
{
    self.faceUp = !self.isFaceUp;
}

@end
