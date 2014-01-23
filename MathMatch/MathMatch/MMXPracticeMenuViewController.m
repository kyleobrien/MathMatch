//
//  MMXPracticeMenuViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.16.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXPracticeMenuViewController.h"

@interface MMXPracticeMenuViewController ()

@end

@implementation MMXPracticeMenuViewController

NSString * const kMMXUserDefaultsPracticeNumberOfCards = @"MMXUserDefaultsPracticeNumberOfCards";
NSString * const kMMXUserDefaultsPracticeArithmeticType = @"MMXUserDefaultsPracticeArithmeticType";
NSString * const kMMXUserDefaultsPracticeMemorySpeed = @"MMXUserDefaultsPracticeMemorySpeed";
NSString * const kMMXUserDefaultsPracticeMusic = @"MMXUserDefaultsPracticeMusic";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //[self.number4Button mmx_makeButtonFlatWithColor:[UIColor redColor]];
     /*
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
      */
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0.0 / 255.0)
                                                                           green:(255.0 / 255.0)
                                                                            blue:(0.0 / 255.0)
                                                                           alpha:1.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(43.0 / 255.0)
                                                                           green:(43.0 / 255.0)
                                                                            blue:(43.0 / 255.0)
                                                                           alpha:1.0];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)numberButtonWasTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    self.number4Button.selected = (button == self.number4Button);
    self.number8Button.selected = (button == self.number8Button);
    self.number12Button.selected = (button == self.number12Button);
    self.number16Button.selected = (button == self.number16Button);
    self.number20Button.selected = (button == self.number20Button);
}

- (IBAction)arithmeticButtonWasTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    self.arithmeticAdditionButton.selected = (button == self.arithmeticAdditionButton);
    self.arithmeticSubtractionButton.selected = (button == self.arithmeticSubtractionButton);
    self.arithmeticMultiplicationButton.selected = (button == self.arithmeticMultiplicationButton);
    self.arithmeticDivisionButton.selected = (button == self.arithmeticDivisionButton);
}

- (IBAction)memoryButtonWasTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    self.memorySlowButton.selected = (button == self.memorySlowButton);
    self.memoryFastButton.selected = (button == self.memoryFastButton);
    self.memoryNoneButton.selected = (button == self.memoryNoneButton);
}

- (IBAction)musicButtonWasTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    self.music1Button.selected = (button == self.music1Button);
    self.music2Button.selected = (button == self.music2Button);
    self.music3Button.selected = (button == self.music3Button);
    self.musicOffButton.selected = (button == self.musicOffButton);
}

- (void)loadAndSetUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger numberOfCards = [userDefaults integerForKey:kMMXUserDefaultsPracticeNumberOfCards];
    
}

@end
