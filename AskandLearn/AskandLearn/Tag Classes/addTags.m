//
//  addTags.m
//  AskandLearn
//
//  Created by clairec on 7/29/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "addTags.h"
#import "CategoriesViewController.h"
#import "TokenInputView.h"
#import "Token.h"

static CGFloat minInputHeight = 43;
static CGFloat maxInputHeight = 94;
static CGFloat leftPad = 15;
static CGFloat topPad = 10;
static CGFloat rightPad = 15;
static CGFloat bottomPad = 10;
static NSString *nameKey = @"Name";
static NSString *idKey = @"Identifier";

@interface addTags () <InputViewDelegate>

@property (nonatomic) IBOutlet TokenInputView *tokenInputView;
@property (weak, nonatomic) IBOutlet UIView *categoriesListContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addedTagViewHeight;

@property (nonatomic) CategoriesViewController *categoriesListController;
@property (nonatomic) NSMutableArray *addedTags;
@property (nonatomic) NSMutableDictionary *tokensCache;

@end

@implementation addTags

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tokenInputView.inputViewDelegate = self;
    self.title = @"Token Input View";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureTagListViewController];
    [self checkAndUpdateDoneButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layoutViewsBasedOnComposerHeight];
    [self.tokenInputView becomeFirstResponder];
    [self.tokenInputView addTokens:[self.tokensCache allValues] needsLayout:YES];
    Token *token = self.tokensCache[self.selectedToken.idString];
    [self.tokenInputView setSelectedToken:token highlight:YES];
}

- (NSMutableArray *)addedTags
{
    if (!_addedTags)
    {
        _addedTags = [NSMutableArray array];
    }
    return _addedTags;
}

- (NSDictionary *)tokensCache
{
    if (!_tokensCache)
    {
        _tokensCache = [NSMutableDictionary dictionary];
    }
    return _tokensCache;
}

#pragma mark -
#pragma mark Interface

- (void)configureAddTagsView:(NSArray *) tags
{
    [self addingTags:tags];
}

#pragma mark -
#pragma mark Actions

- (void)doneButtonPressed:(id)sender
{
    if (self.addTagsBlock)
    {
        self.addTagsBlock(YES, self.addedTags, nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Private

- (void)configureTagListViewController
{
    if (!self.categoriesListController)
    {
        self.categoriesListController = [CategoriesViewController categoriesController];
        [self addChildViewController:self.categoriesListController];
        self.categoriesListController.view.frame = self.categoriesListContainerView.bounds;
        [self.categoriesListContainerView addSubview:self.categoriesListController.view];
        [self.categoriesListController didMoveToParentViewController:self];
    }
    
    __weak addTags *weakSelf = self;
    self.categoriesListController.didScrollBlock = ^{
        [weakSelf.view endEditing:YES];
    };
    
    NSLog(@"hello %@", self.categoriesListController.tableView.delegate);
}

- (void)layoutViewsBasedOnComposerHeight
{
    self.addedTagViewHeight.constant = minInputHeight;
    self.tokenInputView.textContainerInset = UIEdgeInsetsMake(topPad, leftPad, bottomPad, rightPad);
}

- (void)searchTagsForText:(NSString *)searchText
{
    __weak addTags *weakSelf = self;
    NSLog(@"hellloooo");
    [self.categoriesListController searchCategory:searchText addedCategories:self.addedTags withSelected:^(BOOL success, NSDictionary *category, NSError *error) {
        if (success)
        {
            NSLog(@"success");
            
            [weakSelf addTag:category updateTokenView:YES];
        }
    } deselectedBlock:^(BOOL success, NSDictionary *category, NSError *error) {
        if (success)
        {
            NSLog(@"remove");
            [weakSelf removeTag:category];
        }
    }];
}

- (void)addTag:(NSDictionary *)tag updateTokenView:(BOOL)update
{
    Token *token = self.tokensCache[tag[idKey]];
    if (!token)
    {
        token = [[Token alloc] init];
        token.nameString = tag[nameKey];
        token.idString= tag[idKey];
        [self.tokensCache setValue:token forKey:token.idString];
    }
    
    [self.addedTags addObject:tag];
    [self.tokenInputView addToken:token needsLayout:update];
}

- (void)removeTag:(NSDictionary *)tag
{
    Token *token = self.tokensCache[tag[idKey]];
    if (token)
    {
        [self.addedTags removeObject:tag];
        [self.tokensCache removeObjectForKey:token.idString];
        [self.tokenInputView removeToken:token needsLayout:YES];
    }
}

- (NSDictionary *)tagForToken:(Token *)token
{
    NSDictionary *tagForToken = nil;
    for (NSDictionary *tag in self.addedTags)
    {
        if ([tag[idKey] isEqualToString:token.idString])
        {
            tagForToken = tag;
            break;
        }
    }
    return tagForToken;
}

- (void)checkAndUpdateDoneButton
{
    BOOL enable = [self.addedTags count] ? YES : NO;
    [[[self navigationItem] rightBarButtonItem] setEnabled:enable];
}

- (void )addingTags:(NSArray *)tags
{
    for (NSDictionary *tag in tags)
    {
        [self addTag:tag updateTokenView:NO];
    }
}

#pragma mark -
#pragma mark InputViewDelegate

- (void)textDidChange:(NSString *)text
{
    NSLog(@"text changing %@", text);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if ([text length])
    {
        [self performSelector:@selector(searchTagsForText:) withObject:text afterDelay:0.3];
    }
    else
    {
        [self.categoriesListController resetCategoryList];
    }
}

- (void)didRemoveToken:(Token *)token
{
    NSDictionary *tag = [self tagForToken:token];
    if (tag)
    {
        [self removeTag:tag];
        [self.categoriesListController resetCategoryList];
    }
}


- (void)didUpdateSize:(CGSize)size
{
    CGFloat height = [self correctedHeight:size.height];
    [UIView animateWithDuration:0.2 animations:^{
        self.addedTagViewHeight.constant = height;
        [self.view layoutIfNeeded];
    }];
}

- (CGFloat)correctedHeight:(CGFloat)height
{
    CGFloat correctedHeight = 0;
    if (height < minInputHeight)
        correctedHeight = minInputHeight;
    else if (height > maxInputHeight)
        correctedHeight = maxInputHeight;
    else
        correctedHeight = height;
    
    return correctedHeight;
}


@end
