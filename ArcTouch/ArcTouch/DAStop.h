//
//  DAStop.h
//  ArcTouch
//
//  Created by Jason Townes French on 7/17/14.
//  Copyright (c) 2014 Digital Alchemy Technologies, GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAStop : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) int sequence;
@property (nonatomic, assign) int routeId;
@end
