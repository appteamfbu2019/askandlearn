//
//  ChatCellTableViewCell.h
//  AskandLearn
//
//  Created by unauthorize on 7/25/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *messageView;

@end

NS_ASSUME_NONNULL_END
