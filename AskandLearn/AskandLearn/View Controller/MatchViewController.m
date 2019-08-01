//
#import "MatchViewController.h"
#import "Parse.h"
#import "MatchCell.h"
#import "Match.h"

@interface MatchViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (strong,nonnull) NSMutableArray *matchArray;
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
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(Refresh) userInfo:nil repeats:true];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Match"];
    PFUser *user = PFUser.currentUser;
    [query whereKey:@"person1" equalTo:user];
//    PFQuery *personQuery = [PFQuery queryWithClassName:@"User"];
//    PFObject *user = [personQuery getObjectWithId:@"0k6psKGIbB"]; //User 1

    [query findObjectsInBackgroundWithBlock:^(NSArray *matches, NSError *error){
        if ([matches count] > 0) {
            [self.matchArray addObjectsFromArray:matches];
            [self.mytableView reloadData];
            NSLog(@"%@", matches);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [query whereKey:@"person2" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *matches, NSError *error){
        if ([matches count] > 0) {
            [self.matchArray addObjectsFromArray:matches];
            [self.mytableView reloadData];
            NSLog(@"%@", matches);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell" forIndexPath:indexPath];
    PFObject *match = self.matchArray[indexPath.row];
    PFUser *user = match[@"user"];
    
    if(user != nil){
        cell.usernameLabel.text = user.username;
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
