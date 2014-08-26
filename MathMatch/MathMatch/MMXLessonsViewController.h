//
//  MMXLessonsViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.5.19.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

@interface MMXLessonsViewController : UITableViewController

FOUNDATION_EXPORT NSString * const kMMXLessonsViewControolerDidShowNotification;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSArray *lessons;

@property (nonatomic, assign) NSInteger indexOfNextLesson;

- (IBAction)unwindToLessonsSegue:(UIStoryboardSegue *)unwindSegue;

@end
