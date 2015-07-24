//
//  RegisterConfirmViewController.m
//  BlueLightsV2
//
//  Created by Alex Krush on 5/31/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import "RegisterConfirmViewController.h"
#import "APIClient.h"
#import "DBRegister.h"
#import "DBUser.h"
#import "MainNavigationController.h"
//#import "TabBarViewController.h"

@implementation RegisterConfirmViewController {
    MBProgressHUD * HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-bg"]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [backgroundImageView setFrame:self.view.frame];
    [backgroundImageView setClipsToBounds:YES];
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    [self.phoneLabel setText:self.phone];
    [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName]];
    [self.emailLabel setText:self.email];
    
    self.passwordHidden = NO;
    [self showAction:nil];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD setDetailsLabelFont:[UIFont systemFontOfSize:18]];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)showAction:(id)sender {
    if (self.passwordHidden) {
        self.passwordHidden = NO;
        [self.passwordLabel setText:self.password];
        [self.showButton setTitle:@"Hide" forState:UIControlStateNormal];
    } else {
        self.passwordHidden = YES;
        [self.passwordLabel setText:[@"" stringByPaddingToLength: [self.password length] withString: @"*" startingAtIndex:0]];
        [self.showButton setTitle:@"Show" forState:UIControlStateNormal];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finishAction:(id)sender {
    NSDictionary * params = @{@"phone": self.phone,
                              @"first_name": self.firstName,
                              @"last_name": self.lastName,
                              @"email": self.email,
                              @"password": self.password};
    
    APIClient * apiClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
    
    [apiClient POST:@"register" parameters:params completion:^(OVCResponse * response, NSError * error) {
        NSLog(@"response: %@", response);
        if (!error) {
            DBRegister * registration = response.result;
            if ([registration.code integerValue] == 0) {
                MainNavigationController * mnc = (MainNavigationController *)self.navigationController;
                [mnc loginUser:registration.user];
            } else {
                [HUD setMode:MBProgressHUDModeText];
                [HUD setDetailsLabelText:registration.message];
                [HUD show:YES];
                [HUD hide:YES afterDelay:1.0];
            }
        } else {
            [HUD setMode:MBProgressHUDModeText];
            [HUD setDetailsLabelText:@"Unable to connect."];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        }
    }];
}

@end
