//
//  DADetailViewController.m
//  ArcTouch
//
//  Created by Jason Townes French on 7/17/14.
//  Copyright (c) 2014 Digital Alchemy Technologies, GmbH. All rights reserved.
//

#import "DADetailViewController.h"
#import "DATableCell.h"
#import "DAAppDelegate.h"
#import "DATableHeaderCell.h"

@interface DADetailViewController ()

@end

@implementation DADetailViewController

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
    self.title = _route.longName;
    [DAAppDelegate sharedDelegate].detailViewController = self;
    [[DAAppDelegate sharedDelegate] findDeparturesByRouteId:_route.id];
    [[DAAppDelegate sharedDelegate] findStopsByRouteId:_route.id];
    
    [self.segmentedControl addTarget:self
                              action:@selector(tappedSegmentedControl:)
                    forControlEvents:UIControlEventValueChanged];
    [_tableView reloadData];
    
}

- (void) tappedSegmentedControl:(id)sender
{
    NSLog(@"tappedSegmentedControl:%i", _segmentedControl.selectedSegmentIndex);
    [_tableView reloadData];
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
    if(_segmentedControl.selectedSegmentIndex == 0)
    {
        return 1;
    }
    else if(_segmentedControl.selectedSegmentIndex == 1)
    {
        return 3;
    }
    return 1;
}

/*
 This causes the TableView to render a section header, but only for when the Timetables
 index is selected from the UISegmentedControl
 */

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_segmentedControl.selectedSegmentIndex == 0)
    {
        return [[UIView alloc] initWithFrame:CGRectZero];
        //return nil;
    }
    static NSString *CellIdentifier = @"HeaderCell";
    DATableHeaderCell *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    while (sectionHeaderView.contentView.gestureRecognizers.count) {
        [sectionHeaderView.contentView removeGestureRecognizer:[sectionHeaderView.contentView.gestureRecognizers objectAtIndex:0]];
    }
    if(section == 0)
    {
        sectionHeaderView.label.text = @"WEEKDAY";
    }
    else if(section == 1)
    {
        sectionHeaderView.label.text = @"SATURDAY";
    }
    else if(section == 2)
    {
        sectionHeaderView.label.text = @"SUNDAY";
    }
    return sectionHeaderView.contentView;
}


/* This is here to make sure there's no table header for the Stops version of TableView
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_segmentedControl.selectedSegmentIndex == 0)
    {
        return 1;
    }
    else
    {
        return 27;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_segmentedControl.selectedSegmentIndex == 0)
    {
        NSArray* stops = [DAAppDelegate sharedDelegate].searchedStops;
        if(stops != nil && [stops count] > 0)
        {
            return [stops count];
        }
        else
        {
            //
            return 0;
        }
    }
    else if(_segmentedControl.selectedSegmentIndex == 1)
    {
        if(section == 0)
        {
            NSArray* departures = [DAAppDelegate sharedDelegate].weekdayDepartures;
            if(departures != nil && [departures count] > 0)
            {
                return [departures count];
            }
            else
            {
                //
                return 0;
            }
        }
        else if(section == 1)
        {
            NSArray* departures = [DAAppDelegate sharedDelegate].saturdayDepartures;
            if(departures != nil && [departures count] > 0)
            {
                return [departures count];
            }
            else
            {
                //
                return 0;
            }
        }
        else if(section == 2)
        {
            NSArray* departures = [DAAppDelegate sharedDelegate].sundayDepartures;
            if(departures != nil && [departures count] > 0)
            {
                return [departures count];
            }
            else
            {
                //
                return 0;
            }
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath %@", indexPath);
    static NSString *CellIdentifier = @"TableCell";
    
    DATableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //NSLog(@"configuring cell...");
    long row = [indexPath row];
    if(_segmentedControl.selectedSegmentIndex == 0)
    {
        DAStop* stop = [[DAAppDelegate sharedDelegate].searchedStops objectAtIndex:row];
        cell.label.text = [NSString stringWithFormat:@"#%i %@", stop.sequence, stop.name];
        cell.imageView.image = [UIImage imageNamed:@"location-256.png"];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if(_segmentedControl.selectedSegmentIndex == 1)
    {
        if(indexPath.section == 0)
        {
            DADeparture* departure = [[DAAppDelegate sharedDelegate].weekdayDepartures objectAtIndex:row];
            cell.label.text = [NSString stringWithFormat:@"%@, %@",departure.calendar, departure.time];
            cell.imageView.image = [UIImage imageNamed:@"clock-256.png"];
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        else if(indexPath.section == 1)
        {
            DADeparture* departure = [[DAAppDelegate sharedDelegate].saturdayDepartures objectAtIndex:row];
            cell.label.text = [NSString stringWithFormat:@"%@, %@",departure.calendar, departure.time];
            cell.imageView.image = [UIImage imageNamed:@"clock-256.png"];
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        else if(indexPath.section == 2)
        {
            DADeparture* departure = [[DAAppDelegate sharedDelegate].sundayDepartures objectAtIndex:row];
            cell.label.text = [NSString stringWithFormat:@"%@, %@",departure.calendar, departure.time];
            cell.imageView.image = [UIImage imageNamed:@"clock-256.png"];
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Row: %u", indexPath.row);
    
   
}

@end
