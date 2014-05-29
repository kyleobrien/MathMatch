//
//  MMXResultsViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.4.18.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "KMODecisionView.h"

@interface MMXResultsViewController : UIViewController <KMODecisionViewDelegate>

@property (nonatomic, strong) MMXGameData *gameConfiguration;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *incorrectMatchesLabel;
@property (nonatomic, weak) IBOutlet UILabel *penaltyMultiplierLabel;
@property (nonatomic, weak) IBOutlet UILabel *penaltyTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *bestTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *recordLabel;

- (IBAction)playerTappedMenuButton:(id)sender;

@end
