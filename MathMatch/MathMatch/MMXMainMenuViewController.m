//
//  MMXMainMenuViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.16.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXClassesViewController.h"
#import "MMXMainMenuViewController.h"
#import "MMXNavigationController.h"
#import "MMXPracticeMenuAlphaViewController.h"
#import "MMXSettingsViewController.h"

@implementation MMXMainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_blackColor];
}

- (IBAction)playerTappedMenuButton:(id)sender
{
    //[MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectMenuButtonTap;
    //[[MMXAudioManager sharedManager] playSoundEffect];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectMenuButtonTap;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    MMXNavigationController *navigationController = (MMXNavigationController *)self.navigationController;
    
    if ([segue.identifier isEqualToString:@"MMXClassesSegue"])
    {
        MMXClassesViewController *classesViewController = (MMXClassesViewController *)segue.destinationViewController;
        classesViewController.managedObjectContext = navigationController.managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"MMXPracticeSegue"])
    {
        MMXPracticeMenuAlphaViewController *practiceViewController = (MMXPracticeMenuAlphaViewController *)segue.destinationViewController;
        practiceViewController.managedObjectContext = navigationController.managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"MMXSettingsSegue"])
    {
        MMXNavigationController *modalNavigationController = (MMXNavigationController *)segue.destinationViewController;
        modalNavigationController.managedObjectContext = navigationController.managedObjectContext;
    }
}

@end
