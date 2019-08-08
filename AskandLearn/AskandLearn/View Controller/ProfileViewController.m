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
#import "Profile.h"

@interface ProfileViewController () <UITextViewDelegate>
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapEditProfile:(id)sender {
    [self performSegueWithIdentifier:@"EditSegue" sender:nil];
}

- (IBAction)didTapScreen:(id)sender {
    [self getProfile];
    [self.view setNeedsLayout];
}

- (void)getProfile {
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"user"];
    query.limit = 1;
    NSLog(@"%@", [[PFUser currentUser] objectId]);
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(objects){
            Profile *profile = objects[0];
            self.nameBox.text = profile[@"name"];
            self.professionBox.text = profile[@"profession"];
            self.majorBox.text = profile[@"major"];
            //self.profileImage.image = profile[@""];
            //self.backgroundImage.image = profile[@""];
        }
    }];
}

@end
