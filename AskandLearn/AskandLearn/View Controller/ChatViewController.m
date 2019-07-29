//
//  ChatViewController.m
//  AskandLearn
//
//  Created by unauthorize on 7/23/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "ChatViewController.h"
#import "Parse/Parse.h"
#import "MessageViewController.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *displayMessages;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Successful Segue");
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Do any additional setup after loading the view.
    //[self onTimer];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"likesCount > 100"];
    PFQuery *query = [PFQuery queryWithClassName:@"AskAndLearn" predicate:predicate];
    [query orderByDescending:@"CreatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *dummies, NSError *error) {
        if (dummies != nil){
            self.displayMessages = (NSMutableArray *)dummies;
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.tableView reloadData];
}


/*-(void)onTimer{
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    
}*/

-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.displayMessages.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapSend:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message"];
    
    chatMessage[@"text"] = self.messageTextField.text;
    
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.messageTextField.text = nil;
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    [self.displayMessages insertObject:(chatMessage) atIndex:0];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
