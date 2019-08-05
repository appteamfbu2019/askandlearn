//
//  TagsViewController.h
//  AskandLearn
//
//  Created by clairec on 8/2/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagsViewController : ViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger noOfTags;
@property (strong, nonatomic) NSMutableArray *allTags;

-(void)fetchTags;

@end

NS_ASSUME_NONNULL_END
