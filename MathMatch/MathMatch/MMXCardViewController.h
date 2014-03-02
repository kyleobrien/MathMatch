//
//  MMXCardViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.2.11.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXCard.h"

@protocol MMXCardViewControllerDelegate;

@interface MMXCardViewController : UIViewController

typedef NS_ENUM(NSUInteger, MMXCardColor)
{
    MMXCardColorBlue,
    MMXCardColorGreen,
    MMXCardColorRed,
    MMXCardColorOrange,
    MMXCardColorPurple
};

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIButton *faceDownButton;
@property (nonatomic, weak) IBOutlet UIButton *faceUpButton;

@property (nonatomic, strong) MMXCard *card;

@property (nonatomic, weak) id<MMXCardViewControllerDelegate> delegate;

- (IBAction)playerRequestedCardFlip:(id)sender;

- (void)flipCardFaceDown;
- (void)removeCardFromTable;

@end

@protocol MMXCardViewControllerDelegate <NSObject>

@required

- (BOOL)playerRequestedFlipFor:(MMXCardViewController *)cardViewController;
- (void)finishedFlippingFor:(MMXCardViewController *)cardViewController;

@end