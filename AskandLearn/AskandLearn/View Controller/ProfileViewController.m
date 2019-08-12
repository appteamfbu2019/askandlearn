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

@interface ProfileViewController () <UITextViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getProfile];
    [self.view setNeedsLayout];
    self.profileImage.layer.cornerRadius = 10;
}

- (IBAction)didTapEditProfile:(id)sender {
    [self performSegueWithIdentifier:@"EditSegue" sender:nil];
}

- (IBAction)didTapRefresh:(id)sender {
    [self getProfile];
    [self.view setNeedsLayout];
}

- (void)getProfile {
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if([objects count] != 0){
            Profile *profile = objects[0];
            self.nameBox.text = profile[@"name"];
            self.professionBox.text = [NSString stringWithFormat:@"Profession: %@", profile[@"profession"]];
            self.majorBox.text = [NSString stringWithFormat: @"Major: %@", profile[@"major"]];
            self.bioBox.text = [NSString stringWithFormat: @"Bio: %@", profile[@"bio"]];
            [self getUIImageFromPic:profile[@"profilePic"]];
            [self getUIImageFromImage:profile[@"backgroundPic"]];
        }
        else {
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"You haven't set a profile yet." message: @"Set a profile using the button on the upper left!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion: nil];
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
