//
//  MMXTimeIntervalFormatter.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.4.24.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXTimeIntervalFormatter.h"

@implementation MMXTimeIntervalFormatter

+ (NSString *)stringWithInterval:(NSTimeInterval)interval forFormatType:(MMXTimeIntervalFormatType)formatType
{
    NSString *formattedString = nil;
    
    if (formatType == MMXTimeIntervalFormatTypeShort)
    {
        CGFloat minutes = floor(interval / 60.0);
        CGFloat seconds = floorf(interval - minutes * 60.0);
        
        if ((seconds >= 60.0) && (seconds < 61.0))
        {
            minutes += 1.0;
            seconds = 0.0;
        }
        
        formattedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutes, seconds];
    }
    else if (formatType == MMXTimeIntervalFormatTypeLong)
    {
        
    }
    
    return formattedString;
}

@end
