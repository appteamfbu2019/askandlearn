//
//  HomeViewController.m
//  AskandLearn
//
//  Created by clairec on 7/16/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "PFObject.h"
#import "Action.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // get all users
    self.cards = [[NSMutableArray alloc] init];
    NSLog(@"fetching users");
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" notEqualTo:PFUser.currentUser.username];
    self.cards = (NSMutableArray *)[query findObjects];
    NSLog(@"cards!! %@", self.cards);
    [self reloadData];
}

-(void)reloadData {
    PFQuery *query = [PFQuery queryWithClassName:@"Action"];
    [query includeKey:@"receiver"];
    [query includeKey:@"sender"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *actions, NSError *error) {
        if (actions != nil) {
            self.actions = actions;
            NSLog(@"actions count %lu", self.actions.count);
            NSMutableArray *discard = [[NSMutableArray alloc]init];
            for (Action *act in self.actions){
                if ([act.receivedDislike.objectId isEqualToString:PFUser.currentUser.objectId]){
                    [discard addObject:act.sender];
                }
                else if ([act.sender.objectId isEqualToString:PFUser.currentUser.objectId]){
                    [discard addObject:act.receiver];
                }
            }
            for (PFUser *user in discard){
                for (PFUser *card in self.cards){
                    if ([card.objectId isEqualToString:user.objectId]){
                        [self.cards removeObject:card];
                        break;
                    }
                }
            }
            if (self.cards.count == (NSUInteger) 0){
                NSLog(@"exhausted all options");
            }
            else{
                PFUser *temp = self.cards[0];
                self.nameField.text = temp.username;
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (IBAction)tapLike:(id)sender {
    [Action likeAction:PFUser.currentUser withUser:self.cards[0]];
    [self.cards removeObject:self.cards[0]];
    //self.index += 1;
    [self reloadData];
    //run through the arrays and form 'matches'
    //delete nonmatches
}

- (IBAction)tapDislike:(id)sender {
    [Action dislikeAction:PFUser.currentUser withUser:self.cards[0]];
    [self.cards removeObject:self.cards[0]];
    //self.index += 1;
    [self reloadData];
}

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
            appDelegate.window.rootViewController = loginVC;
        }
    }];
}

@end
