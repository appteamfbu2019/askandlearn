//
//  MessageViewController.m
//  AskandLearn
//
//  Created by unauthorize on 7/17/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "UIImageView+AFNetworking.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "Parse/Parse.h"

@interface MessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic) NSMutableArray *dummy;
@property(weak,nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MessageCell"];
    
    [self featchArray];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(featchArray)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
}

-(void)featchArray {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * dummies, NSError *error) {
        if (dummies != nil) {
            NSLog(@"Messages could appear if you had some");
            self.dummy = (NSMutableArray *) dummies;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            
        }else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    MessageViewController *cell = (MessageViewController *) [tableView dequeueReusableCellWithIdentifier:@"MessageViewController"];
//    
//    NSDictionary *dummy = self.dummy[indexPath.row];
//    cell.messageView.text = dummy[@"Hello"];
//    
//    return cell;
//    
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationVnfhfdnkfjvflijduuglhvrnfrurgntrviewController].
    // Pass the selected object to the new view controller.
    
}


- (IBAction)didTapCompose:(id)sender {
    [self performSegueWithIdentifier:@"MessageSegue" sender:nil];
    NSLog(@"Should be a Succesful Segue");
}

 @end

