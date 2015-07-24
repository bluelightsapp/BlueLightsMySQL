//
//  RegisterConfirmViewController.h
//  BlueLightsV2
//
//  Created by Alex Krush on 5/31/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.m"
#import <AFNetworking.h>
#import <MBProgressHUD.h>

@interface RegisterConfirmViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@property (strong, nonatomic) NSString * phone;
@property (strong, nonatomic) NSString * firstName;
@property (strong, nonatomic) NSString * lastName;
@property (strong, nonatomic) NSString * email;
@property (strong, nonatomic) NSString * password;
@property BOOL passwordHidden;

- (IBAction)showAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
- (IBAction)backAction:(id)sender;
- (IBAction)finishAction:(id)sender;

@end
