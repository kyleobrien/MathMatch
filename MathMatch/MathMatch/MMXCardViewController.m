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
        if (cardStyle == MMXCardStyleBeach)
        {
            self.edgeColor = [UIColor colorWithRed:(105.0 / 255.0)
                                             green:(210.0 / 255.0)
                                              blue:(231.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleBeach"];
        }
        else if (cardStyle == MMXCardStyleCheckers)
        {
            self.edgeColor = [UIColor colorWithRed:(63.0 / 255.0)
                                             green:(44.0 / 255.0)
                                              blue:(38.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleCheckers"];
        }
        else if (cardStyle == MMXCardStyleCitrus)
        {
            self.edgeColor = [UIColor colorWithRed:(245.0 / 255.0)
                                             green:(105.0 / 255.0)
                                              blue:(145.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleCitrus"];
        }
        else if (cardStyle == MMXCardStyleCupcake)
        {
            self.edgeColor = [UIColor colorWithRed:(167.0 / 255.0)
                                             green:(156.0 / 255.0)
                                              blue:(142.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleCupcake"];
        }
        else if (cardStyle == MMXCardStyleMoon)
        {
            self.edgeColor = [UIColor colorWithRed:(81.0 / 255.0)
                                             green:(43.0 / 255.0)
                                              blue:(82.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleMoon"];
        }
        else if (cardStyle == MMXCardStyleOverlook)
        {
            self.edgeColor = [UIColor colorWithRed:(138.0 / 255.0)
                                             green:(59.0 / 255.0)
                                              blue:(0.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleOverlook"];
        }
        else if (cardStyle == MMXCardStyleSushi)
        {
            self.edgeColor = [UIColor colorWithRed:(60.0 / 255.0)
                                             green:(59.0 / 255.0)
                                              blue:(39.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleSushi"];
        }
        else if (cardStyle == MMXCardStyleThatch)
        {
            self.edgeColor = [UIColor colorWithRed:(82.0 / 255.0)
                                             green:(70.0 / 255.0)
                                              blue:(86.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleThatch"];
        }
        else if (cardStyle == MMXCardStyleEmerald)
        {
            self.edgeColor = [UIColor colorWithRed:(2.0 / 255.0)
                                             green:(143.0 / 255.0)
                                              blue:(118.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleEmerald"];
        }
        else
        {
            self.edgeColor = [UIColor mmx_blackColor];
            
            self.faceDownImage = nil;
        }
        
        // TODO: For testing new backgrounds only! Delete!
        /*
        self.edgeColor = [UIColor colorWithRed:(60.0 / 255.0)
                                         green:(59.0 / 255.0)
                                          blue:(39.0 / 255.0)
                                         alpha:1.0];
        self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleSushi"];
         */
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
    
    [self.faceUpButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.card.value]
                       forState:UIControlStateNormal];
    
    [self.faceDownButton setBackgroundColor:[UIColor colorWithPatternImage:self.faceDownImage]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    self.faceUpButton.titleLabel.font = [UIFont fontWithName:@"Futura" size:self.fontSize];
    self.faceUpButton.titleLabel.adjustsFontSizeToFitWidth = NO;
}

#pragma mark - Player Action

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

#pragma mark - Helpers

- (void)prepareCardForDealingInView:(UIView *)view
{
    CGFloat center = view.frame.size.width / 2.0;
    CGFloat offCenterX = center - self.view.frame.size.width + arc4random_uniform(self.view.frame.size.width);
    
    NSInteger randomAngle = arc4random_uniform(15) + 15;
    if (arc4random_uniform(2) == 0)
    {
        randomAngle = -randomAngle;
    }
    
    self.view.frame = CGRectMake(offCenterX,
                                 self.view.frame.origin.y,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
    
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
                            if (self.delegate && [self.delegate respondsToSelector:@selector(finishedFlippingFaceDownFor:)])
                            {
                                [self.delegate finishedFlippingFaceDownFor:self];
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
                                if (self.delegate && [self.delegate respondsToSelector:@selector(finishedFlippingFaceUpFor:)])
                                {
                                    [self.delegate finishedFlippingFaceUpFor:self];
                                }
                            }
                        }];
    }
}

- (void)removeCardFromTable
{
    [self.view removeFromSuperview];
}
    
@end
