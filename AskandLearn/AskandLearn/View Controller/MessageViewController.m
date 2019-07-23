//
//  MessageViewController.m
//  AskandLearn
//
//  Created by unauthorize on 7/17/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"

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
    
    [self featchArray];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(featchArray)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
}

-(void)featchArray {
    NSMutableArray *theDummy = [NSMutableArray new];
    for (int i =0; i < 10; i++) {
        [theDummy addObject:@"Hello"];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dummy.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    MessageViewController *cell = (MessageViewController *) [tableView dequeueReusableCellWithIdentifier:@"MessageViewController"];
    
    NSDictionary *dummy = self.dummy[indexPath.row];
    //cell.messageView.text = dummy[@"Hello"];
    
    return cell;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationVnfhfdnkfjvflijduuglhvrnfrurgntrviewController].
    // Pass the selected object to the new view controller.
}
*/

@end
