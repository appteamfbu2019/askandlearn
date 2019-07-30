//
//  CategoriesViewController.h
//  AskandLearn
//
//  Created by clairec on 7/29/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Categories;

typedef void (^SelectedCategoryCompletionBlock)(BOOL success, NSDictionary *category, NSError *error);
typedef void (^DeselectedCategoryCompletionBlock)(BOOL success, NSDictionary *category, NSError *error);
typedef void (^DidScrollBlock)(void);

@interface CategoriesViewController : UIViewController

@property (nonatomic, copy) DidScrollBlock didScrollBlock;

+ (id)categoriesListController;
- (void)searchCategory: (NSString *) categoryName completion:(SelectedCategoryCompletionBlock)block;
- (void)searchCategory: (NSString *) categoryName addedCategories: (NSArray *)addedCategories withSelected:(SelectedCategoryCompletionBlock)selectedCategoryBlock deselectedBlock:(DeselectedCategoryCompletionBlock)deselectedBlock;
-(void)resetCategoryList;

@end

NS_ASSUME_NONNULL_END
