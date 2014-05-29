//
//  MMXTopScore.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.5.29.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

@interface MMXTopScore : NSManagedObject

@property (nonatomic, strong) NSNumber *lessonID;
@property (nonatomic, strong) NSNumber *stars;
@property (nonatomic, strong) NSNumber *time;

@property (nonatomic, strong) NSManagedObject *gameData;

@end
