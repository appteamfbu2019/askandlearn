//
//  Action.h
//  AskandLearn
//
//  Created by clairec on 7/19/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Action : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *receivedLike;
@property (nonatomic, strong) PFUser *sentLike;
@property (nonatomic, strong) PFUser *receivedDislike;
@property (nonatomic, strong) PFUser *sentDislike;
@property (nonatomic, strong) PFUser *sender;
@property (nonatomic, strong) PFUser *receiver;

+ (void) likeAction: (PFUser *)user1 withUser: (PFUser *)user2;
+ (void) dislikeAction: (PFUser *)user1 withUser: (PFUser *)user2;

@end

NS_ASSUME_NONNULL_END
