//
//  FirecallTableViewController.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/1/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface FirecallTableViewController : UITableViewController <SlideNavigationControllerDelegate>

- (IBAction)logoutAction:(id)sender;
- (IBAction)menuAction:(id)sender;

@end
