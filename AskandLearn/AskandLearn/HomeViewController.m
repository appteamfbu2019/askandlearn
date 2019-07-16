//
//  HomeViewController.m
//  AskandLearn
//
//  Created by clairec on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"

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
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    query.limit = 20;
    [query whereKey:@"author" notEqualTo:PFUser.currentUser];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            self.matches = users;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
