//
//  Messages.h
//  AskandLearn
//
//  Created by estherb on 8/6/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "PFObject.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Messages : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *sender;
@property (nonatomic, strong) PFUser *receiver;
@property (nonatomic, strong) NSString *messageText;
@property (nonatomic, strong) NSString *timeNow;

+(void) sendMessage: (PFUser *)user1 withUser: (PFUser *)user2 withText: (NSString *) messageText withTime: (NSString *) timeNow;
+(void) receiveMessage: (PFUser *)user1 withUser: (PFUser *)user2 withText: (NSString *) messageText withTime: (NSString *) timeNow;


@end

NS_ASSUME_NONNULL_END

