//
//  VolumeCell.swift
//  MathMatch
//
//  Created by Kyle O'Brien on 2016.6.24.
//  Copyright © 2016 Computer Lab. All rights reserved.
//

import UIKit

enum VolumeSettingType: Int {
    case None = 0
    case Track = 1
    case SFX = 2
}

class VolumeCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    var volumeSettingType = VolumeSettingType.None
    
    
    // MARK: Methods
    
    @IBAction func volumeSliderValueChanged(sender: UISlider) {
        if (self.volumeSettingType == VolumeSettingType.Track) {
            NSNotificationCenter.defaultCenter().postNotificationName(kMMXAudioManagerDidChangeTrackVolumeNotification, object: nil, userInfo: [kMMXAudioManagerDictionaryVolumeKey: self.volumeSlider.value])
            NSUserDefaults.standardUserDefaults().setFloat(self.volumeSlider.value, forKey: kMMXUserDefaultsTrackVolume)
        }
        else if (self.volumeSettingType == VolumeSettingType.SFX) {
            NSNotificationCenter.defaultCenter().postNotificationName(kMMXAudioManagerDidChangeSoundEffectVolumeNotification, object: nil, userInfo: [kMMXAudioManagerDictionaryVolumeKey: self.volumeSlider.value])
            NSUserDefaults.standardUserDefaults().setFloat(self.volumeSlider.value, forKey: kMMXUserDefaultsSoundEffectVolume)
        }
    }
    
    func configureSliderWithUserDefaults() {
        var volume: Float = 0.5
        
        if (self.volumeSettingType == VolumeSettingType.Track) {
            volume = NSUserDefaults.standardUserDefaults().floatForKey(kMMXUserDefaultsTrackVolume)
        }
        else if (self.volumeSettingType == VolumeSettingType.SFX) {
            volume = NSUserDefaults.standardUserDefaults().floatForKey(kMMXUserDefaultsSoundEffectVolume)
        }
        
        self.volumeSlider.value = volume
    }
}
