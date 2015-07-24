//
//  RegisterViewController.h
//  BlueLightsV2
//
//  Created by Alex Krush on 5/27/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.m"
#import <MBProgressHUD.h>
#import <AFNetworking.h>

#import "SignUpButton.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *logoView;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backNextConstraint;

- (IBAction)nextAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *nameView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstFieldLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstFieldTrailingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHorizontalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailHorizontalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordHorizontalConstraint;

@property (weak, nonatomic) IBOutlet SignUpButton *nextButton;
@property (weak, nonatomic) IBOutlet SignUpButton *backButton;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end
