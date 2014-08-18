//
//  MMXHowToPlayDelegate.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.7.29.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXGameViewController.h"

typedef NS_ENUM(NSUInteger, MMXTutorialStep)
{
    MMXTutorialStep01,
    MMXTutorialStep02,
    MMXTutorialStep03,
    MMXTutorialStep04,
    MMXTutorialStep05,
    MMXTutorialStep06,
    MMXTutorialStep07,
    MMXTutorialStep08,
    MMXTutorialStep09,
    MMXTutorialStep10,
    MMXTutorialStep11,
    MMXTutorialStep12,
    MMXTutorialStep13,
    MMXTutorialStep14,
    MMXTutorialStepComplete
};

@interface MMXHowToPlayDelegate : NSObject <KMODecisionViewDelegate, MMXGameDelegate>

@property (nonatomic, strong) NSTimer *suggestionTimer;

@end
