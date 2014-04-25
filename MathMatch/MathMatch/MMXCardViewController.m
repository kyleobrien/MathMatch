//
//  MMXCardViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.2.11.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXCardViewController.h"

@interface MMXCardViewController()

@property (nonatomic, strong) UIColor *edgeColor;
@property (nonatomic, strong) UIImage *faceDownImage;

@end

@implementation MMXCardViewController

- (id)initWithCardStyle:(MMXCardStyle)cardStyle
{
    self = [super initWithNibName:@"MMXCardViewController" bundle:[NSBundle mainBundle]];
    if (self)
    {
        if (cardStyle == MMXCardStyle01)
        {
            self.edgeColor = [UIColor mmx_blueColor];
            
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleDots"];
            self.faceDownImage = [self.faceDownImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeTile];
        }
        else
        {
            self.edgeColor = [UIColor mmx_blackColor];
            
            self.faceDownImage = nil;
        }
        
        self.edgeColor = [UIColor mmx_blueColor];
        
        self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleDots"];
        self.faceDownImage = [self.faceDownImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeTile];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.containerView.layer.cornerRadius = 6.0;
    self.containerView.layer.borderColor = self.edgeColor.CGColor;
    self.containerView.layer.borderWidth = 2.0;
    self.containerView.clipsToBounds = YES;
    
    self.faceUpButton.layer.cornerRadius = 6.0;
    self.faceUpButton.layer.borderColor = self.edgeColor.CGColor;
    self.faceUpButton.layer.borderWidth = 2.0;
    self.faceUpButton.clipsToBounds = YES;
    self.faceUpButton.backgroundColor = self.edgeColor;
    
    self.faceDownButton.layer.cornerRadius = 6.0;
    self.faceDownButton.layer.borderColor = self.edgeColor.CGColor;
    self.faceDownButton.layer.borderWidth = 2.0;
    self.faceDownButton.clipsToBounds = YES;
    
    [self.faceUpButton setTitle:[NSString stringWithFormat:@"%ld", self.card.value]
                       forState:UIControlStateNormal];
    
    [self.faceDownButton setBackgroundImage:self.faceDownImage forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    self.faceUpButton.titleLabel.font = [UIFont fontWithName:@"Futura" size:self.fontSize];
    self.faceUpButton.titleLabel.adjustsFontSizeToFitWidth = NO;
}

- (IBAction)playerRequestedCardFlip:(id)sender
{
    if (self.card.isFaceUp)
    {
        // Don't let the player flip it back down.
    }
    else
    {
        if ([self.delegate requestedFlipFor:self])
        {
            [self flipCardFaceUp];
        }
    }
}

- (void)prepareCardForDealingInView:(UIView *)view
{
    CGFloat center = view.frame.size.width / 2.0;
    CGFloat offCenterX = center - self.view.frame.size.width + arc4random_uniform(self.view.frame.size.width);
    self.view.frame = CGRectMake(offCenterX,
                                 self.view.frame.origin.y,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
    
    NSInteger randomAngle = arc4random_uniform(15) + 15;
    if (arc4random_uniform(2) == 0)
    {
        randomAngle = -randomAngle;
    }
    
    self.view.transform = CGAffineTransformMakeRotation(randomAngle * M_PI / 180);
}

- (void)dealCard
{
    self.view.transform = CGAffineTransformIdentity;
    self.view.frame = CGRectMake(self.tableLocation.x,
                                 self.tableLocation.y,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
}

- (void)flipCardFaceDown
{
    if (self.card.isFaceUp)
    {
        [self.card flip];
    }
    
    [UIView transitionWithView:self.containerView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^
                    {
                        self.faceDownButton.hidden = NO;
                        self.faceUpButton.hidden = YES;
                    }
                    completion:^(BOOL finished)
                    {
                        if (finished)
                        {
                            if (self.delegate && [self.delegate respondsToSelector:@selector(finishedFlippingFor:)])
                            {
                                //[self.delegate finishedFlippingFor:self];
                                // TODO: This was causing a loop. Dod we need to know when this happens?
                            }
                        }
                    }];
}

- (void)flipCardFaceUp
{
    if (!self.card.isFaceUp)
    {
        [self.card flip];
        
        [UIView transitionWithView:self.containerView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^
                        {
                            self.faceDownButton.hidden = YES;
                            self.faceUpButton.hidden = NO;
                        }
                        completion:^(BOOL finished)
                        {
                            if (finished)
                            {
                                if (self.delegate && [self.delegate respondsToSelector:@selector(finishedFlippingFor:)])
                                {
                                    [self.delegate finishedFlippingFor:self];
                                }
                            }
                        }];
    }
}

- (void)removeCardFromTable
{
    if (self.card.isFaceUp)
    {
        self.view.hidden = YES;
    }
}

@end
