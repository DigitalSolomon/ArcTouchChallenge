//
//  DAAppDelegate.h
//  ArcTouch
//
//  Created by Jason Townes French on 7/16/14.
//  Copyright (c) 2014 Digital Alchemy Technologies, GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAListViewController.h"
#import "DADetailViewController.h"

@interface DAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DAListViewController* listViewController;
@property (strong, nonatomic) DADetailViewController* detailViewController;
@property (strong, nonatomic) NSArray* searchedRoutes;
@property (strong, nonatomic) NSArray* searchedStops;
@property (strong, nonatomic) NSArray* searchedDepartures;
@property (strong, nonatomic) NSMutableArray* weekdayDepartures;
@property (strong, nonatomic) NSMutableArray* saturdayDepartures;
@property (strong, nonatomic) NSMutableArray* sundayDepartures;

+ (DAAppDelegate *)sharedDelegate;
- (void)findRoutesByStopName:(NSString*)stopName;
- (void)findStopsByRouteId:(int)routeId;
- (void)findDeparturesByRouteId:(int)routeId;
@end
