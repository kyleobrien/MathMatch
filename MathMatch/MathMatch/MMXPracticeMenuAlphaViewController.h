//
//  MMXPracticeMenuViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.16.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

@interface MMXPracticeMenuAlphaViewController : UIViewController

FOUNDATION_EXPORT NSString * const kMMXUserDefaultsPracticeNumberOfCards;
FOUNDATION_EXPORT NSString * const kMMXUserDefaultsPracticeArithmeticType;
FOUNDATION_EXPORT NSString * const kMMXUserDefaultsPracticeStartingPosition;
FOUNDATION_EXPORT NSString * const kMMXUserDefaultsPracticeMusic;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) IBOutlet UIButton *number8Button;
@property (nonatomic, weak) IBOutlet UIButton *number12Button;
@property (nonatomic, weak) IBOutlet UIButton *number16Button;
@property (nonatomic, weak) IBOutlet UIButton *number20Button;
@property (nonatomic, weak) IBOutlet UIButton *number24Button;

@property (nonatomic, weak) IBOutlet UIButton *arithmeticAdditionButton;
@property (nonatomic, weak) IBOutlet UIButton *arithmeticSubtractionButton;
@property (nonatomic, weak) IBOutlet UIButton *arithmeticMultiplicationButton;
@property (nonatomic, weak) IBOutlet UIButton *arithmeticDivisionButton;

@property (nonatomic, weak) IBOutlet UIButton *startingPositionFaceUpButton;
@property (nonatomic, weak) IBOutlet UIButton *startingPositionMemorizeButton;
@property (nonatomic, weak) IBOutlet UIButton *startingPositionFaceDownButton;

@property (nonatomic, weak) IBOutlet UIButton *music1Button;
@property (nonatomic, weak) IBOutlet UIButton *music2Button;
@property (nonatomic, weak) IBOutlet UIButton *music3Button;
@property (nonatomic, weak) IBOutlet UIButton *musicOffButton;

- (IBAction)numberButtonWasTapped:(id)sender;
- (IBAction)arithmeticButtonWasTapped:(id)sender;
- (IBAction)memoryButtonWasTapped:(id)sender;
- (IBAction)musicButtonWasTapped:(id)sender;

- (IBAction)unwindToPracticeConfiguration:(UIStoryboardSegue *)unwindSegue;

@end
