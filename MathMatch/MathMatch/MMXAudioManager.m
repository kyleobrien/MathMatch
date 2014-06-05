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

- (void)fadeTrackOut;
- (void)fadeTrackIn;

@end

@implementation MMXAudioManager

NSString * const kMMXNotificationTrackVolumeChanged = @"MMXNotificationTrackVolumeChanged";
NSString * const kMMXNotificationSoundEffectVolumeChanged = @"MMXNotificationSoundEffectVolumeChanged";
NSString * const kMMXNotificationDictionaryVolumeKey = @"MMXDictionaryVolumeKey";

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
            [[NSUserDefaults standardUserDefaults] setFloat:1.0 forKey:kMMXUserDefaultsTrackVolume];
            [[NSUserDefaults standardUserDefaults] setFloat:1.0 forKey:kMMXUserDefaultsSoundEffectVolume];
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

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(trackVolumeChanged:)
                                                     name:kMMXNotificationTrackVolumeChanged
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(soundEffectVolumeChanged:)
                                                     name:kMMXNotificationSoundEffectVolumeChanged
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kMMXNotificationTrackVolumeChanged
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kMMXNotificationSoundEffectVolumeChanged
                                                  object:nil];
}

- (void)playTrack
{
    if (_alreadyPlayingSameTrack)
    {
        
    }
    else if (!_trackAudioPlayer.playing)
    {
        _trackAudioPlayer = _bufferTrackAudioPlayer;
        _trackAudioPlayer.currentTime = 0.0;
        
        [_trackAudioPlayer play];
    }
    else
    {
        _volumeBeforeFading = _trackAudioPlayer.volume;
        _fadeTimer = [NSTimer scheduledTimerWithTimeInterval:(kMMXFadeTimeInSeconds / kMMXStepsToFade)
                                                  target:self
                                                selector:@selector(fadeTrackOut)
                                                userInfo:nil
                                                 repeats:YES];
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
        filenameWithoutExtension = @"destination-01";
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
    if (_soundEffect == MMXAudioSoundEffectMenuButtonTap)
    {
        filenameWithoutExtension = @"button-44";
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

- (void)fadeTrackOut
{
    float adjustedVolume = _trackAudioPlayer.volume - (_volumeBeforeFading / kMMXStepsToFade);
    if (adjustedVolume < 0.0)
    {
        adjustedVolume = 0.0;
    }
    
    _trackAudioPlayer.volume = adjustedVolume;
    
    if (_trackAudioPlayer.volume == 0.0)
    {
        [_fadeTimer invalidate];
        [_trackAudioPlayer stop];
        
        _trackAudioPlayer = _bufferTrackAudioPlayer;
        
        _trackAudioPlayer.volume = 0.0;
        [_trackAudioPlayer play];
        
        _fadeTimer = [NSTimer scheduledTimerWithTimeInterval:(kMMXFadeTimeInSeconds / kMMXStepsToFade)
                                                  target:self
                                                selector:@selector(fadeTrackIn)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)fadeTrackIn
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
    if (!(_track == track))
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
    NSNumber *volume = notification.userInfo[kMMXNotificationDictionaryVolumeKey];
    
    _trackAudioPlayer.volume = volume.floatValue;
    _bufferTrackAudioPlayer.volume = volume.floatValue;
    
    [[NSUserDefaults standardUserDefaults] setFloat:volume.floatValue forKey:kMMXUserDefaultsTrackVolume];
}

- (void)soundEffectVolumeChanged:(NSNotification *)notification
{
    NSNumber *volume = notification.userInfo[kMMXNotificationDictionaryVolumeKey];
    
    _soundEffectAudioPlayer.volume = volume.floatValue;
    _bufferSoundEffectAudioPlayer.volume = volume.floatValue;
    
    [[NSUserDefaults standardUserDefaults] setFloat:volume.floatValue forKey:kMMXUserDefaultsSoundEffectVolume];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if (player == _trackAudioPlayer)
    {
        [self playTrack];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}

@end
