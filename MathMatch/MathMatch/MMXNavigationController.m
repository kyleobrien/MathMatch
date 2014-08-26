//
//  MMXNavigationController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.21.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXLessonsViewController.h"
#import "MMXMainMenuViewController.h"
#import "MMXNavigationController.h"

@implementation MMXNavigationController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.delegate = self;
    }
    
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController class] == [MMXMainMenuViewController class] || [viewController class] == [MMXLessonsViewController class])
    {
        [self.managedObjectContext rollback];
        
        if ([viewController class] == [MMXLessonsViewController class])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMMXLessonsViewControolerDidShowNotification object:nil];
        }
    }
}

@end
