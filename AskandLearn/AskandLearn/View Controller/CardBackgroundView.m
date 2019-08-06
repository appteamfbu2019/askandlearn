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
static const float CARD_HEIGHT = 700; //%%% height of the draggable card
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
        
        PFQuery *query1 = [PFUser query];
        [query1 whereKey:@"username" notEqualTo:PFUser.currentUser.username];
        self.cards = (NSMutableArray *)[query1 findObjects];
        [self reloadData];
        
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        NSLog(@"fetching users");
    }
    return self;
}

-(void)setupView {
    self.backgroundColor = [UIColor colorWithRed:.92 green:.93 blue:.95 alpha:1];
}

-(CardView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    CardView *draggableView = [[CardView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    
    PFUser *temp = self.cards[index];
    draggableView.information.text = temp.username;
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
}


-(void)reloadData {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Action"];
    [query includeKey:@"receiver"];
    [query includeKey:@"sender"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *actions, NSError *error){
        if (actions != nil) {
            self.actions = actions;
            NSLog(@"actions %@", actions);
            NSMutableArray *discard = [[NSMutableArray alloc]init];
            for (Action *act in self.actions){
                if ([act.receivedDislike.objectId isEqualToString:PFUser.currentUser.objectId]){
                    [discard addObject:act.sender];
                }
                else if ([act.sender.objectId isEqualToString:PFUser.currentUser.objectId]){
                    [discard addObject:act.receiver];
                }
            }
            NSLog(@"discard %@", discard);
            for (PFUser *user in discard){
                
                for (PFUser *card in self.cards){
                    if ([card.objectId isEqualToString:user.objectId]){
                        NSLog(@"removing %@", card);
                        [self.cards removeObject:card];
                        break;
                    }
                }
            }
            if ([self.cards count] == (NSUInteger)0){
                NSLog(@"exhausted all options");
                [self->delegate outOfCards];
            }
            self->cardsLoadedIndex = 0;
            [self loadCards];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
}

-(void)cardSwipedLeft:(UIView *)card;
{
    PFUser *currentCard = self.cards[0];
    [Action dislikeAction:PFUser.currentUser withUser:currentCard];
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    [self.cards removeObject:currentCard];
    if ([self.cards count] == (NSUInteger)0){
        NSLog(@"exhausted all options");
        [delegate outOfCards];
    }
}

-(void)cardSwipedRight:(UIView *)card
{
    PFUser *currentCard = self.cards[0];
    [Action likeAction:PFUser.currentUser withUser:currentCard];
    
    //run through the arrays and form 'matches'
    PFQuery *query = [PFQuery queryWithClassName:@"Action"];
    [query includeKey:@"receiver"];
    [query includeKey:@"sender"];
    [query whereKey:@"sender" equalTo:currentCard];
    [query whereKey:@"receiver" equalTo:PFUser.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *like, NSError *error) {
        if (like.count != 0 && like != nil){
            [Match matchFormed:PFUser.currentUser withUser:like[0][@"sender"]];
            NSLog(@"MATCH formed!!!");
            [self->delegate alertPopUp:like[0][@"sender"]];
        }
        else{
            NSLog(@"no Match formed");
        }
    }];
    
    [self.cards removeObjectAtIndex:0];
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    
    if ([self.cards count] == (NSUInteger)0){
        NSLog(@"exhausted all options");
        [delegate outOfCards];
    }
}

-(void)swipeRight
{
    CardView *dragView = [loadedCards firstObject];
    [dragView rightClickAction];
}

-(void)swipeLeft
{
    CardView *dragView = [loadedCards firstObject];
    [dragView leftClickAction];
}

@end
