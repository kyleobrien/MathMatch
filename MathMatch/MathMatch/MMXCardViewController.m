//
//  MMXCardViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.2.11.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXCardViewController.h"

@implementation MMXCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.containerView.layer.cornerRadius = 7.0;
    self.containerView.layer.borderColor = [UIColor colorWithRed:(43.0/255.0) green:(43.0/255.0) blue:(43.0/255.0) alpha:1.0].CGColor;
    self.containerView.layer.borderWidth = 2.0;
    self.containerView.clipsToBounds = YES;
    
    self.faceUpButton.layer.cornerRadius = 7.0;
    self.faceUpButton.layer.borderColor = [UIColor colorWithRed:(43.0/255.0) green:(43.0/255.0) blue:(43.0/255.0) alpha:1.0].CGColor;
    self.faceUpButton.layer.borderWidth = 2.0;
    self.faceUpButton.clipsToBounds = YES;
    
    self.faceDownButton.layer.cornerRadius = 7.0;
    self.faceDownButton.layer.borderColor = [UIColor colorWithRed:(43.0/255.0) green:(43.0/255.0) blue:(43.0/255.0) alpha:1.0].CGColor;
    self.faceDownButton.layer.borderWidth = 2.0;
    self.faceDownButton.clipsToBounds = YES;
    
    [self.faceUpButton setTitle:[NSString stringWithFormat:@"%ld", self.card.value]
                       forState:UIControlStateNormal];
}

- (IBAction)playerRequestedCardFlip:(id)sender
{
    if (self.card.isFaceUp)
    {
        // Don't let the player flip it back down.
    }
    else
    {
        if ([self.delegate playerRequestedFlipFor:self])
        {
            [self flipCardFaceUp];
        }
    }
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
                                [self.delegate finishedFlippingFor:self];
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
