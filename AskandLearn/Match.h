//
//  Match.h
//  AskandLearn
//
//  Created by estherb on 7/31/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "User.h"
#import "PFObject.h"

@interface Match : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *person1;
@property (nonatomic, strong) PFUser *person2;
@property (nonatomic, strong) NSNumber *percentMatch;

+ (void) matchFormed: (PFUser *)user1 withUser: (PFUser *)user2;

@end

