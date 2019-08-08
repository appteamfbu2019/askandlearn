//
//  CardView.h
//  AskandLearn
//
//  Created by clairec on 7/23/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;
-(void)retrieveTags: (PFUser *)user;

@end

@interface CardView : UIView

@property (weak) id <DraggableViewDelegate> delegate;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic)CGPoint originalPoint;
@property (nonatomic,strong)UILabel* name;
@property (nonatomic, strong)UILabel* major;
@property (nonatomic, strong)UILabel* profession;
@property (nonatomic, strong)UILabel* score;

@property (nonatomic, strong) PFUser *user;

-(void)leftClickAction;
-(void)rightClickAction;

@end

NS_ASSUME_NONNULL_END
