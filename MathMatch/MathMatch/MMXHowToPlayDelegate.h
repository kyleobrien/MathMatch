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
    MMXTutorialStepComplete
};

@interface MMXHowToPlayDelegate : NSObject <KMODecisionViewDelegate, MMXGameDelegate>

@end
