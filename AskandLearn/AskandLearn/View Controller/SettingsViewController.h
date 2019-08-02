//
//  SettingsViewController.h
//  AskandLearn
//
//  Created by clairec on 7/26/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewController : UIViewController

-(void)assignTags:(NSArray *)tags;
@property (weak, nonatomic) IBOutlet UIView *containerTags;
@property (nonatomic) NSInteger numberOfTags;


@end

NS_ASSUME_NONNULL_END
