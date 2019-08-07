//
//  Switch.h
//  AskandLearn
//
//  Created by clairec on 8/6/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "PFObject.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Switch : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic) BOOL isLearner;
@property (nonatomic) BOOL isTeacher;

+ (void) switchChanged: (PFUser *)user withLearnStatus:(BOOL)learn withTeachStatus:(BOOL)teach;
+ (void) newSwitch: (PFUser *)user;

@end

NS_ASSUME_NONNULL_END
