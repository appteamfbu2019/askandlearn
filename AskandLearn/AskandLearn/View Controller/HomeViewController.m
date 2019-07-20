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
    
//    if (self.cards.count == (NSUInteger) 0 && self.exhausted == NO){
        NSLog(@"fetching users");
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" notEqualTo:PFUser.currentUser.username];
        self.cards = (NSMutableArray *)[query findObjects];
        NSLog(@"cards!! %@", self.cards);
        
//    }
    [self reloadData];
}

-(void)reloadData {
    self.exhausted = NO;
    PFQuery *query = [PFQuery queryWithClassName:@"Action"];
    //[query whereKey:@"sender" equalTo:PFUser.currentUser];
    //[query whereKey:@"receivedDislike" notEqualTo:PFUser.currentUser];
    [query includeKey:@"receiver"];
    [query includeKey:@"sender"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *actions, NSError *error) {
        if (actions != nil) {
            self.actions = actions;
            //NSLog(@"actions %@", self.actions);
            NSLog(@"actions count %lu", self.actions.count);
            
//            if (self.actions.count == (NSUInteger) 0){
//                NSLog(@"fetching users");
//                [self fetchUsers];
//            }
//            else{
            NSMutableArray *discard = [[NSMutableArray alloc]init];
            for (Action *act in self.actions){
                //NSLog(@"%@", act);
                //NSLog(@"%@", act.sender);
                if ([act.receivedDislike.objectId isEqualToString:PFUser.currentUser.objectId]){
                    [discard addObject:act.sender];
//                    for (PFUser *user in self.cards){
//
//                        if (user.objectId == act.sender.objectId){
//                            NSLog(@"removing %@", user);
//                            [self.cards removeObject:user];
//                            break;
//                        }
//                    }
                    //[self.cards removeObject:act.sender];
                    //NSLog(@"cards count %lu", self.cards.count);
                }


                else if ([act.sender.objectId isEqualToString:PFUser.currentUser.objectId]){
                    [discard addObject:act.receiver];
//                    for (PFUser *user in self.cards){
//                        if ([user.objectId isEqualToString:act.receiver.objectId]){
//                            [self.cards removeObject:user];
//                            NSLog(@"removing %@", user);
//                            break;
//                        }
//                    }
                    //[self.cards removeObject:act.receiver];
                    //NSLog(@"cards count %lu", self.cards.count);
                }
            }
            NSLog(@"discard %@", discard);
            
            for (PFUser *user in discard){
                for (PFUser *card in self.cards){
                    if ([card.objectId isEqualToString:user.objectId]){
                        [self.cards removeObject:card];
                        break;
                    }
                }
                //[self.cards removeObject:user];
            }
                
            NSLog(@"cards %@", self.cards);
            if (self.cards.count == (NSUInteger) 0){
                NSLog(@"exhausted all options");
                self.exhausted = YES;
            }
            else{
                PFUser *temp = self.cards[0];
                self.nameField.text = temp.username;
            }
            
//            }
            

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
