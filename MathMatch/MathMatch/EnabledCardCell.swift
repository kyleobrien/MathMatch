//
//  EnabledCardCell.swift
//  MathMatch
//
//  Created by Kyle O'Brien on 2016.03.12.
//  Copyright © 2016 Kyle O'Brien All rights reserved.
//

import UIKit

class EnabledCardCell: UICollectionViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var disabledCardView: UIView!
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var xImageView: UIImageView!
    
    // MARK: Methods
    
    func configureForEnabled(enabled: Bool) {
        if enabled {
            self.disabledCardView.alpha = 0.0
            self.checkmarkImageView.alpha = 1.0
            self.xImageView.alpha = 0.0
        }
        else {
            self.disabledCardView.alpha = 1.0
            self.checkmarkImageView.alpha = 0.0
            self.xImageView.alpha = 1.0
        }
    }
}
