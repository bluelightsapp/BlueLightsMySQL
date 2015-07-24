//
//  MainNavigationController.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/1/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import "MainNavigationController.h"
#import "FirecallTableViewController.h"
#import "LoginViewController.h"
#import "APIClient.h"

@implementation MainNavigationController {
    NSUserDefaults * defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * userDict = [defaults objectForKey:@"currentUser"];
    if (userDict) {
        self.currentUser = [[DBUser alloc] initWithDictionary:userDict error:nil];
        NSLog(@"%@", self.currentUser);
        [self showMainView];
    } else {
        [self logOut];
    }
    
    self.departments = [[NSMutableDictionary alloc] init];
    
//    [self logOut];
}

- (void)loginUser:(DBUser *)user {
    [self setCurrentUser:user];
}

- (void)setCurrentUser:(DBUser *)currentUser {
    if (!self.currentUser) {
        [self showMainView];
    }
    
    if (self.currentUser != currentUser) {
        _currentUser = currentUser;
        
        [defaults setObject:[currentUser dictionaryValue] forKey:@"currentUser"];
        [defaults synchronize];
    }
}

- (void)showMainView {
    [self.navigationBar setHidden:NO];
    FirecallTableViewController * vc = (FirecallTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"FirecallView"];
    [self setViewControllers:[NSArray arrayWithObjects:vc, nil] animated:YES];
}

- (void)logOut {
    [self setCurrentUser:nil];
    
    [self showLogin];
}

- (void)showLogin {
    [self.navigationBar setHidden:YES];
    LoginViewController * vc = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    [self setViewControllers:[NSArray arrayWithObjects:vc, nil] animated:YES];
}

- (void)refreshCurrentUser {
    NSDictionary * params = @{@"id": self.currentUser.objectId};
    
    APIClient * apiClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
    
    [apiClient POST:@"user.php?getUser" parameters:params completion:^(OVCResponse * response, NSError * error) {
        if (!error) {
            DBUser * currentUser = response.result;
            [self setCurrentUser:currentUser];
        } else {
            
        }
    }];
}

@end
