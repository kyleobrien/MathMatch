//
//  MMXClassesViewController.m
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.5.18.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

#import "MMXClassesViewController.h"
#import "MMXClassProgressTableViewCell.h"
#import "MMXClassStarTableViewCell.h"
#import "MMXLessonsViewController.h"

@interface MMXClassesViewController ()

@property (nonatomic, strong) NSArray *classesFromJSON;

@end

@implementation MMXClassesViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        NSError *error = nil;
        
        NSData *jsonData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"classes" withExtension:@"json"]];
        self.classesFromJSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:0
                                                                 error:&error];
        
        NSAssert(error == nil, @"JSON Parse Error!");
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Classes", nil);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_blueColor];
    
    // Doesn't deselect on sipe back (bug?) so doing it manually.
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor mmx_blackColor];
    
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MMXProgressCellToLessonsSegue"] ||
        [segue.identifier isEqualToString:@"MMXStarCellToLessonsSegue"])
    {
        NSDictionary *class = self.classesFromJSON[self.tableView.indexPathForSelectedRow.row];
        
        MMXLessonsViewController *lessonsViewController = (MMXLessonsViewController *)segue.destinationViewController;
        lessonsViewController.lessons = class[@"lessons"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classesFromJSON.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMXClassProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMXClassProgressCell" forIndexPath:indexPath];
    
    NSDictionary *class = self.classesFromJSON[indexPath.row];
    
    cell.classTitleLabel.text = class[@"title"];
    
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

@end
