//
//  LoginViewController.h
//  BlueLightsV2
//
//  Created by Alex Krush on 5/28/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import <AFNetworking.h>

#import "SignUpButton.h"

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *sloganLabel;
@property (weak, nonatomic) IBOutlet SignUpButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUpVerticalConstraint;

- (IBAction)loginAction:(id)sender;
- (IBAction)showLoginAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
