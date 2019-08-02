//
//  TagsViewController.m
//  AskandLearn
//
//  Created by clairec on 8/2/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "TagsViewController.h"
#import "SettingsViewController.h"
#import "Parse.h"
#import "Tags.h"
#import "TagCell.h"

@interface TagsViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTags) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.noOfTags = 0;
    self.allTags = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    [self fetchTags];
    
}

-(void)fetchTags{
    PFQuery *query = [PFQuery queryWithClassName:@"Tags"];
    [query includeKey:@"user"];
    [query includeKey:@"tag"];
    [query includeKey:@"status"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * tags, NSError *error) {
        if (tags != nil){
            NSMutableArray *removal = [[NSMutableArray alloc] init];
            NSMutableArray *adding = [[NSMutableArray alloc]init];
            for (Tags *tag in tags){
                if ([tag.user.objectId isEqualToString:PFUser.currentUser.objectId] && ![tag.status isEqualToString:@"removing"]){
                    [adding addObject:tag];
//                    [self.allTags addObject:tag];
//                    NSLog(@"added object");
                }
                if ([tag.user.objectId isEqualToString:PFUser.currentUser.objectId] && [tag.status isEqualToString:@"removing"]){
                    [removal addObject:tag];
                }
            }
            self.allTags = adding;
            for (Tags *tg1 in removal){
                for (Tags *tg2 in self.allTags){
                    if ([tg1.tag[@"Name"] isEqualToString:tg2.tag[@"Name"]]){
                        [self.allTags removeObject:tg2];
                        break;
                    }
                }
            }
            self.noOfTags = self.allTags.count;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            NSLog(@"allTags %@", self.allTags);
        }
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TagCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TagCell"];
    Tags *tag = self.allTags[indexPath.row];
    cell.cellText.text = tag.tag[@"Name"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noOfTags;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected");
    Tags *tag = self.allTags[indexPath.row];
    [self alertPopUp:tag];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void) alertPopUp: (Tags *)tag{
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Delete Tag" message: [NSString stringWithFormat:@"Confirm deleting tag: %@?", tag.tag[@"Name"]] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [Tags removeTag:PFUser.currentUser remove:tag.tag];
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion: nil];
}


@end
