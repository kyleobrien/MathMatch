//
//  MMXReportCardTableViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.7.16.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "KMODecisionView.h"
#import "MMXReportCardTableViewController.h"
#import "MMXTimeIntervalFormatter.h"
#import "MMXTopScore.h"

@interface MMXReportCardTableViewController ()

@property (nonatomic, assign) NSInteger coursesPlayed, practicePlays;
@property (nonatomic, assign) NSInteger correctMatches, incorrectMatches;
@property (nonatomic, assign) CGFloat correctPercentage, incorrectPercentage;
@property (nonatomic, assign) NSInteger starsEarned, totalStarsAvailable;
@property (nonatomic, assign) NSTimeInterval timePlayed;

@property (nonatomic, assign) BOOL showErrorMessage;

@end

@implementation MMXReportCardTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MMXGameData"
                                                         inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSError *fetchError = nil;
    NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (fetchError)
    {
        self.showErrorMessage = YES;
    }
    else
    {
        for (MMXGameData *gameData in fetchedResults)
        {
            if (gameData.gameType == MMXGameTypeCourse)
            {
                self.coursesPlayed += 1;
            }
            else if (gameData.gameType == MMXGameTypePractice)
            {
                self.practicePlays += 1;
            }
            
            self.correctMatches += gameData.attemptedMatches.integerValue - gameData.incorrectMatches.integerValue;
            self.incorrectMatches += gameData.incorrectMatches.integerValue;
            
            self.timePlayed += gameData.completionTime.doubleValue;
        }
        
        if ((self.correctMatches == 0) && (self.incorrectMatches == 0))
        {
            self.correctPercentage = 0.0;
            self.incorrectPercentage = 0.0;
        }
        else
        {
            self.correctPercentage = self.correctMatches / (CGFloat)(self.correctMatches + self.incorrectMatches);
            self.correctPercentage = floorf(self.correctPercentage * 1000) / 10;
            self.incorrectPercentage = 100.0 - self.correctPercentage;
        }
    }
    
    
    entityDescription = [NSEntityDescription entityForName:@"MMXTopScore"
                                    inManagedObjectContext:self.managedObjectContext];
    fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    fetchError = nil;
    fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (fetchError)
    {
        self.showErrorMessage = YES;
    }
    else
    {
        for (MMXTopScore *topScore in fetchedResults)
        {
            self.starsEarned += topScore.stars.integerValue;
        }
    }
    
    
    NSError *jsonError = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"classes" withExtension:@"json"]];
    NSArray *classesFromJSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:0
                                                                 error:&jsonError];
    
    if (jsonError)
    {
        self.showErrorMessage = YES;
    }
    else
    {
        for (NSDictionary *class in classesFromJSON)
        {
            NSArray *lessons = class[@"lessons"];
            
            self.totalStarsAvailable += lessons.count * 3;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_redColor];
    
    // Doesn't deselect on swipe back (bug?) so doing it manually.
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.showErrorMessage)
    {
        NSString *message = NSLocalizedString(@"Couldn't retrieve player information because of a database error.", nil);
        KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:message
                                                                        delegate:nil
                                                               cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                               otherButtonTitles:nil];
        [decisionView showInViewController:self.navigationController andDimBackgroundWithPercent:0.50];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController)
    {
        [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapBackward;
        [[MMXAudioManager sharedManager] playSoundEffect];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ((indexPath.section == 0) && (indexPath.row == 0))
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.coursesPlayed];
    }
    else if ((indexPath.section == 0) && (indexPath.row == 1))
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.practicePlays];
    }
    else if ((indexPath.section == 0) && (indexPath.row == 2))
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)(self.coursesPlayed + self.practicePlays)];
    }
    else if ((indexPath.section == 1) && (indexPath.row == 0))
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld (%3.1f%%)", (long)self.correctMatches, self.correctPercentage];
    }
    else if ((indexPath.section == 1) && (indexPath.row == 1))
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld (%3.1f%%)", (long)self.incorrectMatches, self.incorrectPercentage];
    }
    else if ((indexPath.section == 2) && (indexPath.row == 0))
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld of %ld", nil), (long)self.starsEarned, (long)self.totalStarsAvailable];
    }
    else if ((indexPath.section == 2) && (indexPath.row == 1))
    {
        NSArray *temp = [MMXTimeIntervalFormatter reportCardFormatWithInterval:self.timePlayed];
        cell.detailTextLabel.text = temp[0];
        cell.detailTextLabel.accessibilityLabel = temp[1];
    }
    
    return cell;
}

#pragma mark - UITableViewControllerDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 64.0;
    }
    
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 21.0)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0,
                                                               15.0 + (section == 0 ? 20.0 : 0.0),
                                                               view.bounds.size.width - 15.0,
                                                               21.0)];
    label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15.0];
    label.textColor = [UIColor mmx_redColor];
    
    if (section == 0)
    {
        label.text = NSLocalizedString(@"Games Played", nil);
    }
    else if (section == 1)
    {
        label.text = NSLocalizedString(@"Matches Made", nil);
    }
    else if (section == 2)
    {
        label.text = NSLocalizedString(@"Other", nil);
    }
    
    [view addSubview:label];
    
    return view;
}

@end
