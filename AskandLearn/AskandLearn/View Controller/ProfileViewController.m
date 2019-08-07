//
//  ProfileViewController.m
//  AskandLearn
//
//  Created by unauthorize on 7/17/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileEditViewController.h"
#import "Parse/Parse.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (IBAction)didTapEditProfile:(id)sender {
    [self performSegueWithIdentifier:@"EditSegue" sender:nil];
}

- (void)getProfile {
    PFQuery *query = [PFQuery queryWithClassName:@"profile"];
    [query getObjectInBackgroundWithId:@"U1uBpDUq48" block:^(PFObject *profile, NSError *error) {
        if (!error) {
            profile[@"name"] = self.nameBox.text;
        } else {
        }
    }];
}

@end
