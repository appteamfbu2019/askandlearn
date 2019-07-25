//
//  CardBackgroundView.m
//  AskandLearn
//
//  Created by clairec on 7/23/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "CardBackgroundView.h"
#import "CardView.h"
#import "Parse/Parse.h"
#import "User.h"
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
static const float CARD_HEIGHT = 386; //%%% height of the draggable card
static const float CARD_WIDTH = 290; //%%% width of the draggable card

@synthesize exampleCardLabels; //%%% all the labels I'm using as example data at the moment
@synthesize allCards;//%%% all the cards

- (id)initWithFrame:(CGRect)frame

{
    NSLog(@"loading card background view");
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
        exampleCardLabels = [[NSMutableArray alloc] init];//[[NSArray alloc]initWithObjects:@"first",@"second",@"third",@"fourth",@"last", nil]; //%%% placeholder for card-specific information
        
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

//%%% sets up the extra buttons on the screen
-(void)setupView
{
#warning customize all of this.  These are just place holders to make it look pretty
    self.backgroundColor = [UIColor colorWithRed:.92 green:.93 blue:.95 alpha:1]; //the gray background colors
    menuButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 34, 22, 15)];
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    messageButton = [[UIButton alloc]initWithFrame:CGRectMake(284, 34, 18, 18)];
    [messageButton setImage:[UIImage imageNamed:@"messageButton"] forState:UIControlStateNormal];
    xButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 485, 59, 59)];
    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 485, 59, 59)];
    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:menuButton];
    [self addSubview:messageButton];
    [self addSubview:xButton];
    [self addSubview:checkButton];
}

#warning include own card customization here!
//%%% creates a card and returns it.  This should be customized to fit your needs.
// use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
// to get rid of it (eg: if you are building cards from data from the internet)
-(CardView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    CardView *draggableView = [[CardView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    
    PFUser *temp = self.cards[index];
    draggableView.information.text = temp.username;
    draggableView.delegate = self;
    return draggableView;
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    if([self.cards count] > 0) {
        NSInteger numLoadedCardsCap =(([self.cards count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[self.cards count]);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
        for (int i = 0; i<[self.cards count]; i++) {
            NSLog(@"self.cards count %lu", [self.cards count]);
            CardView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
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
            NSLog(@"discard %@", discard);
            for (PFUser *user in discard){
                for (PFUser *card in self.cards){
                    if ([card.objectId isEqualToString:user.objectId]){
                        NSLog(@"Removing");
                        [self.cards removeObject:card];
                        break;
                    }
                }
            }
            if ([self.cards count] == (NSUInteger)0){
                NSLog(@"exhausted all options");
                //self.nameField.text = @"RAN OUT OF CARDS! come back later :)";
                [self outOfCards];
            }
            
            NSLog(@"cards!! %lu", [self.cards count]);
            cardsLoadedIndex = 0;
            [self loadCards];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
}

- (void) outOfCards {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Out of cards!"
                                                                   message:@"Come back later:)" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    
    HomeViewController *pop = [[HomeViewController alloc] init];
    [pop presentViewController:alert animated:YES completion:nil];
}

#warning include own action here!
//%%% action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    PFUser *currentCard = self.cards[0];
    [Action dislikeAction:PFUser.currentUser withUser:currentCard];
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    [self.cards removeObject:currentCard];
    //[self reloadData];
}

#warning include own action here!
//%%% action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    NSLog(@"self.cards %@", self.cards);
    NSLog(@"allCards %@", allCards);
    NSLog(@"loadedCards %@", loadedCards);
    
    PFUser *currentCard = self.cards[0];
    [Action likeAction:PFUser.currentUser withUser:currentCard];
    
    //run through the arrays and form 'matches'
    PFQuery *query = [PFQuery queryWithClassName:@"Action"];
    [query includeKey:@"receiver"];
    [query includeKey:@"sender"];
    [query whereKey:@"sender" equalTo:currentCard];
    [query whereKey:@"receiver" equalTo:PFUser.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *like, NSError *error) {
        if (like.count != (NSUInteger) 0 && like != nil){
            NSLog(@"like looks like %@", like);
            [Match matchFormed:PFUser.currentUser withUser:like[0][@"sender"]];
            NSLog(@"MATCH formed!!!");
            HomeViewController *pop = [[HomeViewController alloc] init];
            [pop alertPopUp:like[0][@"sender"]];
        }
        else{
            NSLog(@"no Match formed");
        }
    }];
    
    [self.cards removeObject:currentCard];
    NSLog(@"%lu", [self.cards count]);
    //[self reloadData];
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}

//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight
{
    CardView *dragView = [loadedCards firstObject];
//    dragView.overlayView.mode = GGOverlayViewModeRight;
//    [UIView animateWithDuration:0.2 animations:^{
//        dragView.overlayView.alpha = 1;
//    }];
    [dragView rightClickAction];
}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft
{
    CardView *dragView = [loadedCards firstObject];
//    dragView.overlayView.mode = GGOverlayViewModeLeft;
//    [UIView animateWithDuration:0.2 animations:^{
//        dragView.overlayView.alpha = 1;
//    }];
    [dragView leftClickAction];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
