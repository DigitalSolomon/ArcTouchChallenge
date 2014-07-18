//
//  DAResponse.h
//  ArcTouch
//
//  Created by Jason Townes French on 7/16/14.
//  Copyright (c) 2014 Digital Alchemy Technologies, GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAResponse : NSObject
@property (nonatomic, strong) NSArray* rows;
@property (nonatomic, assign) int rowsAffected;
@end
