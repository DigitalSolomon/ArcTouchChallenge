//
//  DATableCell.h
//  ArcTouch
//
//  Created by Jason Townes French on 7/17/14.
//  Copyright (c) 2014 Digital Alchemy Technologies, GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DATableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end
