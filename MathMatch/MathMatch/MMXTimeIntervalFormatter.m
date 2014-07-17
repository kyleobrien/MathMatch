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
    
    CGFloat minutes = floor(interval / 60.0);
    CGFloat seconds = floorf(interval - minutes * 60.0);
    
    if ((seconds >= 60.0) && (seconds < 61.0))
    {
        minutes += 1.0;
        seconds = 0.0;
    }
    
    if (formatType == MMXTimeIntervalFormatTypeShort)
    {
        formattedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutes, seconds];
    }
    else if (formatType == MMXTimeIntervalFormatTypeLong)
    {
        formattedString = [NSString stringWithFormat:@"%1.0f%@ %1.0f%@", minutes, NSLocalizedString(@"m", nil), seconds, NSLocalizedString(@"s", nil)];
    }
    
    return [formattedString copy];
}

+ (NSString *)reportCardFormatWithInterval:(NSTimeInterval)interval
{
    CGFloat hours = floorf(interval / 3600.0);
    CGFloat minutes = floor((interval - (hours * 3600.0)) / 60.0);
    CGFloat seconds = floorf(interval - (minutes * 60.0));
    
    if ((seconds >= 60.0) && (seconds < 61.0))
    {
        minutes += 1.0;
        seconds = 0.0;
    }
    
    if ((minutes >= 60.0) && (minutes < 61.0))
    {
        hours += 1.0;
        minutes = 0.0;
    }
    
    return [NSString stringWithFormat:@"%1.0f%@ %1.0f%@ %1.0f%@", hours, NSLocalizedString(@"h", nil),
                                                                  minutes, NSLocalizedString(@"m", nil),
                                                                  seconds, NSLocalizedString(@"s", nil)];
}

@end
