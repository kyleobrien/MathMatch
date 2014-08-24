//
//  MMXClassTableViewCell.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.6.26.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXClassTableViewCell.h"

@implementation MMXClassTableViewCell

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
        
        [[UIColor mmx_blueColor] getRed:&red green:&green blue:&blue alpha:&alpha];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:(alpha / 4.0)];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor mmx_whiteColor];
    }
}

@end
