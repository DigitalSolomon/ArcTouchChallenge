//
//  DAAppDelegate.m
//  ArcTouch
//
//  Created by Jason Townes French on 7/16/14.
//  Copyright (c) 2014 Digital Alchemy Technologies, GmbH. All rights reserved.
//

#import "DAAppDelegate.h"
#import <RestKit/RestKit.h>
#import "DAResponse.h"
#import "DARoute.h"
#import "DAStop.h"
#import "DADeparture.h"

static NSString* const BaseURLString = @"https://dashboard.appglu.com/v1/queries/";
//https://dashboard.appglu.com/v1/queries/findRoutesByStopName/run
//https://dashboard.appglu.com/v1/queries/findStopsByRouteId/run
//https://dashboard.appglu.com/v1/queries/findDeparturesByRouteId/run

@implementation DAAppDelegate

@synthesize window = _window;

// This is a helper method to make it easy to get a reference to the App Delegate from anywhere
+ (DAAppDelegate *)sharedDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureRestKit];
    return YES;
}

/*
 We use this method to get our REST engine configured. This sets up some mappings between
 the URIs we will be requesting, and a few simple model classes to store the response
 from the web service.
 */
- (void)configureRestKit
{
    NSLog(@"configureRestKit");
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://dashboard.appglu.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *routeMapping = [RKObjectMapping mappingForClass:[DARoute class]];
    [routeMapping addAttributeMappingsFromArray:@[@"id"]];
    [routeMapping addAttributeMappingsFromArray:@[@"shortName"]];
    [routeMapping addAttributeMappingsFromArray:@[@"longName"]];
    
    RKObjectMapping *stopMapping = [RKObjectMapping mappingForClass:[DAStop class]];
    [stopMapping addAttributeMappingsFromArray:@[@"name"]];
    [stopMapping addAttributeMappingsFromArray:@[@"sequence"]];
    [stopMapping addAttributeMappingsFromArray:@[@"routeId"]];
    
    RKObjectMapping* departureMapping = [RKObjectMapping mappingForClass:[DADeparture class]];
    [departureMapping addAttributeMappingsFromArray:@[@"calendar"]];
    [departureMapping addAttributeMappingsFromArray:@[@"time"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:routeMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/v1/queries/findRoutesByStopName/run"
                                                keyPath:@"rows"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *responseDescriptor2 =
    [RKResponseDescriptor responseDescriptorWithMapping:stopMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/v1/queries/findStopsByRouteId/run"
                                                keyPath:@"rows"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *responseDescriptor3 =
    [RKResponseDescriptor responseDescriptorWithMapping:departureMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/v1/queries/findDeparturesByRouteId/run"
                                                keyPath:@"rows"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    //
    [objectManager addResponseDescriptor:responseDescriptor];
    [objectManager addResponseDescriptor:responseDescriptor2];
    [objectManager addResponseDescriptor:responseDescriptor3];
}



/*
This is a wrapper method for findRoutesByStopName. It also populates some arrays to cache
 the data that was fetched so that it can be later used by the necessary view controllers.
*/
- (void)findRoutesByStopName:(NSString*)stopName
{
    NSLog(@"findRoutesByStopName:%@", stopName);
    
    NSDictionary* params = @{@"stopName" : [NSString stringWithFormat:@"%%%@%%", stopName]};
    NSDictionary *queryParams = @{@"params" : params};
    
    NSString* token = @"V0tENE43WU1BMXVpTThWOkR0ZFR0ek1MUWxBMGhrMkMxWWk1cEx5VklsQVE2OA==";
    
    
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"content-type" value:RKMIMETypeJSON];
    
    // Set up Authorization
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"Basic %@", token]];
    
    // Apply custom headers for AppGlu environment
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"X-AppGlu-Environment" value:@"staging"];
    
    // Issue POST Request and handle response
    [_listViewController.activityIndicator startAnimating];
    _listViewController.activityIndicator.hidden = NO;
    [[RKObjectManager sharedManager] postObject:nil path:@"/v1/queries/findRoutesByStopName/run" parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //
        NSLog(@"Response String: %@", operation.HTTPRequestOperation.responseString);
        NSLog(@"Mapping Result Array: %@", mappingResult.array);
        if([mappingResult.array count] > 0)
        {
            _searchedRoutes = mappingResult.array;
            for (DARoute* route in mappingResult.array) {
                //
                NSLog(@"Route: %@", route.longName);
            }
            
            
            
        }
        else
        {
            NSLog(@"Nothing matches");
            _searchedRoutes = nil;
        }
        // Tell the TableView in the list view controller to update/reload
        [_listViewController.tableView reloadData];
        [_listViewController.activityIndicator stopAnimating];
        _listViewController.activityIndicator.hidden = YES;
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
        _searchedRoutes = nil;
        // Tell the TableView in the list view controller to update/reload
        [_listViewController.tableView reloadData];
        [_listViewController.activityIndicator stopAnimating];
        _listViewController.activityIndicator.hidden = YES;
    }];
    
}

/*
 This is a wrapper method for findStopsByRouteId. It also populates some arrays to cache
 the data that was fetched so that it can be later used by the necessary view controllers.
 */
- (void)findStopsByRouteId:(int)routeId
{
    NSLog(@"findStopsByRouteId:%i", routeId);
    
    NSDictionary* params = @{@"routeId" : [NSNumber numberWithInt:routeId]};
    NSDictionary *queryParams = @{@"params" : params};
    
    NSString* token = @"V0tENE43WU1BMXVpTThWOkR0ZFR0ek1MUWxBMGhrMkMxWWk1cEx5VklsQVE2OA==";
    
    
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"content-type" value:RKMIMETypeJSON];
    
    // Set up Authorization
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"Basic %@", token]];
    
    // Apply custom headers for AppGlu environment
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"X-AppGlu-Environment" value:@"staging"];
    
    // Issue POST Request and handle response
    [[RKObjectManager sharedManager] postObject:nil path:@"/v1/queries/findStopsByRouteId/run" parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //
        NSLog(@"Response String: %@", operation.HTTPRequestOperation.responseString);
        NSLog(@"Mapping Result Array: %@", mappingResult.array);
        if([mappingResult.array count] > 0)
        {
            _searchedStops = mappingResult.array;
            for (DAStop* stop in mappingResult.array) {
                //
                NSLog(@"Stop: #%i %@", stop.sequence, stop.name);
            }
            
            
            
        }
        else
        {
            NSLog(@"Nothing matches");
            _searchedStops = nil;
        }
        // Tell the TableView in the list view controller to update/reload
        [_detailViewController.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
        _searchedStops = nil;
        // Tell the TableView in the list view controller to update/reload
        [_detailViewController.tableView reloadData];
    }];
    
}

/*
 This is a wrapper method for findDeparturesByRouteId. It also populates some arrays to cache
 the data that was fetched so that it can be later used by the necessary view controllers.
 */
- (void)findDeparturesByRouteId:(int)routeId
{
    NSLog(@"findDeparturesByRouteId:%i", routeId);
    
    NSDictionary* params = @{@"routeId" : [NSNumber numberWithInt:routeId]};
    NSDictionary *queryParams = @{@"params" : params};
    
    NSString* token = @"V0tENE43WU1BMXVpTThWOkR0ZFR0ek1MUWxBMGhrMkMxWWk1cEx5VklsQVE2OA==";
    
    
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"content-type" value:RKMIMETypeJSON];
    
    // Set up Authorization
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"Basic %@", token]];
    
    // Apply custom headers for AppGlu environment
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"X-AppGlu-Environment" value:@"staging"];
    
    // Issue POST Request and handle response
    [[RKObjectManager sharedManager] postObject:nil path:@"/v1/queries/findDeparturesByRouteId/run" parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //
        NSLog(@"Response String: %@", operation.HTTPRequestOperation.responseString);
        NSLog(@"Mapping Result Array: %@", mappingResult.array);
        if([mappingResult.array count] > 0)
        {
            _searchedDepartures = mappingResult.array;
            _weekdayDepartures = [[NSMutableArray alloc]init];
            _saturdayDepartures = [[NSMutableArray alloc]init];
            _sundayDepartures = [[NSMutableArray alloc]init];
            for (DADeparture* departure in mappingResult.array) {
                //
                NSLog(@"Departure: %@, %@", departure.calendar, departure.time);
                
                if([departure.calendar isEqualToString:@"WEEKDAY"])
                {
                    [_weekdayDepartures addObject:departure];
                }
                else if([departure.calendar isEqualToString:@"SATURDAY"])
                {
                    [_saturdayDepartures addObject:departure];
                }
                else if([departure.calendar isEqualToString:@"SUNDAY"])
                {
                    [_sundayDepartures addObject:departure];
                }
            }
            
            NSLog(@"# of Weekday Departures: %i", [_weekdayDepartures count]);
            NSLog(@"# of Saturday Departures: %i", [_saturdayDepartures count]);
            NSLog(@"# of Sunday Departures: %i", [_sundayDepartures count]);
            
            NSLog(@"# of Departures (total): %i", [_searchedDepartures count]);
            
            
        }
        else
        {
            NSLog(@"Nothing matches");
            _searchedDepartures = nil;
        }
        // Tell the TableView in the list view controller to update/reload
        [_detailViewController.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
        _searchedDepartures = nil;
        // Tell the TableView in the list view controller to update/reload
        [_detailViewController.tableView reloadData];
    }];
    
}


@end
