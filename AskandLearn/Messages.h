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

@property (nonatomic, strong) PFUser *user1;
@property (nonatomic, strong) PFUser *user2;
@property (nonatomic, strong) NSString *status;

+(Messages *)removeTag:(PFUser *)user remove:(NSDictionary *)tagObject;
+(Messages *)newTag: (PFUser *)user setTag:(NSDictionary *)tagObject;

@end

NS_ASSUME_NONNULL_END

