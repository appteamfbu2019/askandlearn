//
//  CategoriesViewController.m
//  AskandLearn
//
//  Created by clairec on 7/29/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoryTableViewCell.h"

static CGFloat const animationTime = 0.2f;
static const NSString *nameKey = @"Name";

@interface CategoriesViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noResultsTopConstraint;

@property (nonatomic, copy) SelectedCategoryCompletionBlock selectedBlock;
@property (nonatomic, copy) DeselectedCategoryCompletionBlock deselectedBlock;
@property (nonatomic) NSArray *categoryList;
@property (nonatomic) NSString *currentSearch;
@property (nonatomic) NSArray *addedCategories;
@property (nonatomic) NSArray *dummyCategories;

@end

@implementation CategoriesViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNoResultsView:NO];
    self.dummyCategories = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"CategoryList" ofType:@"plist"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.scrollEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark -
#pragma mark Interface

- (void)searchCategory:(NSString *)categoryName completion:(SelectedCategoryCompletionBlock)block {
    self.selectedBlock = block;
    self.currentSearch = [categoryName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    [self searchTagsForText:self.currentSearch];
}

- (void)searchCategory:(NSString *)categoryName addedCategories:(NSArray *)addedCategories withSelected:(SelectedCategoryCompletionBlock)selectedCategoryBlock deselectedBlock:(DeselectedCategoryCompletionBlock)deselectedBlock{
    self.selectedBlock = selectedCategoryBlock;
    self.deselectedBlock = deselectedBlock;
    self.addedCategories = addedCategories;
    self.currentSearch = [categoryName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    [self searchTagsForText:self.currentSearch];
}

- (void)resetCategoryList {
    self.currentSearch = nil;
    self.categoryList = nil;
    [self reloadAllSections];
}

#pragma mark -
#pragma mark UITableViewDatasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger noOfRows = 0;
    noOfRows = [self.categoryList count];
    return noOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCellId"];
    NSDictionary *category = self.categoryList[indexPath.row];
    [self configureCell:cell forCategory:category];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected");
    NSDictionary *category = self.categoryList[indexPath.row];
    if (self.selectedBlock)
    {
        self.selectedBlock(YES, category, nil);
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.didScrollBlock){
        self.didScrollBlock();
    }
}

#pragma mark -
#pragma mark Private

- (void)searchTagsForText:(NSString *)searchText
{
    NSString *predicateString = [NSString stringWithFormat:@"Name contains[c] '%@'", searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSArray *categories =[self.dummyCategories filteredArrayUsingPredicate:predicate];
    
    self.categoryList = categories;
    [self reloadAllSections];
}

- (void)reloadAllSections
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self showNoResultsView:NO];
}

- (void)showNoResultsView:(BOOL)show {
    if (show && self.noResultView.hidden && [self.currentSearch length]) {
        self.noResultView.hidden = NO;
        [UIView animateWithDuration:animationTime animations:^{
            self.noResultView.alpha = 1.0;
        }];
    }
    else if (!show && !self.noResultView.hidden) {
        [UIView animateWithDuration:animationTime animations:^{
            self.noResultView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.noResultView.hidden = YES;
        }];
    }
}

- (void)configureCell:(CategoryTableViewCell *)cell forCategory:(NSDictionary *)category
{
    cell.categoryText.text = category[nameKey];
    cell.accessoryType = [self isCategoryAlreadySelected:category] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (BOOL)isCategoryAlreadySelected:(NSDictionary *)category
{
    BOOL isSelected = NO;
    isSelected = [self.addedCategories containsObject:category];
    return isSelected;
}

#pragma mark -
#pragma mark Keyboard Notifications

- (void)keyboardDidShow:(NSNotification *)notification
{
    CGSize keyBoardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    
    CGFloat originX = (self.noResultView.bounds.size.height - keyBoardSize.height) / 2;
    self.noResultsTopConstraint.constant = originX;
}

@end
