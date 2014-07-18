//
//  DAListViewController.m
//  ArcTouch
//
//  Created by Jason Townes French on 7/16/14.
//  Copyright (c) 2014 Digital Alchemy Technologies, GmbH. All rights reserved.
//

#import "DAListViewController.h"
#import "DARouteCell.h"
#import "DAAppDelegate.h"
#import "DARoute.h"
#import "DADetailViewController.h"

@interface DAListViewController ()

@end

@implementation DAListViewController

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
	// Do any additional setup after loading the view.
    [DAAppDelegate sharedDelegate].listViewController = self;
    self.title = @"Routes";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* routes = [DAAppDelegate sharedDelegate].searchedRoutes;
    if(routes != nil && [routes count] > 0)
    {
        return [routes count];
    }
    else
    {
        //
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath %@", indexPath);
    static NSString *CellIdentifier = @"RouteCell";
    
    DARouteCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //NSLog(@"configuring cell...");
    long row = [indexPath row];
    DARoute* route = [[DAAppDelegate sharedDelegate].searchedRoutes objectAtIndex:row];
    cell.routeNameLabel.text = route.longName;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Row: %u", indexPath.row);
    
    //[cell.activityIndicator startAnimating];
    // Prepare to Transition
    UIStoryboard *storyboard = self.navigationController.storyboard;
    //the detail controller
    DARoute* route = [[DAAppDelegate sharedDelegate].searchedRoutes objectAtIndex:indexPath.row];
    DADetailViewController *detailPage = [storyboard
                                       instantiateViewControllerWithIdentifier:@"DetailView"];
    detailPage.route = route;

    [self.navigationController pushViewController:detailPage animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    [[DAAppDelegate sharedDelegate] findRoutesByStopName:textField.text];
    [textField resignFirstResponder];
    return YES;
}

@end
