//
//  HomeViewController.h
//  AskandLearn
//
//  Created by clairec on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profPicView;
@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UILabel *percentMatch;
@property (weak, nonatomic) IBOutlet UILabel *professionsField;
@property (weak, nonatomic) IBOutlet UILabel *skillsField;

- (void) alertPopUp: (PFUser *)matchedUser;

@end

