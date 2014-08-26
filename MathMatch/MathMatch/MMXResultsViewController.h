//
//  MMXResultsViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.4.18.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "KMODecisionView.h"
#import "MMXFlatButton.h"

FOUNDATION_EXPORT NSString * const kMMXResultsDidSaveGameNotification;

@interface MMXResultsViewController : UIViewController <KMODecisionViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) MMXGameData *gameData;

@property (nonatomic, assign) NSInteger indexOfNextLesson;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *incorrectMatchesLabel;
@property (nonatomic, weak) IBOutlet UILabel *penaltyMultiplierLabel;
@property (nonatomic, weak) IBOutlet UILabel *penaltyTimeLabel;

@property (nonatomic, weak) IBOutlet UIView *rankContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *rankStar1ImageView;
@property (nonatomic, weak) IBOutlet UIImageView *rankStar2ImageView;
@property (nonatomic, weak) IBOutlet UIImageView *rankStar3ImageView;

@property (nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *bestTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *recordLabel;

@property (nonatomic, weak) IBOutlet MMXFlatButton *menuButton;

- (IBAction)playerTappedMenuButton:(id)sender;

@end
