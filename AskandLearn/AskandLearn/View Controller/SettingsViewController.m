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
#import "Switch.h"

@interface SettingsViewController () <TagsDelegate>
@property (nonatomic) addTags *tagController;
@property (nonatomic, strong) NSArray *tagObjects;
@property (nonatomic, strong) Tags *ownTag;
@property (nonatomic, strong) TagsViewController *tvc;
@property (nonatomic, strong) Switch *mostRecent;

@property (weak, nonatomic) IBOutlet UISwitch *learnSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *teachSwitch;

@property (weak, nonatomic) IBOutlet UIButton *addTagsButton;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tagController.delegate = self;
    self.tagObjects = [[NSArray alloc] init];
    [self getSwitchValues];
    [self retrieveTags];
    self.numberOfTags = 0;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brooklyn.jpg"]];
    
    self.addTagsButton.layer.cornerRadius = 10;
}

-(void)getSwitchValues{
    PFQuery *query = [PFQuery queryWithClassName:@"Switch"];
    [query includeKey:@"user"];
    [query includeKey:@"isLearner"];
    [query includeKey:@"isTeacher"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *switchObjects, NSError *error){
        if (switchObjects != nil){
            NSLog(@"switchObj %@", switchObjects);
            for (Switch *switchObj in switchObjects){
                if ([switchObj.user.objectId isEqualToString:PFUser.currentUser.objectId]){
                    self.mostRecent = switchObj;
                    NSLog(@"most recent %@", self.mostRecent);
                    [self.learnSwitch setOn:self.mostRecent.isLearner animated:NO];
                    NSLog(@"learnswitch %d", self.learnSwitch.isOn);
                    [self.teachSwitch setOn:self.mostRecent.isTeacher animated:NO];
                    NSLog(@"teachswitch %d", self.teachSwitch.isOn);
                    break;
                }
            }
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
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
    if ([self.learnSwitch isOn]){
        [self.learnSwitch setOn:NO animated:YES];
        [Switch switchChanged:PFUser.currentUser withLearnStatus:NO withTeachStatus:self.teachSwitch.isOn];
    }
    else {
        [self.learnSwitch setOn:YES animated:YES];
        [Switch switchChanged:PFUser.currentUser withLearnStatus:YES withTeachStatus:self.teachSwitch.isOn];
    }
}

- (IBAction)shareKnowledge:(id)sender {
    if ([self.teachSwitch isOn]){
        [self.teachSwitch setOn:NO animated:YES];
        [Switch switchChanged:PFUser.currentUser withLearnStatus:self.learnSwitch.isOn withTeachStatus:NO];
    }
    else {
        [self.teachSwitch setOn:YES animated:YES];
        [Switch switchChanged:PFUser.currentUser withLearnStatus:self.learnSwitch.isOn withTeachStatus:YES];
    }
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
