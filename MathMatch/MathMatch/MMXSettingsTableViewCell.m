//
//  MMXSettingsTableViewCell.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.6.26.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXSettingsTableViewCell.h"

@implementation MMXSettingsTableViewCell

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [self shouldHighlightOrSelect:highlighted];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    [self shouldHighlightOrSelect:highlighted];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self shouldHighlightOrSelect:selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (animated)
    {
        [UIView animateWithDuration:0.3
                         animations:^
         {
             [self shouldHighlightOrSelect:selected];
         }];
    }
    else
    {
        [self shouldHighlightOrSelect:selected];
    }
}

- (void)shouldHighlightOrSelect:(BOOL)shouldHighlightOrSelect
{
    if (shouldHighlightOrSelect)
    {
        CGFloat red, green, blue, alpha;
        
        [[UIColor mmx_purpleColor] getRed:&red green:&green blue:&blue alpha:&alpha];
        
        self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:(alpha / 8.0)];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
