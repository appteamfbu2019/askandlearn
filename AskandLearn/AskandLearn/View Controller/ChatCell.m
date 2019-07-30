//
//  ChatCellTableViewCell.m
//  AskandLearn
//
//  Created by estherb on 7/29/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell () <UITableViewDelegate>

@end

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
