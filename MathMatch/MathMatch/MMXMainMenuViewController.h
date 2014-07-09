//
//  MMXMainMenuViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.16.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXCardViewController.h"

@interface MMXMainMenuViewController : UIViewController <MMXCardViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *settingsButton;

@property (nonatomic, weak) IBOutlet UIButton *classesButton;
@property (nonatomic, weak) IBOutlet UIButton *practiceButton;
@property (nonatomic, weak) IBOutlet UIButton *howToPlayButton;
@property (nonatomic, weak) IBOutlet UIButton *reportCardButton;

@property (nonatomic, weak) IBOutlet UIView *classesCardContainerView;
@property (nonatomic, weak) IBOutlet UIView *practiceCardContainerView;
@property (nonatomic, weak) IBOutlet UIView *howToPlayCardContainerView;
@property (nonatomic, weak) IBOutlet UIView *reportCardCardContainerView;

- (IBAction)playerTappedClassesButton:(id)sender;
- (IBAction)playerTappedPracticeButton:(id)sender;
- (IBAction)playerTappedHowToPlayButton:(id)sender;
- (IBAction)playerTappedReportCardButton:(id)sender;

@end
