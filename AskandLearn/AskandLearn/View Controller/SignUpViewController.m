//
//  SignUpViewController.m
//  AskandLearn
//
//  Created by estherb on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//
#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import <linkedin-sdk/LISDK.h>
#import <LIALinkedInHttpClient.h>
#import <LIALinkedInApplication.h>
#import <AFHTTPRequestOperation.h>

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) LIALinkedInHttpClient *client;

- (IBAction)didTapSignUp:(id)sender;
- (IBAction)didTapLinkedInSignUp:(id)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _client = [self clientSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
                [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
            }
        }];
    }
}

- (IBAction)didTapSignUp:(id)sender
{
    [self registerUser];
}

- (IBAction)didTapLinkedInSignUp:(id)sender
{
    [self didTapConnectWithLinkedIn];
}

- (LIALinkedInHttpClient *)clientSettings
{
    LIALinkedInApplication *application = [LIALinkedInApplication
        applicationWithRedirectURL:@"https://api.linkedin.com"
                          clientId:@"78nu9x8lyew6e7"
                      clientSecret:@"tjXaGh42RUdA8o8z"
                             state:@"DCEEFWF45453sdffef424342"
                     grantedAccess:@[@"r_liteprofile",@"r_emailaddress"]];
    
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

- (void)didTapConnectWithLinkedIn
{
    [self.client getAuthorizationCode:^(NSString *code) {
        
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        }                   failure:^(NSError *error) {
            NSLog(@"Querying accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        
        NSLog(@"Authorization failed %@", error);
    }];
}

- (void)requestMeWithToken:(NSString *)accessToken
{
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,email-address,formatted-name,phonetic-last-name,location:(country:(code)),industry,distance,current-status,current-share,network,skills,phone-numbers,date-of-birth,main-address,positions:(title),educations:(school-name,field-of-study,start-date,end-date,degree,activities))?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        
        NSLog(@"current user %@", result);
        
    }        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
    }];
}

@end

