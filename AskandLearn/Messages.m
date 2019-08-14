//
//  Messages.m
//  AskandLearn
//
//  Created by estherb on 8/6/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "Messages.h"
#import "Parse/Parse.h"
#import "PFObject.h"

@implementation Messages

@dynamic sender;
@dynamic receiver;
@dynamic messageText;
@dynamic timeNow;

+ (nonnull NSString *)parseClassName {
    return @"Messages";
}

+ (void) sendMessage: (PFUser *)user1 withUser: (PFUser *)user2 withText: (NSString *) messageText withTime:(nonnull NSString *)timeNow{
    
    Messages *newMessage = [Messages new];
    
    newMessage.sender = user1;
    newMessage.receiver = user2;
    newMessage.messageText = messageText;
    newMessage.timeNow = timeNow;
    
    [newMessage saveInBackgroundWithBlock: nil];
}

+ (void) receiveMessage: (PFUser *)user1 withUser: (PFUser *)user2 withText: (NSString *) messageText withTime:(nonnull NSString *)timeNow{
    
    Messages *newMessage = [Messages new];
    
    newMessage.sender = user1;
    newMessage.receiver = user2;
    newMessage.messageText = messageText;
    newMessage.timeNow = timeNow;
    
    [newMessage saveInBackgroundWithBlock: nil];
}

@end
