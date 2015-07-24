//
//  MainNavigationController.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/1/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.m"
#import "DBUser.h"
#import "SlideNavigationController.h"

@interface MainNavigationController : UINavigationController

- (void)loginUser:(DBUser *)user;
- (void)logOut;

@property (strong, nonatomic) DBUser * currentUser;
@property (strong, nonatomic) NSMutableDictionary * departments;

@end
