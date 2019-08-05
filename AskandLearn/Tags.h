//
//  Tags.h
//  AskandLearn
//
//  Created by clairec on 8/2/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "PFObject.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tags : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSDictionary *tag;
@property (nonatomic, strong) NSString *status;

+(Tags *)removeTag:(PFUser *)user remove:(NSDictionary *)tagObject;
+(Tags *)newTag: (PFUser *)user setTag:(NSDictionary *)tagObject;


@end

NS_ASSUME_NONNULL_END
