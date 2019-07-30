//
//  TokenInputView.h
//  AskandLearn
//
//  Created by clairec on 7/29/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Token;

@protocol InputViewDelegate <NSObject>
@optional
-(void)textDidChange:(NSString *) text;
-(void)didRemoveToken:(Token *)token;
-(void)didUpdateSize:(CGSize)size;
-(void)didSelectToken:(Token *)token;
@end

@interface TokenInputView : UITextView

@property (nonatomic, weak) id <InputViewDelegate> inputViewDelegate;

-(void)addToken:(Token *)token needsLayout:(BOOL)needsLayout;
-(void)removeToken:(Token *)token needsLayout:(BOOL)needsLayout;
-(void)addTokens:(NSArray *)tokens needsLayout:(BOOL)needsLayout;
-(void)setSelectedToken:(Token *)token highlight:(BOOL)highlight;
-(void)updateTextForTokens;

@end

NS_ASSUME_NONNULL_END
