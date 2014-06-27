//
//  MMXLessonTableViewCell.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.5.19.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXClassTableViewCell.h"

@interface MMXLessonTableViewCell : MMXClassTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lessonTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *starCountLabel;
@property (nonatomic, weak) IBOutlet UIImageView *starImageView;

@end
