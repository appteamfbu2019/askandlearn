//
//  CategoryTableViewCell.m
//  AskandLearn
//
//  Created by clairec on 7/29/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "CategoryTableViewCell.h"

@interface CategoryTableViewCell ()

@end

@implementation CategoryTableViewCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

+ (id)categoryTableViewCell {
    CategoryTableViewCell *categoryCell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:nil options:nil] lastObject];
    
    return categoryCell;
}

- (void)prepareForReuse { //cleanup for custom cells
    [super prepareForReuse];
    self.categoryText.text = @"";
}

@end
