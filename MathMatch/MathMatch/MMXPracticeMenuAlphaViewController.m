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

@property (nonatomic, strong) MMXGameData *gameData;

@end

@implementation MMXPracticeMenuAlphaViewController

NSString * const kMMXUserDefaultsPracticeNumberOfCards = @"MMXUserDefaultsPracticeNumberOfCards";
NSString * const kMMXUserDefaultsPracticeArithmeticType = @"MMXUserDefaultsPracticeArithmeticType";
NSString * const kMMXUserDefaultsPracticeStartingPosition = @"MMXUserDefaultsPracticeStartingPosition";
NSString * const kMMXUserDefaultsPracticeMusic = @"MMXUserDefaultsPracticeMusic";

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.gameData = [NSEntityDescription insertNewObjectForEntityForName:@"MMXGameData" inManagedObjectContext:self.managedObjectContext];
    self.gameData.gameType = MMXGameTypePractice;
    self.gameData.penaltyMultiplier = @5.0;
    
    [self loadUserDefaultsAndSetInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_orangeColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_blackColor];
    
    if (self.isMovingFromParentViewController)
    {
        [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapBackward;
        [[MMXAudioManager sharedManager] playSoundEffect];
        
        [MMXAudioManager sharedManager].track = MMXAudioTrackMenus;
        [[MMXAudioManager sharedManager] playTrack];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapForward;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    MMXPracticeMenuBetaViewController *betaViewController = (MMXPracticeMenuBetaViewController *)segue.destinationViewController;
    betaViewController.managedObjectContext = self.managedObjectContext;
    betaViewController.gameData = self.gameData;
}

- (IBAction)unwindToPracticeConfiguration:(UIStoryboardSegue *)unwindSegue
{
    
}

#pragma mark - Player Action

- (IBAction)numberButtonWasTapped:(id)sender
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    UIButton *button = (UIButton *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.number8Button.selected = (button == self.number8Button);
    self.number12Button.selected = (button == self.number12Button);
    self.number16Button.selected = (button == self.number16Button);
    self.number20Button.selected = (button == self.number20Button);
    self.number24Button.selected = (button == self.number24Button);
    
    if (button == self.number8Button)
    {
        self.gameData.numberOfCards = @8;
        [userDefaults setInteger:8 forKey:kMMXUserDefaultsPracticeNumberOfCards];
    }
    else if (button == self.number12Button)
    {
        self.gameData.numberOfCards = @12;
        [userDefaults setInteger:12 forKey:kMMXUserDefaultsPracticeNumberOfCards];
    }
    else if (button == self.number16Button)
    {
        self.gameData.numberOfCards = @16;
        [userDefaults setInteger:16 forKey:kMMXUserDefaultsPracticeNumberOfCards];
    }
    else if (button == self.number20Button)
    {
        self.gameData.numberOfCards = @20;
        [userDefaults setInteger:20 forKey:kMMXUserDefaultsPracticeNumberOfCards];
    }
    else if (button == self.number24Button)
    {
        self.gameData.numberOfCards = @24;
        [userDefaults setInteger:24 forKey:kMMXUserDefaultsPracticeNumberOfCards];
    }
}

- (IBAction)arithmeticButtonWasTapped:(id)sender
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    UIButton *button = (UIButton *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.arithmeticAdditionButton.selected = (button == self.arithmeticAdditionButton);
    self.arithmeticSubtractionButton.selected = (button == self.arithmeticSubtractionButton);
    self.arithmeticMultiplicationButton.selected = (button == self.arithmeticMultiplicationButton);
    self.arithmeticDivisionButton.selected = (button == self.arithmeticDivisionButton);
    
    if (button == self.arithmeticAdditionButton)
    {
        self.gameData.arithmeticType = MMXArithmeticTypeAddition;
        [userDefaults setInteger:MMXArithmeticTypeAddition forKey:kMMXUserDefaultsPracticeArithmeticType];
    }
    else if (button == self.arithmeticSubtractionButton)
    {
        self.gameData.arithmeticType = MMXArithmeticTypeSubtraction;
        [userDefaults setInteger:MMXArithmeticTypeSubtraction forKey:kMMXUserDefaultsPracticeArithmeticType];
    }
    else if (button == self.arithmeticMultiplicationButton)
    {
        self.gameData.arithmeticType = MMXArithmeticTypeMultiplication;
        [userDefaults setInteger:MMXArithmeticTypeMultiplication forKey:kMMXUserDefaultsPracticeArithmeticType];
    }
    else if (button == self.arithmeticDivisionButton)
    {
        self.gameData.arithmeticType = MMXArithmeticTypeDivision;
        [userDefaults setInteger:MMXArithmeticTypeDivision forKey:kMMXUserDefaultsPracticeArithmeticType];
    }
}

- (IBAction)memoryButtonWasTapped:(id)sender
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    UIButton *button = (UIButton *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.startingPositionFaceUpButton.selected = (button == self.startingPositionFaceUpButton);
    self.startingPositionMemorizeButton.selected = (button == self.startingPositionMemorizeButton);
    self.startingPositionFaceDownButton.selected = (button == self.startingPositionFaceDownButton);
    
    if (button == self.startingPositionFaceUpButton)
    {
        self.gameData.startingPositionType = MMXStartingPositionTypeFaceUp;
        [userDefaults setInteger:MMXStartingPositionTypeFaceUp forKey:kMMXUserDefaultsPracticeStartingPosition];
    }
    else if (button == self.startingPositionMemorizeButton)
    {
        self.gameData.startingPositionType = MMXStartingPositionTypeMemorize;
        [userDefaults setInteger:MMXStartingPositionTypeMemorize forKey:kMMXUserDefaultsPracticeStartingPosition];
    }
    else if (button == self.startingPositionFaceDownButton)
    {
        self.gameData.startingPositionType = MMXStartingPositionTypeFaceDown;
        [userDefaults setInteger:MMXStartingPositionTypeFaceDown forKey:kMMXUserDefaultsPracticeStartingPosition];
    }
}

- (IBAction)musicButtonWasTapped:(id)sender
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    UIButton *button = (UIButton *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.music1Button.selected = (button == self.music1Button);
    self.music2Button.selected = (button == self.music2Button);
    self.music3Button.selected = (button == self.music3Button);
    self.musicOffButton.selected = (button == self.musicOffButton);
    
    if (button == self.music1Button)
    {
        self.gameData.musicTrack = MMXMusicTrackEasy;
        [userDefaults setInteger:MMXMusicTrackEasy forKey:kMMXUserDefaultsPracticeMusic];
        
        [MMXAudioManager sharedManager].track = MMXAudioTrackGameplayEasy;
        [[MMXAudioManager sharedManager] playTrack];
    }
    else if (button == self.music2Button)
    {
        self.gameData.musicTrack = MMXMusicTrackMedium;
        [userDefaults setInteger:MMXMusicTrackMedium forKey:kMMXUserDefaultsPracticeMusic];
        
        [MMXAudioManager sharedManager].track = MMXAudioTrackGameplayMedium;
        [[MMXAudioManager sharedManager] playTrack];
    }
    else if (button == self.music3Button)
    {
        self.gameData.musicTrack = MMXMusicTrackHard;
        [userDefaults setInteger:MMXMusicTrackHard forKey:kMMXUserDefaultsPracticeMusic];
        
        [MMXAudioManager sharedManager].track = MMXAudioTrackGameplayHard;
        [[MMXAudioManager sharedManager] playTrack];
    }
    else if (button == self.musicOffButton)
    {
        self.gameData.musicTrack = MMXMusicTrackOff;
        [userDefaults setInteger:MMXMusicTrackOff forKey:kMMXUserDefaultsPracticeMusic];
        
        [[MMXAudioManager sharedManager] pauseTrack];
    }
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
    
    self.gameData.numberOfCards = @(numberOfCards);
    
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
    
    self.gameData.arithmeticType = arithmeticType;
    
    // Starting Position --------------
    MMXStartingPositionType startingPositionType = [userDefaults integerForKey:kMMXUserDefaultsPracticeStartingPosition];
    if (startingPositionType == MMXStartingPositionTypeFaceUp)
    {
        self.startingPositionFaceUpButton.selected = YES;
    }
    else if (startingPositionType == MMXStartingPositionTypeMemorize)
    {
        self.startingPositionMemorizeButton.selected = YES;
    }
    else if (startingPositionType == MMXStartingPositionTypeFaceDown)
    {
        self.startingPositionFaceDownButton.selected = YES;
    }
    else
    {
        self.startingPositionFaceUpButton.selected = YES;
        startingPositionType = MMXStartingPositionTypeFaceUp;
    }
    
    self.gameData.startingPositionType = startingPositionType;
    
    // Music Track --------------
    MMXMusicTrack musicTrack = [userDefaults integerForKey:kMMXUserDefaultsPracticeMusic];
    if (musicTrack == MMXMusicTrackEasy)
    {
        self.music1Button.selected = YES;
        
        [MMXAudioManager sharedManager].track = MMXAudioTrackGameplayEasy;
        [[MMXAudioManager sharedManager] playTrack];
    }
    else if (musicTrack == MMXMusicTrackMedium)
    {
        self.music2Button.selected = YES;
        
        [MMXAudioManager sharedManager].track = MMXAudioTrackGameplayMedium;
        [[MMXAudioManager sharedManager] playTrack];
    }
    else if (musicTrack == MMXMusicTrackHard)
    {
        self.music3Button.selected = YES;
        
        [MMXAudioManager sharedManager].track = MMXAudioTrackGameplayHard;
        [[MMXAudioManager sharedManager] playTrack];
    }
    else if (musicTrack == MMXMusicTrackOff)
    {
        self.musicOffButton.selected = YES;
        
        [[MMXAudioManager sharedManager] pauseTrack];
    }
    else
    {
        self.music1Button.selected = YES;
        musicTrack = MMXMusicTrackEasy;
        
        [MMXAudioManager sharedManager].track = MMXAudioTrackGameplayEasy;
        [[MMXAudioManager sharedManager] playTrack];
    }
    
    self.gameData.musicTrack = musicTrack;
}

@end
