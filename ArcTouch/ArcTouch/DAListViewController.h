//
//  DAListViewController.h
//  ArcTouch
//
//  Created by Jason Townes French on 7/16/14.
//  Copyright (c) 2014 Digital Alchemy Technologies, GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
