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
    [self shouldHighlightOrSelect:highlighted];
    
    [super setHighlighted:highlighted];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [self shouldHighlightOrSelect:highlighted];
    
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected
{
    [self shouldHighlightOrSelect:selected];
    
    [super setSelected:selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
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
    
    [super setSelected:selected animated:animated];
}

- (void)shouldHighlightOrSelect:(BOOL)shouldHighlightOrSelect
{
    if (shouldHighlightOrSelect)
    {
        CGFloat red, green, blue, alpha;
        
        [[UIColor mmx_purpleColor] getRed:&red green:&green blue:&blue alpha:&alpha];
        
        self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:(alpha / 6.0)];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
