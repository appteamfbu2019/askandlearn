//
//  User.h
//  AskandLearn
//
//  Created by clairec on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "PFObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSMutableArray *matches;
@property (nonatomic, strong) NSMutableArray *likes;
@property (nonatomic, strong) NSMutableArray *tags;

@end

NS_ASSUME_NONNULL_END
