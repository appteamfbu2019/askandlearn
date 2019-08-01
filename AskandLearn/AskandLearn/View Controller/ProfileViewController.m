//
//  ProfileViewController.m
//  AskandLearn
//
//  Created by unauthorize on 7/17/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileEditViewController.h"

@interface ProfileViewController ()
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapEditProfile:(id)sender {
    [self performSegueWithIdentifier:@"EditSegue" sender:nil];
}
@end
