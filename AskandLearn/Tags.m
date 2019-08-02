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
@dynamic user;

+ (nonnull NSString *)parseClassName {
    return @"Tags";
}

+(Tags *)newTag: (PFUser *)user setTag:(NSDictionary *)tagObject{
    Tags *newTag = [Tags new];
    newTag.user = user;
    newTag.tag = tagObject;
    [newTag saveInBackgroundWithBlock:nil];
    return newTag;
}

//+(void)addTag:(NSObject *)object{
//    Tags *newTag = [Tags new];
//    [newTag setByAddingObject:object];
//    [newTag saveInBackgroundWithBlock:nil];
//}

//-(void)removeTags:(NSArray *)objects{
////    for (NSObject *tg in objects){
////        [self.tags :tg];
////    }
////    [self saveInBackgroundWithBlock:nil];
//}
//
//-(void)setUser:(PFUser *)user{
//    self.user = user;
//    [self saveInBackgroundWithBlock:nil];
//}

@end
