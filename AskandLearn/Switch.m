//
//  Switch.m
//  AskandLearn
//
//  Created by clairec on 8/6/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "Switch.h"

@implementation Switch

@dynamic user;
@dynamic isLearner;
@dynamic isTeacher;

+ (nonnull NSString *)parseClassName {
    return @"Switch";
}

+ (void) switchChanged: (PFUser *)user withLearnStatus:(BOOL)learn withTeachStatus:(BOOL)teach{
    PFQuery *query = [PFQuery queryWithClassName:@"Switch"];
    [query includeKey:@"isLearner"];
    [query includeKey:@"isTeacher"];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *switchObj, NSError *error){
        if (switchObj != nil){
            for (Switch *sw in switchObj){
                if ([sw.user.objectId isEqualToString:PFUser.currentUser.objectId]){
                    sw[@"isLearner"] = [NSNumber numberWithBool:learn];
                    sw[@"isTeacher"] = [NSNumber numberWithBool:teach];
                    [sw saveInBackgroundWithBlock:nil];
                    NSLog(@"islearner %d", sw.isLearner);
                    NSLog(@"updated");
                }
            }
        }
    }];
}

+ (void) newSwitch: (PFUser *)user {
    Switch *newSwitchObj = [Switch new];
    newSwitchObj.user = user;
    newSwitchObj.isLearner = YES;
    newSwitchObj.isTeacher = YES;
    
    [newSwitchObj saveInBackgroundWithBlock:nil];
}

@end
