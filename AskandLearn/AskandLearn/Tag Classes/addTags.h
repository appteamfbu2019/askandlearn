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

- (IBAction)submittingTags:(id)sender;

@property (nonatomic, copy) AddTagsCompletionBlock addTagsBlock;
@property (nonatomic) Token *selectedToken;

- (void) configureAddTagsView: (NSArray *) tags;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

NS_ASSUME_NONNULL_END
