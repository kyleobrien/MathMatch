//
//  MMXFlatButton.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.22.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXFlatButton.h"

@implementation MMXFlatButton

- (void)changeButtonToColor:(UIColor *)color
{
    self.backgroundColor = color;
    
    [self customizeColors];
    [self setNeedsDisplay];
}

- (void)customizeColors
{
    self.originalBackgroundColor = self.backgroundColor;
    
    self.layer.borderColor = self.originalBackgroundColor.CGColor;
    
    self.backgroundColor = [UIColor clearColor];
    
    [self setTitleColor:self.originalBackgroundColor forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected | UIControlStateHighlighted)];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderWidth = 2.0;
    
    [self customizeColors];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted)
    {
        self.backgroundColor = self.originalBackgroundColor;
    }
    else
    {
        /*
         * The call to highlight occurs after the call to setSelected.
         * So after a setSelected:YES was called, a setHighlight:NO follows,
         * causing us to lose the style we just applied.
         */
        if (!self.selected)
        {
            self.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.backgroundColor = self.originalBackgroundColor;
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
