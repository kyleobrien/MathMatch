//
//  MMXVolumeCell.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.6.20.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

typedef NS_ENUM(NSInteger, VolumeSettingType)
{
    VolumeSettingTypeNone = 0,
    VolumeSettingTypeTrack = 1,
    VolumeSettingTypeSFX = 2
};

@interface MMXVolumeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UISlider *volumeSlider;

@property (nonatomic, assign) VolumeSettingType volumeSettingType;

- (IBAction)volumeSliderValueChanged:(id)sender;

- (void)configureSliderWithUserDefaults;

@end
