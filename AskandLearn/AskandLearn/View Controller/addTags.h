//
//  addTags.h
//  AskandLearn
//
//  Created by clairec on 7/29/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Token;

@protocol TagsDelegate <NSObject>
-(void)assignTags:(NSArray *)tags;
@end

typedef void (^AddTagsCompletionBlock)(BOOL success, NSArray *members, NSError *error);

@interface addTags : UIViewController
@property (weak) id <TagsDelegate> delegate;
@property (nonatomic, copy) AddTagsCompletionBlock addTagsBlock;
@property (nonatomic) Token *selectedToken;
- (IBAction)submittingTags:(id)sender;
- (void) configureAddTagsView: (NSArray *) tags;

@end

NS_ASSUME_NONNULL_END
