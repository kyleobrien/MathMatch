//
//  MMXAudioManager.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.5.13.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

@import AVFoundation;

FOUNDATION_EXPORT NSString * const kMMXAudioManagerDidChangeTrackVolumeNotification;
FOUNDATION_EXPORT NSString * const kMMXAudioManagerDidChangeSoundEffectVolumeNotification;
FOUNDATION_EXPORT NSString * const kMMXAudioManagerDictionaryVolumeKey;

FOUNDATION_EXPORT NSString * const kMMXUserDefaultsTrackVolume;
FOUNDATION_EXPORT NSString * const kMMXUserDefaultsSoundEffectVolume;
FOUNDATION_EXPORT NSString * const kMMXUserDefaultsAudioLevelsInitializedOnFirstRun;

FOUNDATION_EXPORT CGFloat const kMMXFadeTimeInSeconds;
FOUNDATION_EXPORT CGFloat const kMMXStepsToFade;

typedef NS_ENUM(NSUInteger, MMXAudioTrack)
{
    MMXAudioTrackNone,
    MMXAudioTrackMenus,
    MMXAudioTrackGameplayEasy,
    MMXAudioTrackGameplayMedium,
    MMXAudioTrackGameplayHard,
    MMXAudioTrackResults
};

typedef NS_ENUM(NSUInteger, MMXAudioSoundEffect)
{
    MMXAudioSoundEffectNone,
    MMXAudioSoundEffectFlip,
    MMXAudioSoundEffectTapForward,
    MMXAudioSoundEffectTapBackward,
    MMXAudioSoundEffectTapNeutral,
    MMXAudioSoundEffectSuccess,
    MMXAudioSoundEffectFail,
    MMXAudioSoundEffectDeal,
    MMXAudioSoundEffectCountdownTone,
    MMXAudioSoundEffectFireworks,
    MMXAudioSoundEffectWhoosh
};

@interface MMXAudioManager : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, assign) MMXAudioTrack track;
@property (nonatomic, assign) MMXAudioSoundEffect soundEffect;

+ (MMXAudioManager *)sharedManager;

- (void)playTrack;
- (void)pauseTrack;

- (void)playSoundEffect;

@end
