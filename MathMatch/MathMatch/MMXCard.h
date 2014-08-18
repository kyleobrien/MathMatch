//
//  MMXCard.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.2.11.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

@interface MMXCard : NSObject

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

- (instancetype)initWithValue:(NSInteger)value;
- (void)flip;

@end
