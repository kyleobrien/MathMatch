//
//  MMXGameViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.25.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXCardViewController.h"
#import "MMXGameConfiguration.h"

@interface MMXGameViewController : UIViewController <MMXCardViewControllerDelegate>

typedef NS_ENUM(NSUInteger, MMXGameState)
{
    MMXGameStateStart,
    MMXGameStateNoCardsFlipped,
    MMXGameStateOneCardFlipped,
    MMXGameStateTwoCardsFlipped,
    MMXGameStateAnimating,
    MMXGameStateOver
};

@property (nonatomic, strong) MMXGameConfiguration *gameConfiguration;

@property (nonatomic, weak) IBOutlet UIView *equationContainerView;

@property (nonatomic, weak) IBOutlet UILabel *xNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *mathOperatorLabel;
@property (nonatomic, weak) IBOutlet UILabel *yNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *resultNumberLabel;

- (IBAction)playerTappedQuitButton:(id)sender;

@end
