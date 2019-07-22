//
//  HomeViewController.m
//  AskandLearn
//
//  Created by clairec on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "PFObject.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchUsers];
    self.index = [@0 unsignedIntegerValue];
    [self reloadData];
}

- (void)fetchUsers
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" notEqualTo:PFUser.currentUser.username];
    self.cards = [query findObjects];
}

-(void)reloadData
{
    PFUser *temp = self.cards[self.index];
    self.nameField.text = temp.username;
}


- (IBAction)tapLike:(id)sender
{
    self.index += 1;
    [self reloadData];
}

- (IBAction)tapDislike:(id)sender
{
    self.index += 1;
    [self reloadData];
}

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
            appDelegate.window.rootViewController = loginVC;
        }
    }];
}

@end
