//
//  SettingsViewController.m
//  AskandLearn
//
//  Created by clairec on 7/26/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "SettingsViewController.h"
#import "Parse/Parse.h"
#import "addTags.h"
#import "Tags.h"
#import "TagsViewController.h"

@interface SettingsViewController () <TagsDelegate>
@property (nonatomic) addTags *tagController;
@property (nonatomic, strong) NSArray *tagObjects;
@property (nonatomic, strong) Tags *ownTag;
@property (nonatomic, strong) TagsViewController *tvc;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tagController.delegate = self;
    self.tagObjects = [[NSArray alloc] init];
    [self retrieveTags];
    self.numberOfTags = 0;
    
    
}

-(void)retrieveTags{
    PFQuery *query = [PFQuery queryWithClassName:@"Tags"];
    [query includeKey:@"user"];
    [query includeKey:@"tags"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *tagObjects, NSError *error) {
        if (tagObjects != nil){
            for (Tags *tagObj in tagObjects){
                if ([tagObj.user.objectId isEqualToString:PFUser.currentUser.objectId]){
                    self.ownTag = tagObj;
                    self.numberOfTags += 1;
                }
            }
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

-(void)assignTags:(NSArray *)tags{
    
    for (NSDictionary *tag in tags){
        [Tags newTag:PFUser.currentUser setTag:tag];
        self.numberOfTags += 1;
    }
    NSLog(@"added tags to server %@", tags);
    [self.tvc fetchTags];
}

- (IBAction)learnSkills:(id)sender {
}

- (IBAction)shareKnowledge:(id)sender {
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"addTagsSegue"]) {
        addTags *childViewController = (addTags *)[segue destinationViewController];
        self.tagController = childViewController;
        self.tagController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"tagsTableSegue"]){
        TagsViewController *tvc = (TagsViewController *)[segue destinationViewController];
        self.tvc = tvc;
        
    }
}

@end
