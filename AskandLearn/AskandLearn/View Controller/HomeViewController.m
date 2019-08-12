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
//    self.view.window.rootViewController = self;
//    NSLog(@"%@", self.view.window.rootViewController);
    
    //    //[self.loadingAlert becomeFirstResponder];
//        self.view.window.rootViewController = self.loadingAlert;
    //    [self presentViewController:self.loadingAlert animated:YES completion: nil];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"alertcontroller?");
//        self.loadingAlert = [UIAlertController
//                             alertControllerWithTitle:@"Loading..." message: @"Please wait..." preferredStyle:UIAlertControllerStyleAlert];
//        [self presentViewController:self.loadingAlert animated:YES completion:nil];
//    });
    self.loadingAlert = [UIAlertController
                         alertControllerWithTitle:@"Loading..." message: @"Please wait..." preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:self.loadingAlert animated:YES completion:nil];
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
            NSLog(@"trying to log out");
            [self dismissViewControllerAnimated:YES completion:^{NSLog(@"logged out dismiss");}];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            appDelegate.window.rootViewController = loginVC;
            
        }
//        if (![self.loadingAlert isBeingDismissed]){
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
        
    }];
}

- (void) scoreAlert: (double) score {
    NSLog(@"score: %f", score);
    score = score * 100.0;
    int newScore = (int)floorf(score);
    //score = (int)floorf(score);
    NSLog(@"score after %f", score);
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Matchscore for this user is..." message: [NSString stringWithFormat:@"%d%%", newScore] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion: nil];
}

-(void) removeLoading {
    //[self dismissViewControllerAnimated:YES completion:nil];
    if (![self.presentedViewController isBeingDismissed]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
