//
//  HomeViewController.m
//  AskandLearn
//
//  Created by clairec on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "User.h"
#import "PFObject.h"
#import "Action.h"
#import "Match.h"
#import "CardView.h"
#import "CardBackgroundView.h"

@interface HomeViewController () <UIAlertViewDelegate, AlertDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"loading home view controller");
    NSLog(@"%@", self.view.window.rootViewController);
    self.loadingAlert = [UIAlertController
                         alertControllerWithTitle:@"Loading..." message: @"Please wait..." preferredStyle:UIAlertControllerStyleAlert];
    //    //[self.loadingAlert becomeFirstResponder];
    //    self.view.window.rootViewController = self.loadingAlert;
    //    [self presentViewController:self.loadingAlert animated:YES completion: nil];
    [self.view.window.rootViewController presentViewController:self.loadingAlert animated:YES completion:nil];
    CardBackgroundView *draggableBackground = [[CardBackgroundView alloc]initWithFrame:self.view.frame];
    draggableBackground.delegate = self;
    [self.view addSubview:draggableBackground];
    

    
}

- (void) alertPopUp: (PFUser *)user{
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"You received a match!" message: [NSString stringWithFormat:@"Matched with %@", user.username] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion: nil];
}

- (void) outOfCards {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Out of cards!"
                                                                   message:@"Come back later:)" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            appDelegate.window.rootViewController = loginVC;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        if (![self.presentedViewController isBeingDismissed]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if (![self.presentedViewController isBeingDismissed]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void) scoreAlert: (double) score {
    
    score = score * 100.0;
    score = (int)floorf(score);
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Matchscore for this user is..." message: [NSString stringWithFormat:@"%lu%%", score] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion: nil];
}

-(void) removeLoading {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (![self.presentedViewController isBeingDismissed]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
