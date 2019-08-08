//
//  userChatViewController.h
//  AskandLearn
//
//  Created by estherb on 8/5/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Match.h"

@interface userChatViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) Match *matchObj;

@end
