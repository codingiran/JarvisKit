//
//  JKNetCaptureListViewController.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/16.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKNetCaptureListViewController.h"
#import "JKNetCaptureDetailViewController.h"
#import "JKNetCaptureDataSource.h"
#import "JKNetCaptureListCell.h"
#import "JKPerformanceManager.h"

static NSString * const kTableViewResuseIdentifier = @"JKNetCaptureListCell";

@interface JKNetCaptureListViewController ()<JKTableViewSearchResultUpdating>

/// 从JkURLProtocol拿到的抓包数据
@property(nonatomic, copy) NSArray<JKNetCaptureModel *> *allNetCaptureModelList;

/// `allNetCaptureModelList`搜索过滤的数组
@property(nonatomic, copy) NSArray<JKNetCaptureModel *> *filterdModelList;

@end

@implementation JKNetCaptureListViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.allNetCaptureModelList = [NSArray array];
        self.filterdModelList = [NSArray array];
        // 搜索
        self.shouldShowSearchBar = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allNetCaptureModelList = [JKNetCaptureDataSource sharedDataSource].httpCaptureModelArray.copy;
}

- (void)jk_initTableView
{
    [super jk_initTableView];
    
    [self.tableView registerClass:[JKNetCaptureListCell class] forCellReuseIdentifier:kTableViewResuseIdentifier];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = refreshControl;
    } else {
    }
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    
    self.navigationTitle = @"网络抓包列表";
    UISwitch *switcher = [[UISwitch alloc] init];
    switcher.tintColor = JKThemeColor;
    switcher.on = [JKNetCaptureDataSource sharedDataSource].netCaptureActive;
    [switcher addTarget:self action:@selector(switcher:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *switchActive = [[UIBarButtonItem alloc] initWithCustomView:switcher];
    self.navigationItem.rightBarButtonItems = @[switchActive];
}

#pragma mark - touch event

- (void)switcher:(UISwitch *)switcher
{
    [JKNetCaptureDataSource sharedDataSource].netCaptureActive = switcher.isOn;
    
    // 关闭抓包时，流量监控也要跟着关闭
    if (!switcher.isOn && [JKPerformanceManager sharedManager].flowActive) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"关闭抓包工具后，流量监控将跟随关闭" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [JKPerformanceManager sharedManager].flowActive = NO;
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:NULL];
    }
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
    if (self.isSearchActive) {
        self.searchController.active = NO;
    }
    [JKNetCaptureDataSource.sharedDataSource empty];
    self.allNetCaptureModelList = nil;
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 10.0, *)) {
            [self.tableView.refreshControl endRefreshing];
        } else {
            
        }
    });
}

- (void)clearAllRecord
{
    [[JKNetCaptureDataSource sharedDataSource] empty];
    self.allNetCaptureModelList = [JKNetCaptureDataSource sharedDataSource].httpCaptureModelArray.copy;
    [self.tableView reloadData];
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearchActive && self.searchBarHasText) {
        return self.filterdModelList.count;
    } else {
        return self.allNetCaptureModelList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKNetCaptureListCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewResuseIdentifier];
    if (self.isSearchActive && self.searchBarHasText) {
        cell.netCaptureModel = self.filterdModelList[indexPath.row];
    } else {
        cell.netCaptureModel = self.allNetCaptureModelList[indexPath.row];
    }
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKNetCaptureModel *model;
    if (self.isSearchActive && self.searchBarHasText) {
        model = self.filterdModelList[indexPath.row];
    } else {
        model = self.allNetCaptureModelList[indexPath.row];
    }
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JKNetCaptureModel *model;
    if (self.isSearchActive && self.searchBarHasText) {
        model = self.filterdModelList[indexPath.row];
    } else {
        model = self.allNetCaptureModelList[indexPath.row];
    }
    
    JKNetCaptureDetailViewController *netCaptureDetailViewController = [[JKNetCaptureDetailViewController alloc] initWithNetCaptureModel:model];
    [self.navigationController pushViewController:netCaptureDetailViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        JKNetCaptureModel *model;
        if (self.isSearchActive && self.searchBarHasText) {
            model = self.filterdModelList[indexPath.row];
        } else {
            model = self.allNetCaptureModelList[indexPath.row];
        }
        [JKNetCaptureDataSource.sharedDataSource removeHttpCaptureModel:model];
        self.filterdModelList = JKNetCaptureDataSource.sharedDataSource.httpCaptureModelArray.copy;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - JKTableViewSearchResultUpdating
- (void)searchResultsForTableView:(UITableView *)tableView updatingResult:(NSString *)resultString
{
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"url CONTAINS[c] %@", resultString];
    //过滤数据
    self.filterdModelList = [self.allNetCaptureModelList filteredArrayUsingPredicate:preicate];
    //刷新表格
    [self.tableView reloadData];
}

@end
