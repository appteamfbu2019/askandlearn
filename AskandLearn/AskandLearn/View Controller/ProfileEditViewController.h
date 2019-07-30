//
//  ProfileEditViewController.h
//  AskandLearn
//
//  Created by unauthorize on 7/30/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileEditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileUploadView;
@property (weak, nonatomic) IBOutlet UIImageView *imageUploadView;
- (IBAction)didTapProfileButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *imagePic;
- (IBAction)didTapImageButton:(id)sender;

@end

NS_ASSUME_NONNULL_END
