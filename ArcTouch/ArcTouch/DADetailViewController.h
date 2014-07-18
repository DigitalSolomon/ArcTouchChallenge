//
//  DADetailViewController.h
//  ArcTouch
//
//  Created by Jason Townes French on 7/17/14.
//  Copyright (c) 2014 Digital Alchemy Technologies, GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DARoute.h"
#import "DAStop.h"
#import "DADeparture.h"

@interface DADetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) DARoute* route;
@property (strong, nonatomic) NSArray* stops;
@property (strong, nonatomic) NSArray* departures;
@end
