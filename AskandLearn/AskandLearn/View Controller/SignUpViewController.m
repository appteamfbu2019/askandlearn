//
//  SignUpViewController.m
//  AskandLearn
//
//  Created by estherb on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//
#import "AccountViewController.h"
#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import "Switch.h"

//Frameworks
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


- (IBAction)didTapSignUp:(id)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"singapore.jpg"]];
    
    FBSDKLoginButton *loginButton= [[FBSDKLoginButton alloc] init];
    loginButton.delegate= self;
    loginButton.center = CGPointMake(self.view.center.x, self.view.center.y + 180);
    loginButton.permissions = @[@"public_profile", @"email"];
    [self.view addSubview:loginButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - FBSDKLoginButton Delegate Methods

- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(nullable FBSDKLoginManagerLoginResult *)result
              error:(nullable NSError *)error{
    
    if(error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    if (result.isCancelled) {
        NSLog(@"User cancelled the login.");
    } else if (result.declinedPermissions.count > 0){
        NSLog(@"User has declined the permissions");
    } else {
        //User logged in successfully.
        //Take user to next view
        AccountViewController *accountViewController = [[AccountViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"User logged Out.");
}

-(void)registerUser
{
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.usernameTextField.text;
    newUser.email = self.emailTextField.text;
    newUser.password = self.passwordTextField.text;
    
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
        
    } else if ([self.emailTextField.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"No email inserted"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *emailAlert = [UIAlertAction actionWithTitle:@"Ok"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                           }];
        [alert addAction:emailAlert];
        
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
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
                [Switch newSwitch:newUser];
                [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
            }
        }];
    }
}

- (IBAction)didTapSignUp:(id)sender
{
    [self registerUser];
}


@end

