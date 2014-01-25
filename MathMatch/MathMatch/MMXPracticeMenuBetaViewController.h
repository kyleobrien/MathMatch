//
//  MMXPracticeMenuBetaViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.24.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXGameConfiguration.h"

@interface MMXPracticeMenuBetaViewController : UIViewController

@property (strong) MMXGameConfiguration *gameConfiguration;

@property (weak) IBOutlet UIBarButtonItem *startBarButtonItem;
@property (weak) IBOutlet UILabel *targetNumberLabel;

- (IBAction)numberButtonWasTapped:(id)sender;

@end
