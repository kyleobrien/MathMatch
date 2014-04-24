//
//  MMXPracticeMenuViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.16.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXPracticeMenuAlphaViewController.h"
#import "MMXPracticeMenuBetaViewController.h"

@interface MMXPracticeMenuAlphaViewController ()

@property (nonatomic, strong) MMXGameConfiguration *gameConfiguration;

@end

@implementation MMXPracticeMenuAlphaViewController

NSString * const kMMXUserDefaultsPracticeNumberOfCards = @"MMXUserDefaultsPracticeNumberOfCards";
NSString * const kMMXUserDefaultsPracticeArithmeticType = @"MMXUserDefaultsPracticeArithmeticType";
NSString * const kMMXUserDefaultsPracticeMemorySpeed = @"MMXUserDefaultsPracticeMemorySpeed";
NSString * const kMMXUserDefaultsPracticeMusic = @"MMXUserDefaultsPracticeMusic";

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.gameConfiguration = [[MMXGameConfiguration alloc] init];
        self.gameConfiguration.gameType = MMXGameTypePractice;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadUserDefaultsAndSetInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(255.0 / 255.0)
                                                                           green:(143.0 / 255.0)
                                                                            blue:(0.0 / 255.0)
                                                                           alpha:1.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(43.0 / 255.0)
                                                                           green:(43.0 / 255.0)
                                                                            blue:(43.0 / 255.0)
                                                                           alpha:1.0];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MMXPracticeMenuBetaViewController *betaViewController = (MMXPracticeMenuBetaViewController *)segue.destinationViewController;
    betaViewController.gameConfiguration = self.gameConfiguration;
}

#pragma mark - Player Action

- (IBAction)numberButtonWasTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.number8Button.selected = (button == self.number8Button);
    self.number12Button.selected = (button == self.number12Button);
    self.number16Button.selected = (button == self.number16Button);
    self.number20Button.selected = (button == self.number20Button);
    self.number24Button.selected = (button == self.number24Button);
    
    if (button == self.number8Button)
    {
        self.gameConfiguration.numberOfCards = 8;
        [userDefaults setInteger:8 forKey:kMMXUserDefaultsPracticeNumberOfCards];
    }
    else if (button == self.number12Button)
    {
        self.gameConfiguration.numberOfCards = 12;
        [userDefaults setInteger:12 forKey:kMMXUserDefaultsPracticeNumberOfCards];
    }
    else if (button == self.number16Button)
    {
        self.gameConfiguration.numberOfCards = 16;
        [userDefaults setInteger:16 forKey:kMMXUserDefaultsPracticeNumberOfCards];
    }
    else if (button == self.number20Button)
    {
        self.gameConfiguration.numberOfCards = 20;
        [userDefaults setInteger:20 forKey:kMMXUserDefaultsPracticeNumberOfCards];
    }
    else if (button == self.number24Button)
    {
        self.gameConfiguration.numberOfCards = 24;
        [userDefaults setInteger:24 forKey:kMMXUserDefaultsPracticeNumberOfCards];
    }
}

- (IBAction)arithmeticButtonWasTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.arithmeticAdditionButton.selected = (button == self.arithmeticAdditionButton);
    self.arithmeticSubtractionButton.selected = (button == self.arithmeticSubtractionButton);
    self.arithmeticMultiplicationButton.selected = (button == self.arithmeticMultiplicationButton);
    self.arithmeticDivisionButton.selected = (button == self.arithmeticDivisionButton);
    
    if (button == self.arithmeticAdditionButton)
    {
        self.gameConfiguration.arithmeticType = MMXArithmeticTypeAddition;
        [userDefaults setInteger:MMXArithmeticTypeAddition forKey:kMMXUserDefaultsPracticeArithmeticType];
    }
    else if (button == self.arithmeticSubtractionButton)
    {
        self.gameConfiguration.arithmeticType = MMXArithmeticTypeSubtraction;
        [userDefaults setInteger:MMXArithmeticTypeSubtraction forKey:kMMXUserDefaultsPracticeArithmeticType];
    }
    else if (button == self.arithmeticMultiplicationButton)
    {
        self.gameConfiguration.arithmeticType = MMXArithmeticTypeMultiplication;
        [userDefaults setInteger:MMXArithmeticTypeMultiplication forKey:kMMXUserDefaultsPracticeArithmeticType];
    }
    else if (button == self.arithmeticDivisionButton)
    {
        self.gameConfiguration.arithmeticType = MMXArithmeticTypeDivision;
        [userDefaults setInteger:MMXArithmeticTypeDivision forKey:kMMXUserDefaultsPracticeArithmeticType];
    }
}

- (IBAction)memoryButtonWasTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.memorySlowButton.selected = (button == self.memorySlowButton);
    self.memoryFastButton.selected = (button == self.memoryFastButton);
    self.memoryNoneButton.selected = (button == self.memoryNoneButton);
    
    if (button == self.memorySlowButton)
    {
        self.gameConfiguration.memorySpeed = MMXMemorySpeedSlow;
        [userDefaults setInteger:MMXMemorySpeedSlow forKey:kMMXUserDefaultsPracticeMemorySpeed];
    }
    else if (button == self.memoryFastButton)
    {
        self.gameConfiguration.memorySpeed = MMXMemorySpeedFast;
        [userDefaults setInteger:MMXMemorySpeedFast forKey:kMMXUserDefaultsPracticeMemorySpeed];
    }
    else if (button == self.memoryNoneButton)
    {
        self.gameConfiguration.memorySpeed = MMXMemorySpeedNone;
        [userDefaults setInteger:MMXMemorySpeedNone forKey:kMMXUserDefaultsPracticeMemorySpeed];
    }
}

- (IBAction)musicButtonWasTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.music1Button.selected = (button == self.music1Button);
    self.music2Button.selected = (button == self.music2Button);
    self.music3Button.selected = (button == self.music3Button);
    self.musicOffButton.selected = (button == self.musicOffButton);
    
    if (button == self.music1Button)
    {
        self.gameConfiguration.musicTrack = MMXMusicTrack1;
        [userDefaults setInteger:MMXMusicTrack1 forKey:kMMXUserDefaultsPracticeMusic];
    }
    else if (button == self.music2Button)
    {
        self.gameConfiguration.musicTrack = MMXMusicTrack2;
        [userDefaults setInteger:MMXMusicTrack2 forKey:kMMXUserDefaultsPracticeMusic];
    }
    else if (button == self.music3Button)
    {
        self.gameConfiguration.musicTrack = MMXMusicTrack3;
        [userDefaults setInteger:MMXMusicTrack3 forKey:kMMXUserDefaultsPracticeMusic];
    }
    else if (button == self.musicOffButton)
    {
        self.gameConfiguration.musicTrack = MMXMusicTrackOff;
        [userDefaults setInteger:MMXMusicTrackOff forKey:kMMXUserDefaultsPracticeMusic];
    }
}

- (IBAction)unwindToPracticeConfiguration:(UIStoryboardSegue *)unwindSegue;
{
    
}

#pragma mark - Other Instance Methods

- (void)loadUserDefaultsAndSetInterface
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Number of Cards --------------
    NSInteger numberOfCards = [userDefaults integerForKey:kMMXUserDefaultsPracticeNumberOfCards];
    
    if (numberOfCards == 8)
    {
        self.number8Button.selected = YES;
    }
    else if (numberOfCards == 12)
    {
        self.number12Button.selected = YES;
    }
    else if (numberOfCards == 16)
    {
        self.number16Button.selected = YES;
    }
    else if (numberOfCards == 20)
    {
        self.number20Button.selected = YES;
    }
    else if (numberOfCards == 24)
    {
        self.number24Button.selected = YES;
    }
    else
    {
        self.number8Button.selected = YES;
        numberOfCards = 8;
    }
    
    self.gameConfiguration.numberOfCards = numberOfCards;
    
    // Arithmetic Type --------------
    MMXArithmeticType arithmeticType = [userDefaults integerForKey:kMMXUserDefaultsPracticeArithmeticType];
    if (arithmeticType == MMXArithmeticTypeAddition)
    {
        self.arithmeticAdditionButton.selected = YES;
    }
    else if (arithmeticType == MMXArithmeticTypeSubtraction)
    {
        self.arithmeticSubtractionButton.selected = YES;
    }
    else if (arithmeticType == MMXArithmeticTypeMultiplication)
    {
        self.arithmeticMultiplicationButton.selected = YES;
    }
    else if (arithmeticType == MMXArithmeticTypeDivision)
    {
        self.arithmeticDivisionButton.selected = YES;
    }
    else
    {
        self.arithmeticAdditionButton.selected = YES;
        arithmeticType = MMXArithmeticTypeAddition;
    }
    
    self.gameConfiguration.arithmeticType = arithmeticType;
    
    // Memory Speed --------------
    MMXMemorySpeed memorySpeed = [userDefaults integerForKey:kMMXUserDefaultsPracticeMemorySpeed];
    if (memorySpeed == MMXMemorySpeedSlow)
    {
        self.memorySlowButton.selected = YES;
    }
    else if (memorySpeed == MMXMemorySpeedFast)
    {
        self.memoryFastButton.selected = YES;
    }
    else if (memorySpeed == MMXMemorySpeedNone)
    {
        self.memoryNoneButton.selected = YES;
    }
    else
    {
        self.memorySlowButton.selected = YES;
        memorySpeed = MMXMemorySpeedSlow;
    }
    
    self.gameConfiguration.memorySpeed = memorySpeed;
    
    // Music Track --------------
    MMXMusicTrack musicTrack = [userDefaults integerForKey:kMMXUserDefaultsPracticeMusic];
    if (musicTrack == MMXMusicTrack1)
    {
        self.music1Button.selected = YES;
    }
    else if (musicTrack == MMXMusicTrack2)
    {
        self.music2Button.selected = YES;
    }
    else if (musicTrack == MMXMusicTrack3)
    {
        self.music3Button.selected = YES;
    }
    else if (musicTrack == MMXMusicTrackOff)
    {
        self.musicOffButton.selected = YES;
    }
    else
    {
        self.music1Button.selected = YES;
        musicTrack = MMXMusicTrack1;
    }
    
    self.gameConfiguration.musicTrack = musicTrack;
}

@end
