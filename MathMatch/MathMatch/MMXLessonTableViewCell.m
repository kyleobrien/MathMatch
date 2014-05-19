//
//  MMXLessonTableViewCell.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.5.19.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXLessonTableViewCell.h"

@implementation MMXLessonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
