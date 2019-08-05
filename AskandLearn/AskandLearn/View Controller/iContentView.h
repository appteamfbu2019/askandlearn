//
//  iContentView.h
//  AskandLearn
//
//  Created by estherb on 8/5/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iContentView : UIView

@property (nonatomic, strong) UITextView *chatTextView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat animationDuration;


-(id)initWithTextView:(UITextView *)textView ChatTextViewHeightConstraint:(NSLayoutConstraint *)heightConstraint contentView:(UIView *)contentView ContentViewHeightConstraint:(NSLayoutConstraint *)contentViewHeightConstraint andContentViewBottomConstraint:(NSLayoutConstraint *)contentViewBottomConstraint;

- (void)updateMinimumNumberOfLines:(NSInteger)minimumNumberOfLines
            andMaximumNumberOfLine:(NSInteger)maximumNumberOfLines;

- (void)resizeTextViewWithAnimatiContentViewmated;
-(void)textViewDidChange:(UITextView *)textView;
@end
