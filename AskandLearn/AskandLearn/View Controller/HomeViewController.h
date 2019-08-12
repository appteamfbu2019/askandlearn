//
//  HomeViewController.h
//  AskandLearn
//
//  Created by clairec on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "CardBackgroundView.h"
#import "CardView.h"


@interface HomeViewController : UIViewController <UIAlertViewDelegate>
- (void) alertPopUp: (PFUser *)user;
- (void) outOfCards;
- (void) scoreAlert: (double) score;
- (void) removeLoading;

@property (strong, nonatomic) UIAlertController *loadingAlert;

@end

