//
//  MMXPracticeMenuBetaViewController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.24.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

@interface MMXPracticeMenuBetaViewController : UIViewController

FOUNDATION_EXPORT NSString * const kMMXUserDefaultsPracticeTargetNumber;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) MMXGameData *gameData;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *startBarButtonItem;
@property (nonatomic, weak) IBOutlet UILabel *targetNumberLabel;

- (IBAction)numberButtonWasTapped:(id)sender;

@end
