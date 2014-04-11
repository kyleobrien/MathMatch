//
//  MMXMainMenuViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.16.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXMainMenuViewController.h"

@implementation MMXMainMenuViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(43.0 / 255.0)
                                                                           green:(43.0 / 255.0)
                                                                            blue:(43.0 / 255.0)
                                                                           alpha:1.0];
}

@end
