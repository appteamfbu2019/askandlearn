//
//  Profile.h
//  AskandLearn
//
//  Created by unauthorize on 8/8/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "PFObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Profile : PFObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profession;
@property (nonatomic, strong) NSString *major;
@property (nonatomic, strong) PFUser *user;
//@property (nonatomic, strong) UIImage *profilePic;
//@property (nonatomic, strong) UIImage *backgroundPic;


@end

NS_ASSUME_NONNULL_END
