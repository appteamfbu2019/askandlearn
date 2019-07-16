//
//  LoginViewController.m
//  AskandLearn
//
//  Created by estherb on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if ([self.usernameField.text isEqual:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"No username inserted"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *usernameAlert = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                              }];
        [alert addAction:usernameAlert];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    }
    else if ([self.passwordField.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"No password inserted"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *passwordAlert = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }];
        [alert addAction:passwordAlert];
        
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
    else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
            } else {
                NSLog(@"User logged in successfully");
                
                // display view controller that needs to shown after successful login
                [self performSegueWithIdentifier:@"loggedInSegue" sender:nil];
            }
        }];
    }
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}
- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
