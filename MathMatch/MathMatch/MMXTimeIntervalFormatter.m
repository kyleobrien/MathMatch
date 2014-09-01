//
//  MMXTimeIntervalFormatter.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.4.24.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXTimeIntervalFormatter.h"

@implementation MMXTimeIntervalFormatter

+ (NSArray *)stringWithInterval:(NSTimeInterval)interval forFormatType:(MMXTimeIntervalFormatType)formatType
{
    NSString *formattedString = @"";
    NSString *accessibilityString = @"";
    
    CGFloat minutes = floor(interval / 60.0);
    CGFloat seconds = floorf(interval - minutes * 60.0);
    
    if ((seconds >= 60.0) && (seconds < 61.0))
    {
        minutes += 1.0;
        seconds = 0.0;
    }
    
    NSString *minutesPluralized = NSLocalizedString(@" minutes", nil);
    if (minutes == 1.0)
    {
        minutesPluralized = NSLocalizedString(@" minute", nil);
    }
    
    NSString *secondsPluralized = NSLocalizedString(@" seconds", nil);
    if (seconds == 1.0)
    {
        secondsPluralized = NSLocalizedString(@" second", nil);
    }
    
    if (formatType == MMXTimeIntervalFormatTypeShort)
    {
        formattedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutes, seconds];
        accessibilityString = [NSString stringWithFormat:@"%1.0f%@ %1.0f%@", minutes, minutesPluralized,
                                                                               seconds, secondsPluralized];
    }
    else if (formatType == MMXTimeIntervalFormatTypeLong)
    {
        formattedString = [NSString stringWithFormat:@"%1.0f%@ %1.0f%@", minutes, NSLocalizedString(@"m", nil),
                                                                         seconds, NSLocalizedString(@"s", nil)];
        accessibilityString = [NSString stringWithFormat:@"%1.0f%@ %1.0f%@", minutes, minutesPluralized,
                                                                             seconds, secondsPluralized];
    }
    
    return @[formattedString, accessibilityString];
}

+ (NSArray *)reportCardFormatWithInterval:(NSTimeInterval)interval
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
    
    NSString *hoursPluralized = NSLocalizedString(@" hours", nil);
    if (hours == 1.0)
    {
        hoursPluralized = NSLocalizedString(@" hour", nil);
    }
    
    NSString *minutesPluralized = NSLocalizedString(@" minutes", nil);
    if (minutes == 1.0)
    {
        minutesPluralized = NSLocalizedString(@" minute", nil);
    }
    
    NSString *secondsPluralized = NSLocalizedString(@" seconds", nil);
    if (seconds == 1.0)
    {
        secondsPluralized = NSLocalizedString(@" second", nil);
    }
    
    NSString *displayString = [NSString stringWithFormat:@"%1.0f%@ %1.0f%@ %1.0f%@", hours, NSLocalizedString(@"h", nil),
                                                                                     minutes, NSLocalizedString(@"m", nil),
                                                                                     seconds, NSLocalizedString(@"s", nil)];
    
    NSString *accessibilityString = [NSString stringWithFormat:@"%1.0f%@ %1.0f%@ %1.0f%@", hours, hoursPluralized,
                                                                                           minutes, minutesPluralized,
                                                                                           seconds, secondsPluralized];
    
    return @[displayString, accessibilityString];
}

@end
