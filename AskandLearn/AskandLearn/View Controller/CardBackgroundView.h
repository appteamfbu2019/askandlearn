//
//  CardBackgroundView.h
//  AskandLearn
//
//  Created by clairec on 7/23/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "CardView.h"
#import "HomeViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AlertDelegate <NSObject>
-(void)alertPopUp:(PFUser *)user;
-(void)outOfCards;
- (void) scoreAlert: (double) score;
@end

@interface CardBackgroundView : UIView <DraggableViewDelegate>
@property (weak) id <AlertDelegate> delegate;
-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;
-(void)retrieveTags: (PFUser *)user;
@property (retain,nonatomic)NSArray* exampleCardLabels; //%%% the labels the cards
@property (retain,nonatomic)NSMutableArray* allCards; //%%% the labels the cards
@property (strong, atomic) NSMutableArray *cards;
@property (strong, nonatomic) NSArray *actions;
@property (strong, nonatomic) NSArray *tags;

@end

NS_ASSUME_NONNULL_END
