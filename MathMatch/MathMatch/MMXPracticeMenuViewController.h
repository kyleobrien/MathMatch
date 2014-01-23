//
//  MMXPracticeMenuViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.16.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

@interface MMXPracticeMenuViewController : UIViewController

@property (weak) IBOutlet UIButton *number4Button;
@property (weak) IBOutlet UIButton *number8Button;
@property (weak) IBOutlet UIButton *number12Button;
@property (weak) IBOutlet UIButton *number16Button;
@property (weak) IBOutlet UIButton *number20Button;

@property (weak) IBOutlet UIButton *arithmeticAdditionButton;
@property (weak) IBOutlet UIButton *arithmeticSubtractionButton;
@property (weak) IBOutlet UIButton *arithmeticMultiplicationButton;
@property (weak) IBOutlet UIButton *arithmeticDivisionButton;

@property (weak) IBOutlet UIButton *memorySlowButton;
@property (weak) IBOutlet UIButton *memoryFastButton;
@property (weak) IBOutlet UIButton *memoryNoneButton;

@property (weak) IBOutlet UIButton *music1Button;
@property (weak) IBOutlet UIButton *music2Button;
@property (weak) IBOutlet UIButton *music3Button;
@property (weak) IBOutlet UIButton *musicOffButton;

- (IBAction)numberButtonWasTapped:(id)sender;
- (IBAction)arithmeticButtonWasTapped:(id)sender;
- (IBAction)memoryButtonWasTapped:(id)sender;
- (IBAction)musicButtonWasTapped:(id)sender;

@end
