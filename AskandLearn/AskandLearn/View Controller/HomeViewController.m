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
#import "Match.h"

@interface HomeViewController () <UIAlertViewDelegate>

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
                self.nameField.text = @"RAN OUT OF CARDS! come back later :)";
                [self outOfCards];
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
    
    //run through the arrays and form 'matches'
    PFQuery *query = [PFQuery queryWithClassName:@"Action"];
    [query includeKey:@"receiver"];
    [query includeKey:@"sender"];
    [query whereKey:@"sender" equalTo:self.cards[0]];
    [query whereKey:@"receiver" equalTo:PFUser.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *like, NSError *error) {
        if (like.count != (NSUInteger) 0 && like != nil){
            NSLog(@"like looks like %@", like);
            [Match matchFormed:PFUser.currentUser withUser:like[0][@"sender"]];
            NSLog(@"MATCH formed!!!");
            [self alertPopUp:like[0][@"sender"]];
        }
        else{
            NSLog(@"no Match formed");
        }
    }];
    
    [self.cards removeObject:self.cards[0]];
    [self reloadData];
}

- (IBAction)tapDislike:(id)sender {
    [Action dislikeAction:PFUser.currentUser withUser:self.cards[0]];
    [self.cards removeObject:self.cards[0]];
    [self reloadData];
}

- (void) outOfCards {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Out of cards!"
                                                                   message:@"Come back later:)" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) alertPopUp: (PFUser *)matchedUser {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"You received a match!"
                                                                    message:[NSString stringWithFormat:@"Matched with %@", matchedUser.username] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

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
