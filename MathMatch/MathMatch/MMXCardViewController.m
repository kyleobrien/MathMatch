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

- (instancetype)initWithCardStyle:(MMXCardStyle)cardStyle
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
        else if (cardStyle == MMXCardStyleEmerald)
        {
            self.edgeColor = [UIColor colorWithRed:(2.0 / 255.0)
                                             green:(143.0 / 255.0)
                                              blue:(118.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleEmerald"];
        }
        else if (cardStyle == MMXCardStyleGrass)
        {
            self.edgeColor = [UIColor colorWithRed:(174.0 / 255.0)
                                             green:(226.0 / 255.0)
                                              blue:(57.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleGrass"];
        }
        else if (cardStyle == MMXCardStyleHoney)
        {
            self.edgeColor = [UIColor colorWithRed:(119.0 / 255.0)
                                             green:(79.0 / 255.0)
                                              blue:(56.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleHoney"];
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
        else if (cardStyle == MMXCardStyleStars)
        {
            self.edgeColor = [UIColor colorWithRed:(49.0 / 255.0)
                                             green:(54.0 / 255.0)
                                              blue:(64.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleStars"];
        }
        else if (cardStyle == MMXCardStyleSteel)
        {
            self.edgeColor = [UIColor colorWithRed:(188.0 / 255.0)
                                             green:(188.0 / 255.0)
                                              blue:(188.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleSteel"];
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
        else if (cardStyle == MMXCardStyleVelvet)
        {
            self.edgeColor = [UIColor colorWithRed:(73.0 / 255.0)
                                             green:(10.0 / 255.0)
                                              blue:(61.0 / 255.0)
                                             alpha:1.0];
            self.faceDownImage = [UIImage imageNamed:@"MMXCardStyleVelvet"];
        }
        else
        {
            self.edgeColor = [UIColor mmx_blackColor];
            
            self.faceDownImage = nil;
        }
        
        self.shouldPlaySoundEffect = YES;
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
    
    if (self.faceDownImage)
    {
        [self.faceDownButton setBackgroundColor:[UIColor colorWithPatternImage:self.faceDownImage]];
    }
    else
    {
        [self.faceDownButton setBackgroundColor:[UIColor mmx_blackColor]];
    }
    
    self.faceUpButton.contentEdgeInsets = UIEdgeInsetsMake(4.0, 0.0, 0.0, 0.0);
    
    [self.faceUpButton setTitleColor:self.edgeColor forState:UIControlStateSelected];
    
    self.faceDownButton.accessibilityLabel = NSLocalizedString(@"Face Down Card", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    self.faceUpButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:self.fontSize];
    self.faceUpButton.titleLabel.minimumScaleFactor = 0.75;
    self.faceUpButton.titleLabel.adjustsFontSizeToFitWidth = YES;
}

#pragma mark - Player Action

- (IBAction)playerRequestedCardFlip:(id)sender
{
    if (self.shouldUseSelctionInsteadOfFlip)
    {
        if (!self.card.selected)
        {
            if ([self.delegate requestedFlipFor:self])
            {
                [self selectCard];
            }
        }
    }
    else
    {
        if (!self.card.isFaceUp)
        {
            if ([self.delegate requestedFlipFor:self])
            {
                [self flipCardFaceUp];
            }
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

- (void)selectCard
{
    self.card.selected = YES;
    
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectDeal;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    self.faceUpButton.selected = YES;
    [self.faceUpButton setBackgroundColor:[UIColor whiteColor]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishedFlippingFaceUpFor:)])
    {
        [self.delegate finishedFlippingFaceUpFor:self];
    }
}

- (void)deselectCard
{
    [UIView animateWithDuration:0.20
                     animations:^
                     {
                         self.faceUpButton.selected = NO;
                         [self.faceUpButton setBackgroundColor:self.edgeColor];
                     }
                     completion:^(BOOL finished)
                     {
                         if (finished)
                         {
                             self.card.selected = NO;
                             
                             if (self.delegate && [self.delegate respondsToSelector:@selector(finishedFlippingFaceDownFor:)])
                             {
                                 [self.delegate finishedFlippingFaceDownFor:self];
                             }
                         }
                     }];
}

- (void)flipCardFaceDown
{
    if (self.card.isFaceUp)
    {
        [self.card flip];
    }
    
    [UIView transitionWithView:self.containerView
                      duration:0.20
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
        
        if (self.shouldPlaySoundEffect)
        {
            [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectDeal;
            [[MMXAudioManager sharedManager] playSoundEffect];
        }
        
        [UIView transitionWithView:self.containerView
                          duration:0.20
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

- (void)applyGLow
{    
    CGFloat red, green, blue, alpha;
    [[UIColor mmx_greenColor] getRed:&red green:&green blue:&blue alpha:&alpha];
    
    UIColor *alphaOrange = [UIColor colorWithRed:red green:green blue:blue alpha:0.5];
    
    CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    color.autoreverses = YES;
    color.repeatCount = HUGE_VALF;
    color.duration = 0.75;
    color.fromValue = (id)alphaOrange.CGColor;
    color.toValue = (id)[UIColor mmx_greenColor].CGColor;
    self.containerView.layer.backgroundColor = [UIColor mmx_greenColor].CGColor;
    self.containerView.layer.borderWidth = 4.0;
    
    [self.containerView.layer addAnimation:color forKey:@"glowColor"];
}

- (void)removeGlow
{
    [self.containerView.layer removeAnimationForKey:@"glowColor"];
    
    self.containerView.layer.borderWidth = 2.0;
}

@end
