//
//  User.m
//  AskandLearn
//
//  Created by clairec on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "User.h"

@implementation User

- (void)addLike: (User *)like {
    [self.likes addObject:like];
    for (User *lk in like.likes){
        if (lk == self){
            NSArray* match = [NSArray arrayWithObjects:self, lk, nil];
            NSSet* setMatch = [NSSet setWithArray:match];
            [self.matches addObject:setMatch];
            [self.likes removeObject:like];
            [like.likes removeObject:self];
        }
    }
}

-(void)addTag: (NSString *)tag {
    [self.tags addObject:tag];
}


@end
