//
//  CardView.m
//  AskandLearn
//
//  Created by clairec on 7/23/19.
//  Copyright © 2019 estherb. All rights reserved.
//

//
//  Most of the base code for draggable view was created as stated below
//  RKSwipeCards
//
//  Created by Richard Kim on 5/21/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for updates and requests

#define ACTION_MARGIN 120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 320 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle


#import "CardView.h"

@implementation CardView {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}
@synthesize delegate;

@synthesize panGestureRecognizer;
@synthesize name;
@synthesize major;
@synthesize profession;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        name = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, 100)];
        name.text = @"no info given";
        [name setTextAlignment:NSTextAlignmentCenter];
        name.textColor = [UIColor whiteColor];
        
        major = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, self.frame.size.width, 100)];
        major.text = @"Major:";
        [major setTextAlignment:NSTextAlignmentCenter];
        major.textColor = [UIColor whiteColor];
        
        profession = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, self.frame.size.width, 100)];
        profession.text = @"Profession:";
        [profession setTextAlignment:NSTextAlignmentCenter];
        profession.textColor = [UIColor whiteColor];
        
        //button for calculate score
        UIButton *mainButton = [UIButton new];
        mainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        mainButton.center = self.center;
        [mainButton setTitle:@"Calculate Score" forState:UIControlStateNormal];
        [mainButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [mainButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [mainButton sizeToFit];
        mainButton.backgroundColor = [UIColor whiteColor];
        [mainButton addTarget:self action:@selector(calculateScoreTap:) forControlEvents:UIControlEventTouchUpInside];
        
        //loading background images
        NSArray *photoArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil];
        NSLog(@"length %lu", photoArray.count);
        NSMutableArray *imgs = [[NSMutableArray alloc]initWithCapacity:photoArray.count];
        for (NSString *path in photoArray){
            [imgs addObject:[UIImage imageWithContentsOfFile:path]];
        }
        //randomly picking an image for card background
        uint32_t rnd = arc4random_uniform((int)[imgs count]);
        UIImage *randomImage = [imgs objectAtIndex:rnd];

        UIGraphicsBeginImageContext(self.frame.size);
        [randomImage drawInRect:self.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.backgroundColor = [UIColor colorWithPatternImage:image];//[UIColor colorWithRed:.9294 green:.6039 blue:.8353 alpha:1];;
        
        panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        
        [self addGestureRecognizer:panGestureRecognizer];
        [self addSubview:name];
        [self addSubview:major];
        [self addSubview:profession];
        [self addSubview:mainButton];
        
    }
    return self;
}

-(void)setupView
{
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}


//%%% called when you move your finger across the screen.
// called many times a second
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    //%%% this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
    xFromCenter = [gestureRecognizer translationInView:self].x; //%%% positive for right swipe, negative for left
    yFromCenter = [gestureRecognizer translationInView:self].y; //%%% positive for up, negative for down
    
    //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
    switch (gestureRecognizer.state) {
            //%%% just started swiping
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
            //%%% in the middle of a swipe
        case UIGestureRecognizerStateChanged:{
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            //%%% degree change in radians
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            //%%% amount the height changes when you move the card up to a certain point
            CGFloat scale = MAX(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
            
            //%%% rotate by certain amount
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            //%%% scale by certain amount
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            //%%% apply transformations
            self.transform = scaleTransform;
            //[self updateOverlay:xFromCenter];
            
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

//%%% called when the card is let go
- (void)afterSwipeAction
{
    if (xFromCenter > ACTION_MARGIN) {
        [self rightAction];
    } else if (xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
    } else { //%%% resets the card
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                             //overlayView.alpha = 0;
                         }];
    }
}

//%%% called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction
{
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

//%%% called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}

-(void)rightClickAction
{
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];

    [delegate cardSwipedRight:self];

    NSLog(@"YES");
}

-(void)leftClickAction
{
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];

    [delegate cardSwipedLeft:self];

    NSLog(@"NO");
}

-(void)calculateScoreTap:(id)sender {
    NSLog(@"calculating score");
    [delegate retrieveTags:self.user];
}



@end
