//
//  MMXAboutViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.7.1.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXAboutViewController.h"

@implementation MMXAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@", info[@"CFBundleShortVersionString"]];
}

@end
