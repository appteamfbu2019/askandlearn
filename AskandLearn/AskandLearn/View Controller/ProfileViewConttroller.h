//
//  ProfileViewConttroller.h
//  Instagram
//
//  Created by estherb on 7/11/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PostCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController // <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *editButton;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END



