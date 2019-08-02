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

@interface TagsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.noOfTags = 0;
    self.allTags = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    [self reloadData];
    NSLog(@"allTags %@", self.allTags);
}

-(void)reloadData{
    PFQuery *query = [PFQuery queryWithClassName:@"Tags"];
    [query includeKey:@"user"];
    [query includeKey:@"tag"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * tags, NSError *error) {
        if (tags != nil){
            for (Tags *tag in tags){
                if ([tag.user.objectId isEqualToString:PFUser.currentUser.objectId]){
                    self.noOfTags += 1;
                    [self.allTags addObject:tag];
                }
            }
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
    cell.cellText.text = tag[@"Name"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noOfTags;
}


@end
