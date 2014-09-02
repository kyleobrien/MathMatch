//
//  MMXAudioManager.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.5.13.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXAudioManager.h"

@interface MMXAudioManager ()
{
    AVAudioPlayer *_trackAudioPlayer;
    AVAudioPlayer *_bufferTrackAudioPlayer;
    AVAudioPlayer *_soundEffectAudioPlayer;
    AVAudioPlayer *_bufferSoundEffectAudioPlayer;
    
    NSTimer *_fadeTimer;
    
    float _volumeBeforeFading;
    
    BOOL _alreadyPlayingSameTrack;
}

- (void)configureTrackPlayer;
- (void)configureSoundEffectPlayer;

- (void)fadeTrackOutWithCrossfade:(BOOL)shouldCrossfadeAfterCompletion;
- (void)fadeTrackIn;

@end

@implementation MMXAudioManager

NSString * const kMMXAudioManagerDidChangeTrackVolumeNotification = @"MMXAudioManagerDidChangeTrackVolumeNotification";
NSString * const kMMXAudioManagerDidChangeSoundEffectVolumeNotification = @"MMXAudioManagerDidChangeSoundEffectVolumeNotification";
NSString * const kMMXAudioManagerDictionaryVolumeKey = @"MMXAudioManagerDictionaryVolumeKey";

NSString * const kMMXUserDefaultsTrackVolume = @"MMXUserDefaultsTrackVolume";
NSString * const kMMXUserDefaultsSoundEffectVolume = @"MMXUserDefaultsSoundEffectVolume";
NSString * const kMMXUserDefaultsAudioLevelsInitializedOnFirstRun = @"MMXUserDefaultsAudioLevelsInitializedOnFirstRun";

CGFloat const kMMXFadeTimeInSeconds = 0.25;
CGFloat const kMMXStepsToFade = 10;

@synthesize track = _track;
@synthesize soundEffect = _soundEffect;

+ (MMXAudioManager *)sharedManager
{
    static MMXAudioManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        sharedManager = [[self alloc] init];
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kMMXUserDefaultsAudioLevelsInitializedOnFirstRun])
        {
            [[NSUserDefaults standardUserDefaults] setFloat:0.25 forKey:kMMXUserDefaultsTrackVolume];
            [[NSUserDefaults standardUserDefaults] setFloat:0.75 forKey:kMMXUserDefaultsSoundEffectVolume];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMMXUserDefaultsAudioLevelsInitializedOnFirstRun];
            
            /*
             * The first instantiation of an audio player is always slow. Bug? (Probably not).
             * Instantiating, starting and stoping one to get past it.
             */
            
            AVAudioPlayer *firstInstantiationIsAlwaysSlow = [[AVAudioPlayer alloc] initWithContentsOfURL:nil error:nil];
            [firstInstantiationIsAlwaysSlow play];
            [firstInstantiationIsAlwaysSlow stop];
        }
    });
    
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _volumeBeforeFading = [[NSUserDefaults standardUserDefaults] floatForKey:kMMXUserDefaultsTrackVolume];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(trackVolumeChanged:)
                                                     name:kMMXAudioManagerDidChangeTrackVolumeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(soundEffectVolumeChanged:)
                                                     name:kMMXAudioManagerDidChangeSoundEffectVolumeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kMMXAudioManagerDidChangeTrackVolumeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kMMXAudioManagerDidChangeSoundEffectVolumeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

- (void)playTrack
{
    if (_alreadyPlayingSameTrack)
    {
        // Don't do anything.
    }
    else if (!_trackAudioPlayer.playing)
    {
        _trackAudioPlayer = _bufferTrackAudioPlayer;
        _trackAudioPlayer.currentTime = 0.0;
        
        [_trackAudioPlayer play];
    }
    else
    {
        [self fadeTrackOutWithCrossfade:YES];
    }
}

- (void)pauseTrack
{
    [_trackAudioPlayer stop];
}

- (void)playSoundEffect
{
    [_soundEffectAudioPlayer stop];

    _soundEffectAudioPlayer = _bufferSoundEffectAudioPlayer;
    _soundEffectAudioPlayer.currentTime = 0.0;
    
    [_soundEffectAudioPlayer play];
}

#pragma mark - Helpers

- (void)configureTrackPlayer
{
    NSString *filenameWithoutExtension = nil;
    if (_track == MMXAudioTrackMenus)
    {
        filenameWithoutExtension = @"track_go_doge_go";
    }
    else if (_track == MMXAudioTrackGameplayEasy)
    {
        filenameWithoutExtension = @"track_pencil_maze";
    }
    else if (_track == MMXAudioTrackGameplayMedium)
    {
        filenameWithoutExtension = @"track_frozen_leaves";
    }
    else if (_track == MMXAudioTrackGameplayHard)
    {
        filenameWithoutExtension = @"track_boring_cavern";
    }
    else if (_track == MMXAudioTrackResults)
    {
        filenameWithoutExtension = @"track_wonder_place";
    }
    
    if (filenameWithoutExtension)
    {
        NSURL *url = [[NSBundle mainBundle] URLForResource:filenameWithoutExtension withExtension:@".caf"];
        
        _bufferTrackAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _bufferTrackAudioPlayer.numberOfLoops = -1;
        _bufferTrackAudioPlayer.delegate = self;
        _bufferTrackAudioPlayer.volume = [[NSUserDefaults standardUserDefaults] floatForKey:kMMXUserDefaultsTrackVolume];
        
        [_bufferTrackAudioPlayer prepareToPlay];
    }
}

- (void)configureSoundEffectPlayer
{
    NSString *filenameWithoutExtension = nil;

    if (_soundEffect == MMXAudioSoundEffectTapForward)
    {
        filenameWithoutExtension = @"sfx_tap_forward";
    }
    else if (_soundEffect == MMXAudioSoundEffectTapBackward)
    {
        filenameWithoutExtension = @"sfx_tap_backward";
    }
    else if (_soundEffect == MMXAudioSoundEffectTapNeutral)
    {
        filenameWithoutExtension = @"sfx_tap_neutral";
    }
    else if (_soundEffect == MMXAudioSoundEffectSuccess)
    {
        filenameWithoutExtension = @"sfx_success";
    }
    else if (_soundEffect == MMXAudioSoundEffectFail)
    {
        filenameWithoutExtension = @"sfx_fail";
    }
    else if (_soundEffect == MMXAudioSoundEffectDeal)
    {
        filenameWithoutExtension = @"sfx_deal";
    }
    else if (_soundEffect == MMXAudioSoundEffectCountdownTone)
    {
        filenameWithoutExtension = @"sfx_countdown_tone";
    }
    else if (_soundEffect == MMXAudioSoundEffectFireworks)
    {
        filenameWithoutExtension = @"sfx_fireworks";
    }
    else if (_soundEffect == MMXAudioSoundEffectWhoosh)
    {
        filenameWithoutExtension = @"sfx_whoosh";
    }
    
    if (filenameWithoutExtension)
    {
        NSURL *url = [[NSBundle mainBundle] URLForResource:filenameWithoutExtension withExtension:@".caf"];
        
        _bufferSoundEffectAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _bufferSoundEffectAudioPlayer.delegate = self;
        _bufferSoundEffectAudioPlayer.volume = [[NSUserDefaults standardUserDefaults] floatForKey:kMMXUserDefaultsSoundEffectVolume];
        
        [_bufferSoundEffectAudioPlayer prepareToPlay];
    }
}

- (void)fadeTrackOutWithCrossfade:(BOOL)shouldCrossfadeAfterCompletion
{
    _volumeBeforeFading = _trackAudioPlayer.volume;
    _fadeTimer = [NSTimer scheduledTimerWithTimeInterval:(kMMXFadeTimeInSeconds / kMMXStepsToFade)
                                                  target:self
                                                selector:@selector(adjustVolumeForFadeOut:)
                                                userInfo:@(shouldCrossfadeAfterCompletion)
                                                 repeats:YES];
}

- (void)adjustVolumeForFadeOut:(NSTimer *)timer
{
    float adjustedVolume = _trackAudioPlayer.volume - (_volumeBeforeFading / kMMXStepsToFade);
    if (adjustedVolume < 0.0)
    {
        adjustedVolume = 0.0;
    }
    
    _trackAudioPlayer.volume = adjustedVolume;
    
    if (_trackAudioPlayer.volume == 0.0)
    {
        /*
         * Invalidating the timer causes it to drop it's reference to the user info object,
         * so trying to access it after it's been released is an obvious exception.
         * Unboxing first so we can use it.
         */
        BOOL shouldCrossfadeAfterCompletion = ((NSNumber *)timer.userInfo).boolValue;
        
        [_fadeTimer invalidate];
        [_trackAudioPlayer stop];
        
        if (shouldCrossfadeAfterCompletion)
        {
            _trackAudioPlayer = _bufferTrackAudioPlayer;

            [self fadeTrackIn];
        }
    }
}

- (void)fadeTrackIn
{
    _trackAudioPlayer.volume = 0.0;
    [_trackAudioPlayer play];
    
    _fadeTimer = [NSTimer scheduledTimerWithTimeInterval:(kMMXFadeTimeInSeconds / kMMXStepsToFade)
                                                  target:self
                                                selector:@selector(adjustVolumeForFadeIn:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)adjustVolumeForFadeIn:(NSTimer *)timer
{
    float adjustedVolume = _trackAudioPlayer.volume + (_volumeBeforeFading / kMMXStepsToFade);
    if (adjustedVolume > _volumeBeforeFading)
    {
        adjustedVolume = _volumeBeforeFading;
    }
    
    _trackAudioPlayer.volume = adjustedVolume;
    
    if (_trackAudioPlayer.volume == _volumeBeforeFading)
    {
        [_fadeTimer invalidate];
    }
}

#pragma mark - Properties

- (MMXAudioTrack)track
{
    return _track;
}

- (void)setTrack:(MMXAudioTrack)track
{
    if (!(_track == track) || !_trackAudioPlayer.playing)
    {
        _track = track;
        
        [self configureTrackPlayer];
        
        _alreadyPlayingSameTrack = NO;
    }
    else
    {
        _alreadyPlayingSameTrack = YES;
    }
}

- (MMXAudioSoundEffect)soundEffect
{
    return _soundEffect;
}

- (void)setSoundEffect:(MMXAudioSoundEffect)soundEffect
{
    if (!(_soundEffect == soundEffect))
    {
        _soundEffect = soundEffect;
        
        [self configureSoundEffectPlayer];
    }
}

#pragma mark - Notifications

- (void)trackVolumeChanged:(NSNotification *)notification
{
    NSNumber *volume = notification.userInfo[kMMXAudioManagerDictionaryVolumeKey];
    
    _trackAudioPlayer.volume = volume.floatValue;
    _bufferTrackAudioPlayer.volume = volume.floatValue;
    
    [[NSUserDefaults standardUserDefaults] setFloat:volume.floatValue forKey:kMMXUserDefaultsTrackVolume];
}

- (void)soundEffectVolumeChanged:(NSNotification *)notification
{
    NSNumber *volume = notification.userInfo[kMMXAudioManagerDictionaryVolumeKey];
    
    _soundEffectAudioPlayer.volume = volume.floatValue;
    _bufferSoundEffectAudioPlayer.volume = volume.floatValue;
    
    [[NSUserDefaults standardUserDefaults] setFloat:volume.floatValue forKey:kMMXUserDefaultsSoundEffectVolume];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    if ([[AVAudioSession sharedInstance] isOtherAudioPlaying])
    {
        // Don't do anything. The player is listening to audio from another source.
    }
    else
    {
        [self fadeTrackIn];
    }
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    if ([[AVAudioSession sharedInstance] isOtherAudioPlaying])
    {
        // Don't do anything. The player is listening to audio from another source.
    }
    else
    {
        [self fadeTrackOutWithCrossfade:NO];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}

@end
