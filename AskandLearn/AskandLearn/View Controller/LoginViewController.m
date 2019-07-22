//
//  LoginViewController.m
//  Created by estherb on 7/17/19.

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loginUser
{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if ([self.usernameTextField.text isEqual:@""]) {
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
    } else if ([self.passwordTextField.text isEqual:@""]) {
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
    } else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
            } else {
                NSLog(@"User logged in successfully");
                [self performSegueWithIdentifier:@"loggedInSegue" sender:nil];
            }
        }];
    }
}

- (IBAction)didTapLogin:(id)sender
{
    [self loginUser];
}

- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
}

@end
