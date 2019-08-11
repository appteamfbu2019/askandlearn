//
//  CardBackgroundView.m
//  AskandLearn
//
//  Created by clairec on 7/23/19.
//  Copyright © 2019 estherb. All rights reserved.
//

//  Most of the base code for draggable view was created as stated below:
//  RKSwipeCards
//
//  Created by Richard Kim on 5/21/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for updates and requests

#import "CardBackgroundView.h"
#import "CardView.h"
#import "Parse/Parse.h"
#import "PFObject.h"
#import "Action.h"
#import "Match.h"
#import "HomeViewController.h"
#import "Tags.h"
#import "Switch.h"

@implementation CardBackgroundView{
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    
    UIButton* menuButton;
    UIButton* messageButton;
    UIButton* checkButton;
    UIButton* xButton;
}
//this makes it so only two cards are loaded at a time to
//avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
static const float CARD_HEIGHT = 600; //%%% height of the draggable card
static const float CARD_WIDTH = 350; //%%% width of the draggable card

@synthesize exampleCardLabels; //%%% all the labels I'm using as example data at the moment
@synthesize allCards;//%%% all the cards

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
        exampleCardLabels = [[NSMutableArray alloc] init];
        [self loadAllProfiles];
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        
        UITextView *warning = [[UITextView alloc]initWithFrame:CGRectMake(140, 140, self.frame.size.width/2, 150)];
        warning.backgroundColor = [UIColor clearColor];
        warning.text = @"Come back later for more cards:)";
        [warning setTextAlignment:NSTextAlignmentCenter];
        warning.center = CGPointMake(self.center.x, self.center.y+25);
        warning.textColor = [UIColor blackColor];
        warning.font = [UIFont fontWithName:@"Helvetica" size:13 ];
        [self addSubview:warning];
    }
    return self;
}

-(void)setupView {
    self.backgroundColor = [UIColor colorWithRed:.92 green:.93 blue:.95 alpha:1];
}

-(void)loadAllProfiles {
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    [query includeKey:@"name"];
    [query includeKey:@"major"];
    [query includeKey:@"profession"];
    [query includeKey:@"user"];
    [query includeKey:@"profilePic"];
    [query includeKey:@"bio"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *profiles, NSError *error) {
        if (profiles != nil){
            self.cards = (NSMutableArray *)profiles;
            for (PFObject *card in self.cards){
                if ([[card[@"user"] objectId] isEqualToString:PFUser.currentUser.objectId]){
                    NSLog(@"hello? sup");
                    [self.cards removeObject:card];
                    break;
                }
            }
            [self reloadData];
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    
    //Making sure only learners are displayed to teachers, and vice versa
    PFQuery *query2 = [PFQuery queryWithClassName:@"Switch"];
    [query2 includeKey:@"isLearner"];
    [query2 includeKey:@"isTeacher"];
    [query2 includeKey:@"user"];
    __block BOOL userIsLearner = nil;
    __block BOOL userIsTeacher = nil;
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *switchObjs, NSError *error) {
        if (switchObjs != nil){
            //retrieving the current user's preferences
            for (Switch *s in switchObjs){
                if ([s.user.objectId isEqualToString:PFUser.currentUser.objectId]){
                    userIsLearner = s.isLearner;
                    userIsTeacher = s.isTeacher;
                }
            }
            for (Switch *s in switchObjs){
                for (PFObject *c in self.cards){
                    if ([[c[@"user"] objectId] isEqualToString:s.user.objectId]){
                        if (userIsLearner && !userIsTeacher){
                            if (s.isLearner && !s.isTeacher){
                                [self.cards removeObject:c];
                                break;
                            }
                        }
                        else if (userIsTeacher && !userIsLearner){
                            if (s.isTeacher && !s.isLearner){
                                [self.cards removeObject:c];
                                break;
                            }
                        }
                    }
                }
            }
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    
}

-(CardView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    CardView *draggableView = [[CardView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    
    PFObject *temp = self.cards[index];
    draggableView.name.text = [NSString stringWithFormat:@"Name: %@", temp[@"name"]];
    draggableView.major.text = [NSString stringWithFormat:@"Major: %@", temp[@"major"]];
    draggableView.profession.text = [NSString stringWithFormat:@"Profession: %@", temp[@"profession"]];
    draggableView.user = temp[@"user"];
    PFFileObject *file = temp[@"profilePic"];
    NSData *imageData = [file getData];
    UIImage *image = [UIImage imageWithData:imageData];
    draggableView.profPic.image = image;
    draggableView.bio.text = [NSString stringWithFormat:@"Bio: %@", temp[@"bio"]];
    draggableView.delegate = self;
    return draggableView;
}



-(void)loadCards
{
    if([self.cards count] > 0) {
        NSInteger numLoadedCardsCap =(([self.cards count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[self.cards count]);
        for (int i = 0; i<[self.cards count]; i++) {
            CardView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; // we loaded a card into loaded cards, so we have to increment
        }
    }
    //[self.loadingView removeFromSuperview];
    [delegate removeLoading];
}

-(void)retrieveTags: (PFUser *)user{
    NSLog(@"user is: %@", user);
    __block NSMutableArray *ownTags = [[NSMutableArray alloc]init];
    __block NSMutableArray *otherTags = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Tags"];
    [query includeKey:@"user"];
    [query includeKey:@"tags"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *tagObjects, NSError *error) {
        if (tagObjects != nil){
            for (Tags *tagObj in tagObjects){
                if ([tagObj.user.objectId isEqualToString:user.objectId]){
                    [otherTags addObject:tagObj];
                }
                else if ([tagObj.user.objectId isEqualToString:PFUser.currentUser.objectId]){
                    [ownTags addObject:tagObj];
                }
            }
            [self calculateScore:ownTags withOther:otherTags];
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

-(void) calculateScore: (NSMutableArray *)ownTags withOther: (NSMutableArray *)otherTags {
    double percent = 0.0;
    int base_size = (int)otherTags.count;
    
    for (Tags *tg in otherTags){
        for (Tags *tg2 in ownTags){
            if ([tg.tag isEqualToDictionary:tg2.tag]){
                percent += 1.0/base_size;
            }
        }
    }
    [delegate scoreAlert:percent];
}

-(void)reloadData {
    PFQuery *query = [PFQuery queryWithClassName:@"Action"];
    [query includeKey:@"receiver"];
    [query includeKey:@"sender"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *actions, NSError *error){
        if (actions != nil) {
            self.actions = actions;
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
                for (PFObject *card in self.cards){
                    if ([[card[@"user"] objectId] isEqualToString:user.objectId]){
                        [self.cards removeObject:card];
                        break;
                    }
                }
            }
            if ([self.cards count] == (NSUInteger)0){
                //[self->delegate removeLoading];
                [self->delegate outOfCards];
            }
            self->cardsLoadedIndex = 0;
            [self loadCards];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
}

-(void)cardSwipedLeft:(UIView *)card{
    PFObject *currentCard = self.cards[0];
    [Action dislikeAction:PFUser.currentUser withUser:currentCard[@"user"]];
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    [self.cards removeObject:currentCard];
    if ([self.cards count] == (NSUInteger)0){
        [delegate outOfCards];
    }
}

-(void)cardSwipedRight:(UIView *)card{
    PFObject *currentCard = self.cards[0];
    [Action likeAction:PFUser.currentUser withUser:currentCard[@"user"]];
    
    //run through the arrays and form 'matches'
    PFQuery *query = [PFQuery queryWithClassName:@"Action"];
    [query includeKey:@"receiver"];
    [query includeKey:@"sender"];
    [query whereKey:@"sender" equalTo:currentCard[@"user"]];
    [query whereKey:@"receiver" equalTo:PFUser.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *like, NSError *error) {
        if (like.count != 0 && like != nil){
            [Match matchFormed:PFUser.currentUser withUser:like[0][@"sender"]];
            [self->delegate alertPopUp:like[0][@"sender"]];
        }
        else {
            NSLog(@"what");
        }
    }];
    
    [self.cards removeObjectAtIndex:0];
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    
//    if ([self.cards count] == (NSUInteger)0){
//        [delegate outOfCards];
//    }
}

-(void)swipeRight {
    CardView *dragView = [loadedCards firstObject];
    [dragView rightClickAction];
}

-(void)swipeLeft{
    CardView *dragView = [loadedCards firstObject];
    [dragView leftClickAction];
}

@end
