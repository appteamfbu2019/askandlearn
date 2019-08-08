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

@interface ProfileViewController () <UITextViewDelegate>
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getProfile];
    [self.refreshControl endRefreshing];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapEditProfile:(id)sender {
    [self performSegueWithIdentifier:@"EditSegue" sender:nil];
}

- (void)getProfile {
    PFQuery *query = [PFQuery queryWithClassName:@"profile"];
    [query getObjectInBackgroundWithId:@"objectId" block:^(PFObject *profile, NSError *error){
    if (!error) {
        profile[@"name"] = self.nameBox.text;
        profile[@"profession"] = self.professionBox.text;
        profile[@"major"] = self.majorBox.text;
        profile[@"profilePic"] = self.profileImage.image;
        profile[@"backgroundPic"] = self.backgroundImage.image;
        [self.refreshControl endRefreshing];
    } else {
        NSLog(@"Information was not displayed");
    }
        }];
}

@end
