//
//  DATableCell.m
//  ArcTouch
//
//  Created by Jason Townes French on 7/17/14.
//  Copyright (c) 2014 Digital Alchemy Technologies, GmbH. All rights reserved.
//

#import "DATableCell.h"

@implementation DATableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(4,5,25,32);
}

@end
