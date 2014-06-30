//
//  MMXSettingsViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.6.20.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXNavigationController.h"
#import "MMXSettingsViewController.h"
#import "MMXVolumeCell.h"

@interface MMXSettingsViewController ()

@end

@implementation MMXSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (IBAction)playerTappedDoneButton:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        MMXVolumeCell *volumeCell = (MMXVolumeCell *)cell;
        volumeCell.volumeSettingType = MMXVolumeSettingTypeTrack;
        
        [volumeCell configureSliderWithUserDefaults];
        
        return volumeCell;
    }
    else if (indexPath.section == 1)
    {
        MMXVolumeCell *volumeCell = (MMXVolumeCell *)cell;
        volumeCell.volumeSettingType = MMXVolumeSettingTypeSFX;
        
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
        
        NSString *message = NSLocalizedString(@"You're about to reset all progress, including stars, best times and completed game stats. Are you sure? You cannot undue this action.", nil);
        KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:message
                                                                        delegate:self
                                                               cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                               otherButtonTitles:@[NSLocalizedString(@"Yes, Reset", nil)]];
        decisionView.fontName = @"Futura-Medium";
        decisionView.destructiveButtonIndex = 1;
        decisionView.destructiveColor = [UIColor mmx_redColor];
        
        [decisionView showAndDimBackgroundWithPercent:0.50];
    }
    else if ((indexPath.section == 3) && (indexPath.row == 0))
    {
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
                                                                   cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                                   otherButtonTitles:nil];
            [decisionView showAndDimBackgroundWithPercent:0.50];
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - KMODecisionViewDelegate

- (void)decisionView:(KMODecisionView *)decisionView tappedButtonAtIndex:(NSInteger)buttonIndex
{
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

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultFailed)
    {
        NSString *message = NSLocalizedString(@"Couldn't send the email. Try again later.", nil);
        KMODecisionView *decisionView = [[KMODecisionView alloc] initWithMessage:message
                                                                        delegate:nil
                                                               cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                               otherButtonTitles:nil];
        [decisionView showAndDimBackgroundWithPercent:0.50];
    }
}

@end
