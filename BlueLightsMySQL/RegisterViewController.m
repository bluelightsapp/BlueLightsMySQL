//
//  RegisterViewController.m
//  BlueLightsV2
//
//  Created by Alex Krush on 5/27/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterConfirmViewController.h"

@interface RegisterViewController () {
    int fieldPage;
    MBProgressHUD * HUD;
    CGFloat topConstraintOriginal;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-bg"]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [backgroundImageView setFrame:self.view.frame];
    [backgroundImageView setClipsToBounds:YES];
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    self.backNextConstraint.constant = - self.view.frame.size.width + 16;
    self.nameHorizontalConstraint.constant = 8;
    self.nameYConstraint.constant = 0;
    self.emailHorizontalConstraint.constant = 8;
    self.emailYConstraint.constant = 0;
    self.passwordHorizontalConstraint.constant = 8;
    self.passwordYConstraint.constant = 0;
    
    topConstraintOriginal = self.topConstraint.constant;
    [self registerForKeyboardNotifications];
    
    fieldPage = 0;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD setDetailsLabelFont:[UIFont systemFontOfSize:18]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextAction:(id)sender {
    if (fieldPage == 0) {
        if ([self.phoneField.text isEqualToString:@""]) {
            [HUD setMode:MBProgressHUDModeText];
            [HUD setDetailsLabelText:@"Please enter your phone number."];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        } else {
            [self checkPhone];
        }
    } else if (fieldPage == 1) {
        if ([self.firstNameField.text isEqualToString:@""] || [self.lastNameField.text isEqualToString:@""]) {
            [HUD setMode:MBProgressHUDModeText];
            [HUD setDetailsLabelText:@"Please enter your name."];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        } else {
            [self nextPage];
        }
    } else if (fieldPage == 2) {
        if ([self.emailField.text isEqualToString:@""]) {
            [HUD setMode:MBProgressHUDModeText];
            [HUD setDetailsLabelText:@"Please enter your email address."];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        } else {
            [self checkEmail];
        }
    } else if (fieldPage == 3) {
        if ([self.passwordField.text isEqualToString:@""]) {
            [HUD setMode:MBProgressHUDModeText];
            [HUD setDetailsLabelText:@"Please enter a password."];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        } else {
            [self nextPage];
        }
    } else {

    }
}

- (void)nextPage {
    if (fieldPage == 0) {
        self.backNextConstraint.constant = 8;
        [self.descriptionLabel setHidden:YES];
    }
    
    if (fieldPage == 3) {
        RegisterConfirmViewController * vc = (RegisterConfirmViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterConfirmView"];
        [self.navigationController pushViewController:vc animated:YES];
        [vc setPhone:self.phoneField.text];
        [vc setFirstName:self.firstNameField.text];
        [vc setLastName:self.lastNameField.text];
        [vc setEmail:self.emailField.text];
        [vc setPassword:self.passwordField.text];
        
        return;
    }
    
    fieldPage++;
    
    self.firstFieldLeadingConstraint.constant -= (self.view.frame.size.width - 8);
    self.firstFieldTrailingConstraint.constant += (self.view.frame.size.width - 8);
    
    if (fieldPage == 3)
        [self.nextButton setTitle:@"Finish" forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.4 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self.view layoutIfNeeded];
    }];
    
    [self updateCurrentTextField];
}

- (IBAction)backAction:(id)sender {
    if (fieldPage-- == 1) {
        self.backNextConstraint.constant = - self.view.frame.size.width + 16;
        [self.descriptionLabel setHidden:NO];
    }
    
    self.firstFieldLeadingConstraint.constant += (self.view.frame.size.width - 8);
    self.firstFieldTrailingConstraint.constant -= (self.view.frame.size.width - 8);
    
    if (fieldPage == 2)
        [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.4 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self.view layoutIfNeeded];
    }];
    
    [self updateCurrentTextField];
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateCurrentTextField {
    switch (fieldPage) {
        case 0:
            [self.phoneField becomeFirstResponder];
            break;
            
        case 1:
            [self.firstNameField becomeFirstResponder];
            break;
            
        case 2:
            [self.emailField becomeFirstResponder];
            break;
            
        case 3:
            [self.passwordField becomeFirstResponder];
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.firstNameField) {
        [self.lastNameField becomeFirstResponder];
    } else {
        [self nextAction:nil];
    }
    
    return YES;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

//- (void)keyboardWillShow:(NSNotification*)aNotification {
//    if (self.view.frame.size.height <= 500.0) {
//        self.logoView.alpha = 0.0;
//        self.topConstraint.constant = topConstraintOriginal - 64 - 32;
//        [HUD setYOffset:-64-32];
//        
//        [UIView animateWithDuration:1.0 animations:^{
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//            
//            [self.view layoutIfNeeded];
//        }];
//    }
//}
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
//    if (self.view.frame.size.height <= 500.0) {
//        self.logoView.alpha = 1.0;
//        self.topConstraint.constant = topConstraintOriginal;
//        
//        [UIView animateWithDuration:1.0 animations:^{
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//            
//            [self.view layoutIfNeeded];
//        }];
//    }
//}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
//    self.topConstraint.constant = -self.topView.frame.size.height;
    self.bottomConstraint.constant = kbSize.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
//    self.topConstraint.constant = 0;
    self.bottomConstraint.constant = 16;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)checkPhone {
    NSString * urlString = [NSString stringWithFormat:@"%@%@", baseUrlString, @"register/phone"];
    NSDictionary * params = @{@"phone": self.phoneField.text};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"code"] isEqualToString:@"success"]) {
            [self nextPage];
        } else {
            [HUD setMode:MBProgressHUDModeText];
            [HUD setDetailsLabelText:responseObject[@"message"]];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)checkEmail {
    NSString * urlString = [NSString stringWithFormat:@"%@%@", baseUrlString, @"register/email"];
    NSDictionary * params = @{@"email": self.emailField.text};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"code"] isEqualToString:@"success"]) {
            [self nextPage];
        } else {
            [HUD setMode:MBProgressHUDModeText];
            [HUD setDetailsLabelText:responseObject[@"message"]];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
