//
//  MMXVolumeCell.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.6.20.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXVolumeCell.h"

@implementation MMXVolumeCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.volumeSettingType = MMXVolumeSettingTypeNone;
    }
    
    return self;
}

- (IBAction)volumeSliderValueChanged:(id)sender
{
    if (self.volumeSettingType == MMXVolumeSettingTypeTrack)
    {
        NSDictionary *userInfo = @{kMMXAudioManagerDictionaryVolumeKey: [NSNumber numberWithFloat:self.volumeSlider.value]};
        [[NSNotificationCenter defaultCenter] postNotificationName:kMMXAudioManagerDidChangeTrackVolumeNotification
                                                            object:nil
                                                          userInfo:userInfo];
        
        [[NSUserDefaults standardUserDefaults] setFloat:self.volumeSlider.value forKey:kMMXUserDefaultsTrackVolume];
    }
    else if (self.volumeSettingType == MMXVolumeSettingTypeSFX)
    {
        NSDictionary *userInfo = @{kMMXAudioManagerDictionaryVolumeKey: [NSNumber numberWithFloat:self.volumeSlider.value]};
        [[NSNotificationCenter defaultCenter] postNotificationName:kMMXAudioManagerDidChangeSoundEffectVolumeNotification
                                                            object:nil
                                                          userInfo:userInfo];
        
        [[NSUserDefaults standardUserDefaults] setFloat:self.volumeSlider.value forKey:kMMXUserDefaultsSoundEffectVolume];
    }
}

- (void)configureSliderWithUserDefaults
{
    float volume = 0.5;
    if (self.volumeSettingType == MMXVolumeSettingTypeTrack)
    {
        volume = [[NSUserDefaults standardUserDefaults] floatForKey:kMMXUserDefaultsTrackVolume];
    }
    else if (self.volumeSettingType == MMXVolumeSettingTypeSFX)
    {
        volume = [[NSUserDefaults standardUserDefaults] floatForKey:kMMXUserDefaultsSoundEffectVolume];
    }
    
    self.volumeSlider.value = volume;
}

@end
