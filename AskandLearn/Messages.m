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

+ (nonnull NSString *)parseClassName {
    return @"Messages";
}

+ (void) sendMessage: (PFUser *)user1 withUser: (PFUser *)user2 withText: (NSString *) messageText {
    
    Messages *newMessage = [Messages new];
    
    newMessage.sender = user1;
    newMessage.receiver = user2;
    newMessage.messageText = messageText;
    
    [newMessage saveInBackgroundWithBlock: nil];
}

+ (void) receiveMessage: (PFUser *)user1 withUser: (PFUser *)user2 {
    
    Messages *newMessage = [Messages new];
    
    newMessage.sender = user1;
    newMessage.receiver = user2;
    newMessage.messageText = user1;
    
    
    [newMessage saveInBackgroundWithBlock: nil];
}

@end
