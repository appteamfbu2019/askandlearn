//
//  Action.m
//  AskandLearn
//
//  Created by clairec on 7/19/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "Action.h"
#import "Parse/Parse.h"
#import "PFObject.h"

@implementation Action

@dynamic receivedLike;
@dynamic sentLike;
@dynamic receivedDislike;
@dynamic sentDislike;
@dynamic sender;
@dynamic receiver;

+ (nonnull NSString *)parseClassName {
    return @"Action";
}

+ (void) likeAction: (PFUser *)user1 withUser: (PFUser *)user2 {
    
    Action *newAction = [Action new];
    
    newAction.sentLike = user1;
    newAction.receivedLike = user2;
    newAction.sender = user1;
    newAction.receiver = user2;
    
    [newAction saveInBackgroundWithBlock: nil];
}

+ (void) dislikeAction: (PFUser *)user1 withUser: (PFUser *)user2 {
    
    Action *newAction = [Action new];
    
    newAction.sentDislike = user1;
    newAction.receivedDislike = user2;
    newAction.sender = user1;
    newAction.receiver = user2;
    
    [newAction saveInBackgroundWithBlock: nil];
}

@end
