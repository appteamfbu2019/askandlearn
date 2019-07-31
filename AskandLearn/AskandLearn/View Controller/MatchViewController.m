//
//  MatchViewController.m
//  AskandLearn
//
//  Created by estherb on 7/30/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "MatchViewController.h"
#import "Parse.h"
#import "MatchCell.h"
#import "Match.h"

@interface MatchViewController ()<UITableViewDataSource, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (strong,nonnull) NSArray *matchArrary;

@end

@implementation MatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mytableView.dataSource = self;
    self.mytableView.rowHeight = UITableViewAutomaticDimension;
    [self Refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)Refresh{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Refresh) userInfo:nil repeats:true];
    PFQuery *query = [PFQuery queryWithClassName:@"Matches"];
    [query whereKey:@"person1" equalTo:person1];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.matchArrary = posts;
            [self.mytableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell" forIndexPath:indexPath];
    PFObject *match = self.matchArrary[indexPath.row];
    PFUser *user = match[@"user"];
    
    if(user != nil){
        cell.usernameLabel.text = user.username;
    } else{
        cell.usernameLabel.text = @"🤖";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchArrary.count;
}

@end
