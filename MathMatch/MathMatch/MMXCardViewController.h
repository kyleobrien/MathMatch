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

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIButton *faceDownButton;
@property (nonatomic, weak) IBOutlet UIButton *faceUpButton;

@property (nonatomic, strong) MMXCard *card;

@property (nonatomic, assign) CGPoint tableLocation;
@property (nonatomic, assign) CGSize cardSize;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, assign) BOOL shouldUseSelctionInsteadOfFlip;
@property (nonatomic, assign) BOOL shouldPlaySoundEffect;

@property (nonatomic, weak) id<MMXCardViewControllerDelegate> delegate;

- (instancetype)initWithCardStyle:(MMXCardStyle)cardStyle;

- (IBAction)playerRequestedCardFlip:(id)sender;

- (void)prepareCardForDealingInView:(UIView *)view;
- (void)dealCard;
- (void)flipCardFaceUp;
- (void)flipCardFaceDown;
- (void)selectCard;
- (void)deselectCard;
- (void)removeCardFromTable;

- (void)applyGLow;
- (void)removeGlow;

@end

@protocol MMXCardViewControllerDelegate <NSObject>

@required

- (BOOL)requestedFlipFor:(MMXCardViewController *)cardViewController;
- (void)finishedFlippingFaceDownFor:(MMXCardViewController *)cardViewController;
- (void)finishedFlippingFaceUpFor:(MMXCardViewController *)cardViewController;

@end
