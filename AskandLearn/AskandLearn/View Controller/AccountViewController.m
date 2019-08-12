//
//  AccountViewController.m
//  AskandLearn
//
//  Created by estherb on 7/24/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "AccountViewController.h"
#import "SignUpViewController.h"

//Frameworks
#import <FBSDKCoreKit/FBSDKProfile.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <FBSDKGraphRequest.h>

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
  dispatch_async(dispatch_get_main_queue(), ^{
      [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
          
          if (profile){
              
              //get user's profile name
              self.navigationItem.title = [NSString stringWithFormat:@"Welcome, %@", profile.name];
              
              // get user's profile image
              NSURL *url = [profile imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(35,35)];
              UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
              
              UIView *profileVIew = [[UIView alloc] initWithFrame:CGRectMake(0,0,35,35 )];
              profileVIew.layer.cornerRadius = profileVIew.frame.size.width/2;
              profileVIew.clipsToBounds = YES;
              profileVIew.userInteractionEnabled = YES;
              UITapGestureRecognizer *gestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheet)];
              [profileVIew addGestureRecognizer:gestureRecognizer];
              
              UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
              [profileVIew addSubview:imageView];
              
              UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:profileVIew];
              self.navigationItem.rightBarButtonItem = buttonItem;
          }
      }];
  });
}

#pragma mark- Helper Methods

-(void)showActionSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cancel" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        
        //Take user back to signUpView
        SignUpViewController *signUpViewController = [[SignUpViewController alloc] initWithNibName:@"SignUpVIewController" bundle:nil];
        
        [self presentViewController:signUpViewController animated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];}

@end
                 
