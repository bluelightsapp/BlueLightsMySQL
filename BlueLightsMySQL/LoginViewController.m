//
//  LoginViewController.m
//  BlueLightsV2
//
//  Created by Alex Krush on 5/28/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import "LoginViewController.h"
#import "APIClient.h"
#import "constants.m"
#import "DBLogin.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MainNavigationController.h"

@interface LoginViewController () {
    BOOL signUpHidden;
    MBProgressHUD * HUD;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-bg"]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [backgroundImageView setFrame:self.view.frame];
    [backgroundImageView setClipsToBounds:YES];
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD setDetailsLabelFont:[UIFont systemFontOfSize:18]];
    
    self.signUpVerticalConstraint.constant = 0;
    
    self.logoView.alpha = 0;
    [self.sloganLabel setFrame:CGRectMake(-self.view.frame.size.width,
                                         self.sloganLabel.frame.origin.y,
                                         self.sloganLabel.frame.size.width,
                                         self.sloganLabel.frame.size.height)];
    
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view layoutIfNeeded];
        self.logoView.alpha = 1.0;
    } completion:nil];
    
    self.loginVerticalConstraint.constant = -self.view.frame.size.height;
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)showLogin {
    if (signUpHidden) {
        self.loginVerticalConstraint.constant = -self.view.frame.size.height;
        self.signUpVerticalConstraint.constant = 0;
        [self.loginButton setTitle:@"Already have an account? Log in" forState:UIControlStateNormal];
    } else {
        self.loginVerticalConstraint.constant = 0;
        self.signUpVerticalConstraint.constant = -self.view.frame.size.height;
        [self.loginButton setTitle:@"Need to sign up?" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
    signUpHidden = !signUpHidden;
}

- (IBAction)loginAction:(id)sender {
    NSDictionary * params = @{@"phone": self.phoneField.text,
                              @"password": self.passwordField.text};
    
    APIClient * apiClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
    
    [apiClient POST:@"login" parameters:params completion:^(OVCResponse * response, NSError * error) {
        if (!error) {
            NSLog(@"response: %@", response);
            DBLogin * login = response.result;
            if ([login.code isEqualToString:@"success"]) {
                MainNavigationController * mnc = (MainNavigationController *)self.navigationController;
                [mnc loginUser:login.user];
            } else {
                [HUD setMode:MBProgressHUDModeText];
                [HUD setDetailsLabelText:login.message];
                [HUD show:YES];
                [HUD hide:YES afterDelay:1.0];
            }
        } else {
            NSLog(@"error: %@", error);
            [HUD setMode:MBProgressHUDModeText];
            [HUD setDetailsLabelText:@"Unable to connect."];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        }
    }];
}

- (IBAction)showLoginAction:(id)sender {
    [self.view endEditing:YES];
    [self showLogin];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.topConstraint.constant = -self.topView.frame.size.height;
    self.bottomConstraint.constant = kbSize.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.topConstraint.constant = 0;
    self.bottomConstraint.constant = 16;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

@end
