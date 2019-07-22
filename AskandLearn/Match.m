//
//  Match.m
//  AskandLearn
//
//  Created by clairec on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "Match.h"

@implementation Match

@dynamic person1;
@dynamic person2;
@dynamic percentMatch;

+ (nonnull NSString *)parseClassName {
    return @"Match";
}

+ (void) matchFormed: (PFUser *)user1 withUser: (PFUser *)user2 {
    
    Match *newMatch = [Match new];
    newMatch.person1 = user1;
    newMatch.person2 = user2;
    
    [newMatch saveInBackgroundWithBlock: nil];
}



@end
