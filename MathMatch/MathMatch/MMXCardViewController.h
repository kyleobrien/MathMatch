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

@property (nonatomic, weak) id<MMXCardViewControllerDelegate> delegate;

- (id)initWithCardStyle:(MMXCardStyle)cardStyle;

- (IBAction)playerRequestedCardFlip:(id)sender;

- (void)flipCardFaceUp;
- (void)flipCardFaceDown;
- (void)removeCardFromTable;

@end

@protocol MMXCardViewControllerDelegate <NSObject>

@required

- (BOOL)playerRequestedFlipFor:(MMXCardViewController *)cardViewController;
- (void)finishedFlippingFor:(MMXCardViewController *)cardViewController;

@end
