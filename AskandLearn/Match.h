//
//  Match.h
//  AskandLearn
//
//  Created by clairec on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "PFObject.h"

@interface Match : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *user1;
@property (nonatomic, strong) PFUser *user2;
@property (nonatomic, strong) NSNumber *percentMatch;


@end


