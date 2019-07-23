//
//  CardBackgroundView.h
//  AskandLearn
//
//  Created by clairec on 7/23/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardBackgroundView : UIView <DraggableViewDelegate>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@property (retain,nonatomic)NSArray* exampleCardLabels; //%%% the labels the cards
@property (retain,nonatomic)NSMutableArray* allCards; //%%% the labels the cards

@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSArray *actions;

@end

NS_ASSUME_NONNULL_END
