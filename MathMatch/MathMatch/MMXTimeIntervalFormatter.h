//
//  MMXTimeIntervalFormatter.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.4.24.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

typedef NS_ENUM(NSUInteger, MMXTimeIntervalFormatType)
{
    MMXTimeIntervalFormatTypeShort,
    MMXTimeIntervalFormatTypeLong
};

@interface MMXTimeIntervalFormatter : NSObject

+ (NSString *)stringWithInterval:(NSTimeInterval)interval forFormatType:(MMXTimeIntervalFormatType)formatType;
+ (NSString *)reportCardFormatWithInterval:(NSTimeInterval)interval;

@end
