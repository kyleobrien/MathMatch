//
//  MMXMainMenuViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.16.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXMainMenuViewController.h"

@implementation MMXMainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[MMXAudioManager sharedManager].track = MMXAudioTrackMenus;
    //[[MMXAudioManager sharedManager] playTrack];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_blackColor];
}

- (IBAction)playerTappedMenuButton:(id)sender
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectMenuButtonTap;
    [[MMXAudioManager sharedManager] playSoundEffect];
}

@end
