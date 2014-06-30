//
//  MMXSettingsViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.6.20.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

@import MessageUI;
#import "KMODecisionView.h"

@interface MMXSettingsViewController : UITableViewController <KMODecisionViewDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

- (IBAction)playerTappedDoneButton:(id)sender;

@end
