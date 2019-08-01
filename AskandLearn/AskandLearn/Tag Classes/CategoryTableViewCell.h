//
//  CategoryTableViewCell.h
//  AskandLearn
//
//  Created by clairec on 7/29/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Categories;

@interface CategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryText;

//+ (id)categoryTableViewCell;

@end

NS_ASSUME_NONNULL_END
