//
//  ChatViewController.m
//  AskandLearn
//
//  Created by estherb on 7/29/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "ChatViewController.h"
#import "Parse.h"
#import "ChatCell.h"

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIButton *bacKButton;
@property (strong,nonnull) NSArray *messageArrary;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mytableView.dataSource = self;
    self.mytableView.rowHeight = UITableViewAutomaticDimension;
    [self Refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)sendTapped:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2018"];
    chatMessage[@"text"] = self.messageField.text;
    chatMessage[@"user"] = PFUser.currentUser;
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    self.messageField.text = @"";
}

-(IBAction)backTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)Refresh{
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(Refresh) userInfo:nil repeats:true];
    PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2018"];
    query.limit = 20;
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.messageArrary = posts;
            [self.mytableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    PFObject *chatmessage = self.messageArrary[indexPath.row];
    PFUser *user = chatmessage[@"user"];
    self.messageField.text = chatmessage[@"text"];
    
    if(user != nil){
        cell.usernameLabel.text = user.username;
        cell.messageLabel.text = chatmessage[@"text"];
    } else{
        cell.usernameLabel.text = @"🤖";
        cell.messageLabel.text = @"Error getting message";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArrary.count;
}

@end

