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

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //use parse query to get a list of all the users on the server
    [self fetchUsers];
    //need to keep track of an index for tapping through the potential matches
    self.index = 0;
    //for matching button tap -> add to list of User's matches
}

-(void)fetchUsers{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    query.limit = 20;
    //[query whereKey:@"username" notEqualTo:PFUser.currentUser];
    // fetch data asynchronously
    NSLog(@"fetching");
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            self.cards = users;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



- (IBAction)tapLike:(id)sender {
    self.index += 1;
    //add to a mutable array of currentuser likes
    //in server, store likes of other users
    //run through the arrays and form 'matches'
    //delete nonmatches
}

- (IBAction)tapDislike:(id)sender {
    self.index += 1;
}

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
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
