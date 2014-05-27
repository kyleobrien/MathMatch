//
//  MMXLessonsViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.5.19.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

@interface MMXLessonsViewController : UITableViewController

@property (nonatomic, strong) NSArray *lessons;

- (IBAction)unwindToLessonsSegue:(UIStoryboardSegue *)unwindSegue;

@end
