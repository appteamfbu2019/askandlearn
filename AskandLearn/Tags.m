//
//  Tags.m
//  AskandLearn
//
//  Created by clairec on 8/2/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "Tags.h"
#import "Parse.h"

@implementation Tags

@dynamic tag;
@dynamic status;
@dynamic user;

+ (nonnull NSString *)parseClassName {
    return @"Tags";
}

+(Tags *)newTag: (PFUser *)user setTag:(NSDictionary *)tagObject{
    Tags *newTag = [Tags new];
    newTag.user = user;
    newTag.tag = tagObject;
    newTag.status = @"adding";
    [newTag saveInBackgroundWithBlock:nil];
    return newTag;
}

+(Tags *)removeTag:(PFUser *)user remove:(NSDictionary *)tagObject{
    Tags *newTag = [Tags new];
    newTag.user = user;
    newTag.tag = tagObject;
    newTag.status = @"removing";
    [newTag saveInBackgroundWithBlock:nil];
    return newTag;
}

@end
