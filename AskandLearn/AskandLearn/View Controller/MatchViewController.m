//  Created by estherb on 7/30/19.
//  Copyright © 2019 estherb. All rights reserved.

#import "MatchViewController.h"
#import "Parse.h"
#import "MatchCell.h"
#import "Match.h"

@interface MatchViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (strong,nonnull) NSArray *matchArray;
@property (strong,nonnull) PFUser* person1;
@property (strong, nonnull) Match *match;
@end

@implementation MatchViewController
@synthesize person1 = currentUser;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mytableView.dataSource = self;
    self.mytableView.rowHeight = UITableViewAutomaticDimension;
    [self Refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)Refresh
{
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(Refresh)
                                                            userInfo:nil repeats:true];
    PFUser *user = PFUser.currentUser;
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Match"];
    [query1 whereKey:@"person1" equalTo:user];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Match"];
    [query2 whereKey:@"person2" equalTo:user];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *matches, NSError *error){
        if ([matches count] > 0) {
            self.matchArray = matches;
            [self.mytableView reloadData];
            NSLog(@"%@", matches);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell" forIndexPath:indexPath];
    PFObject *match = self.matchArray[indexPath.row];
    PFUser *user = nil;
    
    if (match[@"person1"] == PFUser.currentUser){
        user = match[@"person2"];
    }
    else{
        user = match[@"person1"];
    }
    
    PFQuery *queryUser = [PFUser query];
    [queryUser whereKey:@"objectId" equalTo:user.objectId];
    NSArray *userArray = [queryUser findObjects];
    
    if(userArray != nil){
        cell.usernameLabel.text = userArray[0][@"username"];
    } else{
        cell.usernameLabel.text = @"🤖";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.matchArray.count;
}

@end
