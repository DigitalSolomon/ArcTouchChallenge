//
//  DARoute.h
//  ArcTouch
//
//  Created by Jason Townes French on 7/16/14.
//  Copyright (c) 2014 Digital Alchemy Technologies, GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DARoute : NSObject
@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString* shortName;
@property (nonatomic, strong) NSString* longName;
@property (nonatomic, strong) NSString* lastModifiedDate;
@property (nonatomic, assign) int agencyId;
@end
