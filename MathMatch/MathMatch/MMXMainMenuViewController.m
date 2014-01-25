//
//  MMXMainMenuViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.16.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXMainMenuViewController.h"

@interface MMXMainMenuViewController ()

@end

@implementation MMXMainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(43.0 / 255.0)
                                                                           green:(43.0 / 255.0)
                                                                            blue:(43.0 / 255.0)
                                                                           alpha:1.0];
}

@end
