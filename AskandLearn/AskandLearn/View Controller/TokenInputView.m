//
//  TokenInputView.m
//  AskandLearn
//
//  Created by clairec on 7/29/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "TokenInputView.h"
#import "Token.h"

@interface TokenInputView () <UITextViewDelegate>
@property (nonatomic) NSMutableArray *tokens;
@property (nonatomic) Token *selectedToken;

@property (nonatomic) BOOL isBackspacePressed;
@property (nonatomic) NSInteger lastLocation;
@property (nonatomic) NSString *activeText;
@end

static NSString *contentSizeKeyPath = @"contentSize";

@implementation TokenInputView

-(instancetype)init{
    self = [super init];
    if (self){
        [self initialSetUp];
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:contentSizeKeyPath];
}

-(void)awakeFromNib{
    [self initialSetUp];
    [self addObserver:self forKeyPath:contentSizeKeyPath options:NSKeyValueObservingOptionOld context:nil];
}

#pragma mark -
#pragma mark Interface

-(void)addToken:(Token *)token needsLayout:(BOOL)needsLayout{
    if (![self.tokens containsObject:token]){
        [self.tokens addObject:token];
        self.activeText = nil;
        if (needsLayout){
            [self updateTextForTokens];
            [self scrollRangeToVisible:token.tokenRange];
        }
    }
}

-(void)removeToken:(Token *)token needsLayout:(BOOL)needsLayout{
    [self.tokens removeObject:token];
    if (needsLayout){
        [self updateTextForTokens];
    }
    if (self.inputViewDelegate && [self.inputViewDelegate respondsToSelector:@selector(didRemoveToken:)]){
        [self.inputViewDelegate didRemoveToken:token];
    }
    self.activeText = nil;
}

-(void)addTokens:(NSArray *)tokens needsLayout:(BOOL)needsLayout{
    if (tokens){
        NSSortDescriptor *sortDisc = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:YES];
        self.tokens = [[tokens sortedArrayUsingDescriptors:@[sortDisc]] mutableCopy];
        
        if (needsLayout){
            [self updateTextForTokens];
        }
    }
}

- (void)updateTextForTokens{
    NSString *text = @"";
    NSInteger location = 0;
    NSInteger length = 0;
    for (Token *token in self.tokens){
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@, ", token.nameString]];
        length = [text length] - location;
        NSRange range = NSMakeRange(location, length - 2);
        location = [text length];
        token.tokenRange = range;
    }
    
    if ([self.activeText length]){
        text = [text stringByAppendingString:self.activeText];
    }
    self.text = text;
}

- (void)setSelectedToken:(Token *)token highlight:(BOOL)highlight{
    if ([self.tokens containsObject:token] && highlight){
        [self highlightToken:token];
    }
    self.selectedToken = token;
}

#pragma mark -
#pragma mark Private

- (void)initialSetUp{
    self.tokens = [NSMutableArray array];
    self.delegate = self;
    [UIMenuController sharedMenuController].menuVisible = NO;
    self.dataDetectorTypes = UIDataDetectorTypeNone;
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = NO;
    self.scrollEnabled = YES;
    self.exclusiveTouch = NO;
}

- (NSString *)stringFromLocation:(NSInteger)location{
    NSString *newText = nil;
    NSString *delimiter = @",";
    //Valid location can be from 0 to [self.text length]
    if (location > -1 && location < [self.text length]){
        // get range of the word from current location upto first delimiter backword
        NSRange range = [self.text rangeOfString:delimiter options:NSBackwardsSearch range:NSMakeRange(0, location)];
        NSRange tokenRange;
        // to handle the 1st token string which has no ',' delimiter in the front.
        if (range.location == NSNotFound){
            tokenRange = NSMakeRange(0, location + 1);
        }
        else{
            tokenRange = NSMakeRange(range.location + 2, location - (range.location + 1) );
        }
        newText = [self.text substringWithRange:tokenRange];
        newText = [newText stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@", "]];
    }
    return newText;
}

- (void)detectAndHighlightToken:(Token *)token AtLocation:(NSInteger)location{
    NSRange detectedTokenRange;
    if (location != NSNotFound && token){
        self.selectedToken = token;
        if (detectedTokenRange.location != NSNotFound){
            [self selectAll:nil];
            [self setSelectedRange:token.tokenRange];
        }
    }
}

- (void)setTokenSelectedRange{
    [self setSelectedRange:self.selectedToken.tokenRange];
    if (self.inputViewDelegate && [self.inputViewDelegate respondsToSelector:@selector(didSelectToken:)]){
        [self.inputViewDelegate didSelectToken:self.selectedToken];
    }
}

- (void)highlightToken:(Token *)token{
    if (token && (![token.idString isEqualToString:self.selectedToken.idString])){
        self.selectedToken = token;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(setTokenSelectedRange) withObject:nil afterDelay:0.1];
    }
}

- (void)unhighlightSelectedToken{
    if (self.selectedToken){
        self.selectedToken = nil;
        [self setSelectedRange:NSMakeRange([self.text length], 1)];
    }
}

- (Token *)tokenForString:(NSString *)tokenName{
    for (Token *token in self.tokens){
        if ([token.nameString isEqualToString:tokenName]){
            return token;
        }
    }
    return nil;
}

- (Token *)tokenFromLocation:(NSInteger )location{
    Token *token = nil;
    NSString *delimiter = @",";
    if (location > -1 && location != NSNotFound){
        NSInteger startLocation = 0;
        NSInteger endLocation = 0;
        NSRange startRange = [self.text rangeOfString:delimiter options:NSBackwardsSearch range:NSMakeRange(0, location)];
        
        if (startRange.location != NSNotFound){
            startLocation = startRange.location;
        }
        
        NSRange endRange = [self.text rangeOfString:delimiter options:NSRegularExpressionSearch range:NSMakeRange(location, [self.text length] - location)];
        
        if (endRange.location != NSNotFound)
            endLocation = endRange.location;
        
        NSString *tokenString = [self.text substringWithRange:NSMakeRange(startLocation, endLocation - startLocation)];
        tokenString = [tokenString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@", "]];
        token = [self tokenForString:tokenString];
    }
    return token;
}

- (void)handleTokenSelectionAtPoint:(CGPoint)point{
    // we need to get two positions since attributed links only apply to ranges with a length > 0
    UITextPosition *startPosition = [self closestPositionToPoint:point];
    UITextPosition *endPosition = [self positionFromPosition:startPosition offset:1];
    // check if we're beyond the max length and go back by one
    if (!endPosition) {
        startPosition = [self positionFromPosition:startPosition offset:-1];
        endPosition = [self positionFromPosition:startPosition offset:1];
    }
    // abort if we still don't have a string that's long enough
    if (!endPosition) {
        return;
    }
    // get the offset range of the character we tapped on
    UITextRange *range = [self textRangeFromPosition:startPosition toPosition:endPosition];
    NSInteger startOffset = [self offsetFromPosition:self.beginningOfDocument toPosition:range.start];
    NSInteger endOffset = [self offsetFromPosition:self.beginningOfDocument toPosition:range.end];
    NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
    
    Token *token = [self tokenFromLocation:offsetRange.location];
    if (token){
        [self highlightToken:token];
    }
    else{
        [self unhighlightSelectedToken];
    }
}

- (BOOL)isRange:(NSRange)sourceRange equalToRange:(NSRange)destiRange{
    BOOL isIdentical = (sourceRange.location == destiRange.location && sourceRange.length == destiRange.length);
    return isIdentical;
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    BOOL shouldChange = NO;
    NSCharacterSet *characterSet =  [NSCharacterSet characterSetWithCharactersInString:@"\n'"];
    if ([text rangeOfCharacterFromSet:characterSet].length)
        return shouldChange;
    
    self.lastLocation = range.location;
    self.activeText = text;
    
    if ([text length] == 0){
        self.isBackspacePressed = YES;
        self.lastLocation = range.location - 1;
    }
    else{
        self.isBackspacePressed = NO;
    }
    shouldChange = YES;
    return  shouldChange;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *string = [self stringFromLocation:self.lastLocation];
    Token *token = [self tokenForString:string];
    
    if (self.isBackspacePressed){
        if (token){
            [self detectAndHighlightToken:token AtLocation:self.lastLocation];
        }
        else if (self.selectedToken){
            [self removeToken:self.selectedToken needsLayout:YES];
            [self updateTextForTokens];
            self.selectedToken = nil;
        }
        else{
            [self.inputViewDelegate textDidChange:string];
        }
    }
    else{
        if (self.selectedToken){
            [self removeToken:self.selectedToken needsLayout:NO];
            self.selectedToken = nil;
        }
        [self.inputViewDelegate textDidChange:string];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    NSLog(@"selected Range : %@", NSStringFromRange(textView.selectedRange));
}

#pragma mark -
#pragma mark UItextView Size Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:contentSizeKeyPath]){
        if (self.inputViewDelegate && [self.inputViewDelegate respondsToSelector:@selector(didUpdateSize:)]){
            [self.inputViewDelegate didUpdateSize:self.contentSize];
        }
    }
}

#pragma mark -
#pragma mark Handle Tap

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    BOOL shouldBegin = YES;
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        shouldBegin = NO;
    return shouldBegin;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    [self handleTokenSelectionAtPoint:point];
    return self;
}

@end
