//
//  ProfileViewController.m
//  AskandLearn
//
//  Created by unauthorize on 7/17/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileEditViewController.h"
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
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    query.limit = 1;
    NSLog(@"%@", [[PFUser currentUser] objectId]);
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(objects){
            Profile *profile = objects[0];
            NSLog(@"PROFILE %@", profile);
            self.nameBox.text = profile[@"name"];
            self.professionBox.text = profile[@"profession"];
            self.majorBox.text = profile[@"major"];
            self.bioBox.text = profile[@"bio"];
            NSLog(@"%@", profile[@"profilePic"]);
            [self getUIImageFromPic:profile[@"profilePic"]];
            [self getUIImageFromImage:profile[@"backgroundPic"]];
        }
    }];
}
-  (void)getUIImageFromPic: (PFFileObject * _Nullable)profilePic {
    NSData *imageData = [profilePic getData];
    UIImage *image = [UIImage imageWithData:imageData];
    self.profileImage.image = image;
}

- (void)getUIImageFromImage: (PFFileObject * _Nullable)backgroundPic {
    NSData *imageData = [backgroundPic getData];
    UIImage *image = [UIImage imageWithData:imageData];
    self.backgroundImage.image = image;
    
}

@end
