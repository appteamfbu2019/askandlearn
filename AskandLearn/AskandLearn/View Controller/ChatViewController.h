//
//  ChatViewController.h
//  AskandLearn
//
//  Created by unauthorize on 7/23/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController
- (IBAction)didTapSend:(id)sender;
- (IBAction)didTapBack:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

NS_ASSUME_NONNULL_END
