//
//  Match.h
//  AskandLearn
//
//  Created by clairec on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Match : NSObject

@property (nonatomic, strong) User *user1; //the user connected with the match card
@property (nonatomic, strong) User *user2;
@property (nonatomic) NSInteger percentMatch; //how close the match is to account user's specified prefs

@end


