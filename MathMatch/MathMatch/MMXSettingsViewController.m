//
//  MMXSettingsViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.6.20.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXNavigationController.h"
#import "MMXSettingsViewController.h"
#import "MathMatch-Swift.h"

@implementation MMXSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor mmx_whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Doesn't deselect on swipe back (bug?) so doing it manually.
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MMXShowCardStylesSegue"])
    {
        [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapForward;
        [[MMXAudioManager sharedManager] playSoundEffect];
    }
    else if ([segue.identifier isEqualToString:@"MMXShowAboutSegue"])
    {
        [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapForward;
        [[MMXAudioManager sharedManager] playSoundEffect];
    }
}

#pragma mark - Player action

- (IBAction)playerTappedDoneButton:(id)sender
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        VolumeCell *volumeCell = (VolumeCell *)cell;
        volumeCell.volumeSettingType = @2;
        
        [volumeCell configureSliderWithUserDefaults];
        
        return volumeCell;
    }
    else if (indexPath.section == 1)
    {
        VolumeCell *volumeCell = (VolumeCell *)cell;
        volumeCell.volumeSettingType = VolumeSettingTypeSFX;
        
        [volumeCell configureSliderWithUserDefaults];
        
        return volumeCell;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 2) && (indexPath.row == 1))
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
        [[MMXAudioManager sharedManager] playSoundEffect];
        
        NSString *message = NSLocalizedString(@"You're about to reset all progress, including stars, best times and completed game stats. Are you sure? You cannot undo this action.", nil);
        KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:message
                                                                        delegate:self
                                                               cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                               otherButtonTitles:@[NSLocalizedString(@"Yes, Reset", nil)]];
        decisionView.destructiveButtonIndex = 1;
        decisionView.destructiveColor = [UIColor mmx_redColor];
        decisionView.fontName = @"Futura-Medium";
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [decisionView showInViewController:self andDimBackgroundWithPercent:0.50];
        }
        else
        {
            [decisionView showInViewController:self.navigationController andDimBackgroundWithPercent:0.50];
        }
        
    }
    else if ((indexPath.section == 3) && (indexPath.row == 0))
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
        [[MMXAudioManager sharedManager] playSoundEffect];
        
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
            [mailComposeViewController setSubject:@"Math Match - Feedback"];
            [mailComposeViewController setToRecipients:@[@"support@connectrelatecreate.com"]];
            [mailComposeViewController setMessageBody:@"" isHTML:NO];
            
            mailComposeViewController.navigationBar.tintColor = [UIColor mmx_purpleColor];
            mailComposeViewController.mailComposeDelegate = self;
            
            [self presentViewController:mailComposeViewController animated:YES completion:nil];
        }
        else
        {
            NSString *message = NSLocalizedString(@"Can't send because no email account is configured on this device.", nil);
            
            KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:message
                                                                            delegate:nil
                                                                   cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                   otherButtonTitles:nil];
            [decisionView showInViewController:self andDimBackgroundWithPercent:0.50];
        }
    }
    else if ((indexPath.section == 3) && (indexPath.row == 1))
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
        [[MMXAudioManager sharedManager] playSoundEffect];
                
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=896517401&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
    }
    else if ((indexPath.section == 3) && (indexPath.row == 2))
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
        [[MMXAudioManager sharedManager] playSoundEffect];
        
        NSString *message = NSLocalizedString(@"Check out Math Match, a game of concentration, memory, and arithmetic available on the App Store!", nil);
        NSURL *appStoreURL = [NSURL URLWithString:@"http://appstore.com/mathmatchagameofconcentrationmemoryandarithmetic"];
        
        NSArray *items = @[message, appStoreURL];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items
                                                                                             applicationActivities:nil];
        
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    else if ((indexPath.section == 4) && (indexPath.row == 0))
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
        [[MMXAudioManager sharedManager] playSoundEffect];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://connectrelatecreate.com/mathmatch/"]];
    }
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
    label.textColor = [UIColor mmx_purpleColor];
    
    if (section == 0)
    {
        label.text = NSLocalizedString(@"Music Volume", nil);
    }
    else if (section == 1)
    {
        label.text = NSLocalizedString(@"Sound Effects Volume", nil);
    }
    else if (section == 2)
    {
        label.text = NSLocalizedString(@"Options", nil);
    }
    else if (section == 3)
    {
        label.text = NSLocalizedString(@"More", nil);
    }
    else if (section == 4)
    {
        label.text = NSLocalizedString(@"About", nil);
    }
    
    [view addSubview:label];
    
    return view;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultFailed)
    {
        NSString *message = NSLocalizedString(@"Couldn't send the email. Try again later.", nil);
        KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:message
                                                                        delegate:nil
                                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                               otherButtonTitles:nil];
        [decisionView showInViewController:self andDimBackgroundWithPercent:0.50];
    }
}

#pragma mark - KMODecisionViewDelegate

- (void)decisionView:(KMODecisionView *)decisionView tappedButtonAtIndex:(NSInteger)buttonIndex
{
    [MMXAudioManager sharedManager].soundEffect = MMXAudioSoundEffectTapNeutral;
    [[MMXAudioManager sharedManager] playSoundEffect];
    
    if (buttonIndex == 1)
    {
        [self deleteAllEntities];
    }
}

#pragma mark - Helpers

- (void)deleteAllEntities
{
    NSManagedObjectContext *managedObjectContext = ((MMXNavigationController *)self.navigationController).managedObjectContext;
    
    NSFetchRequest *dataFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *dataEntityDescription = [NSEntityDescription entityForName:@"MMXGameData"
                                                             inManagedObjectContext:managedObjectContext];
    
    [dataFetchRequest setEntity:dataEntityDescription];
    [dataFetchRequest setIncludesPropertyValues:NO];
    
    NSError *fetchError = nil;
    NSArray *allGameDataEntities = [managedObjectContext executeFetchRequest:dataFetchRequest error:&fetchError];
    
    for (MMXGameData *gameData in allGameDataEntities)
    {
        [managedObjectContext deleteObject:gameData];
    }
    
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
}

@end
