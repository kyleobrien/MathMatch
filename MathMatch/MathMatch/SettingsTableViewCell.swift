//
//  SettingsTableViewCell.swift
//  MathMatch
//
//  Created by Kyle O'Brien on 2016.6.25.
//  Copyright © 2016 Computer Lab. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    // MARK: Methods
    // TODO: Why isn't this one animating?!
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.shouldHighlight(highlighted)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if animated {
            UIView.animateWithDuration(0.3, animations: { self.shouldHighlight(selected) })
        }
        else {
            self.shouldHighlight(selected)
        }
    }
    
    func shouldHighlight(highlight: Bool) {
        if highlight {
            self.backgroundColor = UIColor().mmx_purpleColor(withAlpha: 1.0 / 8.0)
        }
        else {
            self.backgroundColor = UIColor.whiteColor()
        }
    }
}
