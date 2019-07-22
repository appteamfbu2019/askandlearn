//
//  HomeViewController.h
//  AskandLearn
//
//  Created by clairec on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

//@property (nonatomic, strong) NSArray *cards;
//@property NSInteger index;

@property (weak, nonatomic) IBOutlet UIImageView *profPicView;
@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UILabel *percentMatch;
@property (weak, nonatomic) IBOutlet UILabel *professionsField;
@property (weak, nonatomic) IBOutlet UILabel *skillsFIeld;

@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSArray *actions;

@end

NS_ASSUME_NONNULL_END
