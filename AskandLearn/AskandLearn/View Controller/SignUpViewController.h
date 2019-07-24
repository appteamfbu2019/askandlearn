//
//  SignUpViewController.h
//  AskandLearn
//
//  Created by estherb on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController<FBSDKLoginButtonDelegate>
@property (strong, nonatomic) IBOutlet UIView *fbLoginButtonView;

@end

NS_ASSUME_NONNULL_END
