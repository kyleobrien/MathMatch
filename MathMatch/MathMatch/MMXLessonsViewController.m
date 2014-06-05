//
//  MMXLessonsViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.5.19.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXGameViewController.h"
#import "MMXLessonTableViewCell.h"
#import "MMXLessonsViewController.h"

@interface MMXLessonsViewController ()

@end

@implementation MMXLessonsViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_blueColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lessons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *lesson = self.lessons[indexPath.row];
    
    MMXLessonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMXLessonCell" forIndexPath:indexPath];
    cell.lessonTitleLabel.text = lesson[@"title"];
    
    return cell;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MMXBeginLessonSegue"])
    {
        NSDictionary *lesson = self.lessons[self.tableView.indexPathForSelectedRow.row];
        MMXGameData *gameConfiguration = [self gameConfigurationFromLesson:lesson];
        
        MMXGameViewController *gameViewController = (MMXGameViewController *)segue.destinationViewController;
        gameViewController.managedObjectContext = self.managedObjectContext;
        gameViewController.gameData = gameConfiguration;
    }
}

- (IBAction)unwindToLessonsSegue:(UIStoryboardSegue *)unwindSegue
{
    
}

- (MMXGameData *)gameConfigurationFromLesson:(NSDictionary *)lesson
{
    MMXGameData *gameConfiguration = [NSEntityDescription insertNewObjectForEntityForName:@"MMXGameData"
                                                                   inManagedObjectContext:self.managedObjectContext];
    
    gameConfiguration.gameType = MMXGameTypeCourse;
    gameConfiguration.lessonID = lesson[@"lessonID"];
    
    gameConfiguration.targetNumber = lesson[@"targetNumber"];
    gameConfiguration.numberOfCards = lesson[@"numberOfCards"];
    
    if ([lesson[@"arithmeticType"] isEqualToString:@"addition"])
    {
        gameConfiguration.arithmeticType = MMXArithmeticTypeAddition;
    }
    else if ([lesson[@"arithmeticType"] isEqualToString:@"subtraction"])
    {
        gameConfiguration.arithmeticType = MMXArithmeticTypeSubtraction;
    }
    else if ([lesson[@"arithmeticType"] isEqualToString:@"multiplication"])
    {
        gameConfiguration.arithmeticType = MMXArithmeticTypeMultiplication;
    }
    else if ([lesson[@"arithmeticType"] isEqualToString:@"division"])
    {
        gameConfiguration.arithmeticType = MMXArithmeticTypeDivision;
    }
    else
    {
        NSAssert(YES, @"MMX: Arithmetic Type in JSON is not valid.");
    }
    
    if ([lesson[@"memorySpeed"] isEqualToString:@"fast"])
    {
        gameConfiguration.memorySpeed = MMXMemorySpeedFast;
    }
    else if ([lesson[@"memorySpeed"] isEqualToString:@"slow"])
    {
        gameConfiguration.memorySpeed = MMXMemorySpeedSlow;
    }
    else if ([lesson[@"memorySpeed"] isEqualToString:@"none"])
    {
        gameConfiguration.memorySpeed = MMXMemorySpeedNone;
    }
    else
    {
        NSAssert(YES, @"MMX: Memory Speed in JSON is not valid.");
    }
    
    // TODO: Need music tracks first.
    //"musicTrack" : ""
    
    gameConfiguration.cardStyle = [MMXGameData selectRandomCardStyle];
    
    gameConfiguration.penaltyMultiplier = lesson[@"penaltyMultiplier"];
    
    NSArray *starTimes = lesson[@"starTimes"];
    gameConfiguration.twoStarTime = starTimes[0];
    gameConfiguration.threeStarTime = starTimes[1];
    
    return gameConfiguration;
}

@end
