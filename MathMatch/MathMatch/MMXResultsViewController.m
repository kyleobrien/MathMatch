//
//  MMXResultsViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.4.18.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXLessonsViewController.h"
#import "MMXResultsViewController.h"
#import "MMXTimeIntervalFormatter.h"
#import "MMXTopScore.h"

@interface MMXResultsViewController ()

@property (nonatomic, strong) CAEmitterLayer *rankStar1EmitterLayer;
@property (nonatomic, strong) CAEmitterLayer *rankStar2EmitterLayer;
@property (nonatomic, strong) CAEmitterLayer *rankStar3EmitterLayer;

@property (nonatomic, assign) BOOL shouldShowNextLesson;

@end

NSString * const kMMXResultsDidSaveGameNotification = @"MMXResultsDidSaveGameNotification";

@implementation MMXResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *temp = [MMXTimeIntervalFormatter stringWithInterval:self.gameData.completionTime.doubleValue
                                                   forFormatType:MMXTimeIntervalFormatTypeLong];
    self.timeLabel.text = temp[0];
    self.timeLabel.accessibilityLabel = temp[1];
    
    self.incorrectMatchesLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gameData.incorrectMatches.integerValue];
    
    self.penaltyMultiplierLabel.text = [NSString stringWithFormat:@"x %2.1fs", self.gameData.penaltyMultiplier.floatValue];
    self.penaltyMultiplierLabel.accessibilityLabel = [NSString stringWithFormat:NSLocalizedString(@"times %2.1f seconds", nil), self.gameData.penaltyMultiplier.floatValue];
    
    NSTimeInterval penaltyTime = self.gameData.incorrectMatches.integerValue * self.gameData.penaltyMultiplier.floatValue;
    self.gameData.completionTimeWithPenalty = [NSNumber numberWithDouble:penaltyTime];
    
    temp = [MMXTimeIntervalFormatter stringWithInterval:penaltyTime
                                          forFormatType:MMXTimeIntervalFormatTypeLong];
    self.penaltyTimeLabel.text = temp[0];
    self.penaltyTimeLabel.accessibilityLabel = temp[1];
    
    self.gameData.completionTimeWithPenalty = @(self.gameData.completionTime.doubleValue + penaltyTime);
    
    temp = [MMXTimeIntervalFormatter stringWithInterval:self.gameData.completionTimeWithPenalty.floatValue
                                          forFormatType:MMXTimeIntervalFormatTypeLong];
    self.totalTimeLabel.text = temp[0];
    self.totalTimeLabel.accessibilityLabel = temp[1];
    
    if (self.gameData.gameType == MMXGameTypeCourse)
    {
        if (self.gameData.completionTimeWithPenalty.floatValue < self.gameData.threeStarTime.floatValue)
        {
            self.gameData.starRating = @3;
        }
        else if (self.gameData.completionTimeWithPenalty.floatValue < self.gameData.twoStarTime.floatValue)
        {
            self.gameData.starRating = @2;
        }
        else
        {
            self.gameData.starRating = @1;
        }
        
        NSString *pluralStars = NSLocalizedString(@"Stars", nil);
        if (self.gameData.starRating.integerValue == 1)
        {
            pluralStars = NSLocalizedString(@"Star", nil);
        }
        self.rankContainerView.accessibilityLabel = [NSString stringWithFormat:NSLocalizedString(@"%ld %@", nil),
                                                     (long)self.gameData.starRating.integerValue, pluralStars];
    }
    
    if (self.gameData.gameType == MMXGameTypeCourse)
    {
        // Pull out top score for this lesson.
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MMXTopScore"
                                                             inManagedObjectContext:self.managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entityDescription];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lessonID == %@", self.gameData.lessonID];
        [fetchRequest setPredicate:predicate];
        
        NSError *fetchError = nil;
        NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
        
        MMXTopScore *topScoreForLesson;
        if (fetchedResults.count > 0)
        {
            topScoreForLesson = fetchedResults[0];
            
            temp = [MMXTimeIntervalFormatter stringWithInterval:topScoreForLesson.time.floatValue
                                                  forFormatType:MMXTimeIntervalFormatTypeLong];
            self.bestTimeLabel.text = temp[0];
            self.bestTimeLabel.accessibilityLabel = temp[1];
            
            if (floorf(self.gameData.completionTimeWithPenalty.floatValue) < floorf(topScoreForLesson.time.floatValue))
            {
                topScoreForLesson.lessonID = [self.gameData.lessonID copy];
                topScoreForLesson.time = [self.gameData.completionTimeWithPenalty copy];
                topScoreForLesson.stars = [self.gameData.starRating copy];
                topScoreForLesson.gameData = self.gameData;
                
                // TODO: Play kid horray sound!
                
                self.recordLabel.hidden = NO;
                [self rainbowizeNewRecordLabel];
                
                [UIView animateWithDuration:0.75
                                      delay:0.0
                                    options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                                 animations:^
                                 {
                                     self.recordLabel.transform = CGAffineTransformMakeScale(1.25, 1.25);
                                 }
                                 completion:nil];
            }
        }
        else
        {
            topScoreForLesson = [NSEntityDescription insertNewObjectForEntityForName:@"MMXTopScore"
                                                              inManagedObjectContext:self.managedObjectContext];
            
            topScoreForLesson.lessonID = self.gameData.lessonID;
            topScoreForLesson.time = self.gameData.completionTimeWithPenalty;
            topScoreForLesson.stars = self.gameData.starRating;
            topScoreForLesson.gameData = self.gameData;
            
            self.bestTimeLabel.text = NSLocalizedString(@"---", nil);
            self.bestTimeLabel.accessibilityLabel = NSLocalizedString(@"Not Applicable", nil);
        }
    }
    else
    {
        self.bestTimeLabel.text = NSLocalizedString(@"---", nil);
        self.bestTimeLabel.accessibilityLabel = NSLocalizedString(@"Not Applicable", nil);
    }
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    if (!error)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kMMXResultsDidSaveGameNotification object:nil];
    }
    
    if (self.gameData.gameType == MMXGameTypeCourse)
    {
        [self.menuButton changeButtonToColor:[UIColor mmx_blueColor]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.66 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
        {
            [self beginStarAnimationForStar:1];
        });
    }
    else
    {
        self.rankContainerView.hidden = YES;
    }
    
    // Don't want the particle effects to appear if the user pops the navigation controller while animation is ongoing.
    self.view.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MMXUnwindToLessonsSegue"] && self.shouldShowNextLesson)
    {
        MMXLessonsViewController *lessonsViewController = (MMXLessonsViewController *)segue.destinationViewController;
        lessonsViewController.indexOfNextLesson = self.indexOfNextLesson;
    }
}

#pragma mark - Player action

- (IBAction)playerTappedMenuButton:(id)sender
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    NSString *secondOption;
    if (self.gameData.gameType == MMXGameTypePractice)
    {
        secondOption = NSLocalizedString(@"Change Settings", nil);
    }
    else
    {
        secondOption = NSLocalizedString(@"Show Lessons", nil);
    }
    
    NSString *message = NSLocalizedString(@"The game is over. What would you like to do?", nil);
    NSMutableArray *otherButtonTitles = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"Main Menu", nil),
                                                                         NSLocalizedString(@"Try Again", nil),
                                                                         secondOption]];
    
    if ((self.gameData.gameType == MMXGameTypeCourse) && (self.indexOfNextLesson > 0))
    {
        [otherButtonTitles addObject:NSLocalizedString(@"Next Lesson", nil)];
    }
    
    KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:message
                                                                    delegate:self
                                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                           otherButtonTitles:otherButtonTitles];
    decisionView.fontName = @"Futura-Medium";
    
    [decisionView showInViewController:self.navigationController andDimBackgroundWithPercent:0.50];
}

#pragma mark - Helpers

- (void)beginStarAnimationForStar:(NSInteger)starNumber
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectWhoosh;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    CGAffineTransform scaleStart = CGAffineTransformMakeScale(25.0, 25.0);
    CGAffineTransform rotateStart = CGAffineTransformMakeRotation(-M_PI_4);
    CGAffineTransform scaleAndRotateStart = CGAffineTransformConcat(scaleStart, rotateStart);
    
    if (starNumber == 1)
    {
        self.rankStar1ImageView.transform = scaleAndRotateStart;
        self.rankStar1ImageView.hidden = NO;
    }
    else if (starNumber == 2)
    {
        self.rankStar2ImageView.transform = scaleAndRotateStart;
        self.rankStar2ImageView.hidden = NO;
    }
    else if (starNumber == 3)
    {
        self.rankStar3ImageView.transform = scaleAndRotateStart;
        self.rankStar3ImageView.hidden = NO;
    }
    
    __block NSInteger starNumberForBlock = starNumber;
    
    [UIView animateWithDuration:0.33
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
                     {
                         CGAffineTransform scaleEnd = CGAffineTransformMakeScale(1.0, 1.0);
                         CGAffineTransform rotateEnd = CGAffineTransformMakeRotation(0.0);
                         CGAffineTransform scaleAndRotateEnd = CGAffineTransformConcat(scaleEnd, rotateEnd);
                         
                         if (starNumber == 1)
                         {
                             self.rankStar1ImageView.transform = scaleAndRotateEnd;
                         }
                         else if (starNumber == 2)
                         {
                             self.rankStar2ImageView.transform = scaleAndRotateEnd;
                         }
                         else if (starNumber == 3)
                         {
                             self.rankStar3ImageView.transform = scaleAndRotateEnd;
                         }
                     }
                     completion:^(BOOL finished)
                     {
                         if (finished)
                         {
                             if (starNumber < self.gameData.starRating.integerValue)
                             {
                                 [self beginStarAnimationForStar:(starNumberForBlock + 1)];
                             }
                             else
                             {
                                 if (self.gameData.starRating.integerValue == 3)
                                 {
                                     self.rankStar1EmitterLayer = [self generateEmitterLayerForRankStarImageView:self.rankStar1ImageView
                                                                                                        withName:@"star1"];
                                     self.rankStar2EmitterLayer = [self generateEmitterLayerForRankStarImageView:self.rankStar2ImageView
                                                                                                        withName:@"star2"];
                                     self.rankStar3EmitterLayer = [self generateEmitterLayerForRankStarImageView:self.rankStar3ImageView
                                                                                                        withName:@"star3"];
                                     
                                     [self.rankStar1ImageView.layer addSublayer:self.rankStar1EmitterLayer];
                                     [self.rankStar2ImageView.layer addSublayer:self.rankStar2EmitterLayer];
                                     [self.rankStar3ImageView.layer addSublayer:self.rankStar3EmitterLayer];
                                     
                                     [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectFireworks;
                                     [[MMXAudioManager sharedManager] playSoundEffect];
                                     
                                     [self performSelector:@selector(stopParticles) withObject:nil afterDelay:1.0];
                                 }
                             }
                         }
                     }];
}

- (CAEmitterLayer *)generateEmitterLayerForRankStarImageView:(UIImageView *)rankStarImageView withName:(NSString *)name
{
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = CGPointMake(rankStarImageView.bounds.origin.x + (rankStarImageView.bounds.size.width / 2.0),
                                               rankStarImageView.bounds.origin.y + (rankStarImageView.bounds.size.width / 2.0));
    emitterLayer.emitterShape = kCAEmitterLayerPoint;
    emitterLayer.emitterZPosition = 10;
    emitterLayer.seed = arc4random();
    
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.birthRate = (275 + arc4random_uniform(26)) / 100.0;
    emitterCell.emissionLongitude = (CGFloat)-M_PI_2;
    emitterCell.emissionRange = (CGFloat)(M_PI_4);
    emitterCell.contents = (id)[[UIImage imageNamed:@"MMXRankStarFull"] CGImage];
    emitterCell.lifetime = 5.0;
    emitterCell.name = name;
    emitterCell.scale = 0.5;
    emitterCell.scaleRange = 0.25;
    emitterCell.spin = 0;
    emitterCell.spinRange = (CGFloat)M_PI_2;
    emitterCell.velocity = 325.0;
    emitterCell.velocityRange = 25.0;
    emitterCell.yAcceleration = 275.0;
    
    emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell];
    
    return emitterLayer;
}

- (void)rainbowizeNewRecordLabel
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.recordLabel.attributedText.string];
    NSArray *colors = @[[UIColor mmx_redColor], [UIColor mmx_blueColor], [UIColor mmx_greenColor],
                        [UIColor mmx_orangeColor], [UIColor mmx_purpleColor]];
    
    [attributedString beginEditing];
    for (NSInteger i = 0; i < self.recordLabel.text.length; i++)
    {
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:colors[i % colors.count]
                                 range:NSMakeRange(i, 1)];
    }
    [attributedString endEditing];
    
    self.recordLabel.attributedText = attributedString;
}

- (void)stopParticles
{
    // Not sure why I need both of these to make it work, but I should investigate this in the future.
    
    ((CAEmitterCell *)self.rankStar1EmitterLayer.emitterCells[0]).birthRate = 0.0;
    ((CAEmitterCell *)self.rankStar2EmitterLayer.emitterCells[0]).birthRate = 0.0;
    ((CAEmitterCell *)self.rankStar3EmitterLayer.emitterCells[0]).birthRate = 0.0;
 
    [self.rankStar1EmitterLayer setValue:@0.0 forKeyPath:@"emitterCells.star1.birthrate"];
    [self.rankStar2EmitterLayer setValue:@0.0 forKeyPath:@"emitterCells.star2.birthrate"];
    [self.rankStar3EmitterLayer setValue:@0.0 forKeyPath:@"emitterCells.star3.birthrate"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        [self.rankStar1EmitterLayer removeFromSuperlayer];
        [self.rankStar2EmitterLayer removeFromSuperlayer];
        [self.rankStar3EmitterLayer removeFromSuperlayer];
    });
}

#pragma mark - KMODecisionViewDelegate

- (void)decisionView:(KMODecisionView *)decisionView tappedButtonAtIndex:(NSInteger)buttonIndex
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    if (buttonIndex == 0)
    {
        // Player cancelled. Do nothing.
    }
    else if (buttonIndex == 1) // Player decided to return to the main menu.
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (buttonIndex == 2) // Player wants to try again.
    {
         [self performSegueWithIdentifier:@"MMXUnwindToGameSegue" sender:self];
    }
    else if (buttonIndex == 3)
    {
        // Player wanted to change the settings or the course.
        if (self.gameData.gameType == MMXGameTypePractice)
        {
            [self performSegueWithIdentifier:@"MMXUnwindToPracticeConfigurationSegue" sender:self];
        }
        else // Player wanted to view the list of lessons for the current course.
        {
            [self performSegueWithIdentifier:@"MMXUnwindToLessonsSegue" sender:self];
        }
    }
    else if (buttonIndex == 4)
    {
        self.shouldShowNextLesson = YES;
        [self performSegueWithIdentifier:@"MMXUnwindToLessonsSegue" sender:self];
    }
}

@end
