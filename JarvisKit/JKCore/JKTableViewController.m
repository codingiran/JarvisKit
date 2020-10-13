//
//  JKTableViewController.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/11.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKTableViewController.h"
#import "JKHelper.h"

@interface JKTableViewController ()<UISearchResultsUpdating>

@property(nonatomic, strong, readwrite) UITableView *tableView;
@property(nonatomic, assign, readwrite) UITableViewStyle tableViewStyle;
@property(nonatomic, strong, readwrite) UISearchController *searchController;

@end

@implementation JKTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.tableViewStyle = style;
        self.shouldShowSearchBar = NO;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}

- (void)jk_initSubviews
{
    [super jk_initSubviews];
    [self jk_initTableView];
    [self initSearchController];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self jk_layoutTableView];
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

#pragma mark - private method
- (void)initSearchController
{
    if ([self isViewLoaded] && self.shouldShowSearchBar && !self.searchController) {
        // 创建
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchController.searchResultsUpdater = self;
        self.searchController.searchBar.tintColor = [UIColor blackColor];
        [self.searchController.searchBar sizeToFit];
        self.searchController.hidesNavigationBarDuringPresentation = YES;
        self.searchController.dimsBackgroundDuringPresentation = NO;
        // https://stackoverflow.com/questions/45997996/ios-11-uisearchbar-in-uinavigationbar/45999985#45999985
        UITextField *textField = [_searchController.searchBar valueForKey:@"searchField"];
        textField.tintColor = [UIColor colorWithPatternImage:JKImageMake(@"jarvis_navi_bkg")];
        textField.textColor = [UIColor darkTextColor];
        UIView *backgroundview = (UIView *)textField.subviews.firstObject;
        backgroundview.backgroundColor = [UIColor whiteColor];
        backgroundview.layer.cornerRadius = 10;
        backgroundview.clipsToBounds = YES;
        
        // 添加
        self.definesPresentationContext = YES;
        if (@available(iOS 11.0, *)) {
            self.navigationItem.searchController = self.searchController;
        } else {
            self.tableView.tableHeaderView = self.searchController.searchBar;
        }
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSAssert(self.shouldShowSearchBar, @"JKError: 需要使用UISearchController必须将`shouldShowSearchBar`属性设为YES");
    if ([self conformsToProtocol:@protocol(JKTableViewSearchResultUpdating)]) {
        NSString *searchText = searchController.searchBar.text ? searchController.searchBar.text : @"";
        __kindof JKTableViewController<JKTableViewSearchResultUpdating> *vc = (__kindof JKTableViewController<JKTableViewSearchResultUpdating> *)self;
        [vc searchResultsForTableView:self.tableView updatingResult:searchText];
    }
}

#pragma mark - setter & getter
- (void)setShouldShowSearchBar:(BOOL)shouldShowSearchBar
{
    BOOL isValueChanged = self.shouldShowSearchBar != shouldShowSearchBar;
    if (!isValueChanged) return;
    
    _shouldShowSearchBar = shouldShowSearchBar;
    if (shouldShowSearchBar) {
        [self initSearchController];
    } else {
        if (@available(iOS 11.0, *)) {
            if (self.searchController && self.navigationItem.searchController == self.searchController) {
                self.navigationItem.searchController = nil;
            }
        } else {
            if (self.tableView.tableHeaderView == self.searchController.searchBar) {
                self.tableView.tableHeaderView = nil;
            }
        }
        
        if (self.searchController) {
            self.searchController.delegate = nil;
            self.searchController.searchResultsUpdater = nil;
            self.searchController = nil;
        }
    }
}

- (BOOL)isSearchActive
{
    if (!self.shouldShowSearchBar) {
        return NO;
    }
    if (!self.searchController) {
        return NO;
    }
    return self.searchController.isActive;
}

- (BOOL)searchBarHasText
{
    if (!self.isSearchActive) {
        return NO;
    }
    return self.searchController.searchBar.text.length;
}

@end

@implementation JKTableViewController (JK_SubclassingHooks)

- (void)jk_initTableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:_tableView];
    }
}

- (void)jk_layoutTableView
{
    BOOL shouldChangeTableViewFrame = !CGRectEqualToRect(self.view.bounds, self.tableView.frame);
    if (shouldChangeTableViewFrame) {
        self.tableView.frame = self.view.bounds;
    }
}

@end


