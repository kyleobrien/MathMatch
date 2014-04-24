//
//  MMXGameViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.25.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "KMODecisionView.h"
#import "MMXCardViewController.h"

@interface MMXGameViewController : UIViewController <MMXCardViewControllerDelegate, KMODecisionViewDelegate>

typedef NS_ENUM(NSUInteger, MMXGameState)
{
    MMXGameStatePreGame,
    MMXGameStateStart,
    MMXGameStateNoCardsFlipped,
    MMXGameStateOneCardFlipped,
    MMXGameStateTwoCardsFlipped,
    MMXGameStateAnimating,
    MMXGameStateOver
};

@property (nonatomic, strong) MMXGameConfiguration *gameConfiguration;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *pauseBarButtonItem;

@property (nonatomic, weak) IBOutlet UIView *equationContainerView;
@property (nonatomic, weak) IBOutlet UIView *equationCorrectnessView;

@property (nonatomic, weak) IBOutlet UILabel *xNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *yNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *zNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *aFormulaLabel;
@property (nonatomic, weak) IBOutlet UILabel *bFormulaLabel;

- (IBAction)playerTappedPauseButton:(id)sender;

@end
