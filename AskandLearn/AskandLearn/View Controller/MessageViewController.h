//
//  MessageViewController.h
//  AskandLearn
//
//  Created by unauthorize on 7/17/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageViewController : UIViewController
- (IBAction)didTapCompose:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *messageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

NS_ASSUME_NONNULL_END
