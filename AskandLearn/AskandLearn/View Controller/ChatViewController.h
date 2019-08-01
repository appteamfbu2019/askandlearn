//
//  ChatViewController.h
//  AskandLearn
//
//  Created by estherb on 7/29/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
- (IBAction)didTapSend:(id)sender;
- (IBAction)didTapBack:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

