//
//  AboutViewController.swift
//  MathMatch
//
//  Created by Kyle O'Brien on 2016.03.09.
//  Copyright © 2016 Kyle O'Brien. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let shortVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = String.localizedStringWithFormat(NSLocalizedString("Version %@", comment: "Current version of Math Match."), shortVersion)
            self.versionLabel.accessibilityLabel = self.versionLabel.text!.stringByReplacingOccurrencesOfString(".", withString: NSLocalizedString(" dot ", comment: "Dot between major and minor version."))
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController() {
            MMXAudioManager.sharedManager().playSoundEffect(.TapBackward)
        }
    }
}
