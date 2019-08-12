//  Created by estherb on 7/30/19.
//  Copyright © 2019 estherb. All rights reserved.

#import "MatchViewController.h"
#import "Parse.h"
#import "MatchCell.h"
#import "Match.h"
#import "userChatViewController.h"

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
    self.mytableView.delegate = self;
    self.mytableView.rowHeight = UITableViewAutomaticDimension;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nyc3.jpg"]];
    self.mytableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brooklyn.jpg"]];
    [self Refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)Refresh
{
    __block NSMutableArray *temp = [[NSMutableArray alloc]init];
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(Refresh)
                                                            userInfo:nil repeats:true];
    PFUser *user = PFUser.currentUser;
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Match"];
    //[query1 whereKey:@"person1" equalTo:user];
    
    //PFQuery *query2 = [PFQuery queryWithClassName:@"Match"];
    //[query2 whereKey:@"person2" equalTo:user];
    
    //PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *matches, NSError *error){
        if ([matches count] > 0) {
            for (Match *m in matches){
                if ([m.person1.objectId isEqualToString:user.objectId]){
                    [temp addObject:m];
                }
                else if ([m.person2.objectId isEqualToString:user.objectId]){
                    [temp addObject:m];
                }
            }
            self.matchArray = (NSArray *)temp;
            NSLog(@"matcharray %@", self.matchArray);
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
    cell.layer.cornerRadius = 10;
    Match *match = self.matchArray[indexPath.row];
    PFUser *user = nil;
    
    if ([match.person1.objectId isEqualToString:PFUser.currentUser.objectId]){
        user = match.person2;
    }
    else{
        user = match.person1;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"YUP");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"segueToMessages"]) {
        userChatViewController* chatController = [segue destinationViewController];
        
        UITableViewCell *tappedCell = sender;
        NSLog(@"tapped");
        NSIndexPath *indexPath =  [self.mytableView indexPathForCell:tappedCell];
        Match *match = self.matchArray[indexPath.row];
        chatController.matchObj = match;
        NSLog(@"match %@", match);
        //PFUser query
        //match the objectId of person1 to objectId in the query, extract username from query
        //same for person2
        PFQuery *query1 = [PFUser query];
        [query1 whereKey:@"username" equalTo:PFUser.currentUser.username];
        NSArray *temp = [query1 findObjects];
        chatController.person1 = temp[0];
        //chatController.person1 = temp[0][@"username"];

        NSString *otherUser = @"person1";
        if ([[match[otherUser] objectId] isEqualToString:PFUser.currentUser.objectId]){
            otherUser = @"person2";
        }
        PFQuery *query2 = [PFUser query];
        [query2 whereKey:@"objectId" equalTo:[match[otherUser] objectId]];
        NSArray *temp2 = [query2 findObjects];
        chatController.person2 = temp2[0];//temp2[0][@"username"];
        NSLog(@"hello?");
        
        
    }
}
@end
