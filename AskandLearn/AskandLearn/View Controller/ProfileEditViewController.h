//
//  ProfileEditViewController.h
//  AskandLearn
//
//  Created by estherb on 7/30/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileEditViewController : UIViewController
- (IBAction)didTapSaveProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *professionText;
@property (weak, nonatomic) IBOutlet UITextField *professionTextField;
@property (weak, nonatomic) IBOutlet UILabel *majorText;
@property (weak, nonatomic) IBOutlet UITextField *majorTextField;
@property (weak, nonatomic) IBOutlet UILabel *profilePicText;
- (IBAction)didTapProfileUpload:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
- (IBAction)didTapImageUpload:(id)sender;

@end

NS_ASSUME_NONNULL_END
