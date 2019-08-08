//
//  ProfileViewController.h
//  AskandLearn
//
//  Created by unauthorize on 7/17/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameBox;
@property (weak, nonatomic) IBOutlet UILabel *professionBox;
@property (weak, nonatomic) IBOutlet UILabel *majorBox;
- (IBAction)didTapEditProfile:(id)sender;

@end

NS_ASSUME_NONNULL_END
