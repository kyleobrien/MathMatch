//
//  SettingsViewController.swift
//  MathMatch
//
//  Created by Kyle O'Brien on 2016.6.27.
//  Copyright © 2016 Computer Lab. All rights reserved.
//

import UIKit
import MessageUI


class SettingsViewController : UITableViewController {
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor().mmx_whiteColor(withAlpha: 1.0)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Doesn't deselect on swipe back (bug?) so doing it manually.
        if let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
        }
        
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MMXShowCardStylesSegue" {
            MMXAudioManager.sharedManager().playSoundEffect(.TapBackward)
        }
        else if segue.identifier == "MMXShowAboutSegue" {
            MMXAudioManager.sharedManager().playSoundEffect(.TapForward)
        }
    }
    
    @IBAction func playerTappedDoneButton(sender: UIButton) {
        MMXAudioManager.sharedManager().playSoundEffect(.TapNeutral)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if indexPath.section == 0 {
            if let volumeCell = cell as? VolumeCell {
                volumeCell.volumeSettingType = .Track
                volumeCell.configureSliderWithUserDefaults()
            }
        }
        else if indexPath.section == 1 {
            if let volumeCell = cell as? VolumeCell {
                volumeCell.volumeSettingType = .SFX
                volumeCell.configureSliderWithUserDefaults()
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        MMXAudioManager.sharedManager().playSoundEffect(.TapNeutral)
        
        if (indexPath.section == 2) && (indexPath.row == 1) {
            let message = NSLocalizedString("You're about to reset all progress, including stars, best times and completed game stats. Are you sure? You cannot undo this action.", comment: "");
            let cancel = NSLocalizedString("Cancel", comment: "Cancel")
            let confirm = NSLocalizedString("Yes, Reset", comment: "User confirmation that resets all statistics.")
            
            let decisionView = KMODecisionView(message: message, delegate: self, cancelButtonTitle: cancel, otherButtonTitles: [confirm])
            decisionView.destructiveButtonIndex = 1
            decisionView.destructiveColor = UIColor().mmx_redColor(withAlpha: 1.0)
            decisionView.fontName = "Futura-Medium"
            
            if UI_USER_INTERFACE_IDIOM() == .Pad {
                decisionView.showInViewController(self, andDimBackgroundWithPercent: 0.50)
            }
            else {
                [decisionView.showInViewController(self.navigationController, andDimBackgroundWithPercent: 0.50)]
            }
        }
        else if (indexPath.section == 3) && (indexPath.row == 0) {
            if MFMailComposeViewController.canSendMail() {
                let mailComposeViewController = MFMailComposeViewController()
                mailComposeViewController.setSubject(NSLocalizedString("Math Mathch - Feedback", comment: "Email title."))
                mailComposeViewController.setToRecipients(["support@connectrelatecreate.com"])
                mailComposeViewController.setMessageBody("", isHTML: false)
                
                mailComposeViewController.navigationBar.tintColor = UIColor().mmx_purpleColor(withAlpha: 1.0)
                mailComposeViewController.mailComposeDelegate = self
                
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            }
            else {
                let message = NSLocalizedString("Can't send because no email account is configured on this device.", comment: "Device does not have an email account configured.");
                
                let decisionView = KMODecisionView(message: message, delegate: self, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"), otherButtonTitles: nil)
                decisionView.showInViewController(self, andDimBackgroundWithPercent: 0.50)
            }
        }
        else if (indexPath.section == 3) && (indexPath.row == 1) {
            if let url = NSURL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=896517401&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        else if (indexPath.section == 3) && (indexPath.row == 2) {
            let message = NSLocalizedString("Check out Math Match, a game of concentration, memory, and arithmetic available on the App Store!", comment: "Friendly, sharing this game with someone else type of message.")
            
            var activityItems: [AnyObject] = [message]
            
            if let appStoreURL = NSURL(string: "http://appstore.com/mathmatchagameofconcentrationmemoryandarithmetic") {
                activityItems.append(appStoreURL)
            }
            
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        else if (indexPath.section == 4) && (indexPath.row == 0) {
            if let url = NSURL(string: "http://connectrelatecreate.com/mathmatch/") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 64.0
        }
        
        return 44.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: 21.0))
        
        let y = 15.0 + (section == 0 ? 20.0 : 0.0)
        let width = Double(view.bounds.size.width) - 15.0
        
        let label = UILabel(frame: CGRect(x: 15.0, y: y, width: width, height: 21.0))
        label.textColor = UIColor().mmx_purpleColor(withAlpha: 1.0)
        if let font = UIFont(name: "AvenirNext-DemiBold", size: 15.0) {
            label.font = font
        }
        
        if section == 0 {
            label.text = NSLocalizedString("Music Volume", comment: "Music volume for the game.");
        }
        else if section == 1 {
            label.text = NSLocalizedString("Sound Effects Volume", comment: "Sound effect volume for the game.");
        }
        else if section == 2 {
            label.text = NSLocalizedString("Options", comment: "Options for the game.");
        }
        else if section == 3 {
            label.text = NSLocalizedString("More", comment: "Sharing and communication actions for the game.");
        }
        else if section == 4 {
            label.text = NSLocalizedString("About", comment: "About the game.");
        }
        
        view.addSubview(label)
        
        return view
    }
    
    // MARK: Helpers
    
    func deleteAllEntities() {
        if let navController = self.navigationController as? MMXNavigationController {
            let dataFetchRequest = NSFetchRequest(entityName: "MMXGameData")
            dataFetchRequest.includesPropertyValues = false
            
            do {
                let allGameDataEntities = try navController.managedObjectContext.executeFetchRequest(dataFetchRequest)
                
                for gameData in allGameDataEntities {
                    // TODO: this seems janky...
                    navController.managedObjectContext.deleteObject(gameData as! NSManagedObject)
                }
            } catch _ as NSError {}
            
            do {
                try navController.managedObjectContext.save()
            } catch _ as NSError {}
        }
    }
}

extension SettingsViewController : MFMailComposeViewControllerDelegate {

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if result == MFMailComposeResultFailed {
            let message = NSLocalizedString("Couldn't send the email. Try again later.", comment: "Error message when sending email fails.")
            
            let decisionView = KMODecisionView(message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"), otherButtonTitles: nil)
            
            decisionView.showInViewController(self, andDimBackgroundWithPercent: 0.50)
        }
    }
}

extension SettingsViewController : KMODecisionViewDelegate {
    func decisionView(decisionView: KMODecisionView!, tappedButtonAtIndex buttonIndex: Int) {
        MMXAudioManager.sharedManager().playSoundEffect(.TapNeutral)
        
        if buttonIndex == 1 {
            self.deleteAllEntities()
        }
    }
}
