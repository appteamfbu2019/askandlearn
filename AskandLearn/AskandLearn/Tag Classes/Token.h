//
//  Token.h
//  AskandLearn
//
//  Created by clairec on 7/29/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Token : NSObject
@property (nonatomic, copy) NSString *idString;
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic) NSRange tokenRange;
@end

NS_ASSUME_NONNULL_END
