//
//  JKSystemFontViewController.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/8.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKSystemFontViewController.h"
#import "JKFontLineHeightViewController.h"
#import "JKHelper.h"
#import "JKSandboxFilePreviewViewController.h"

static NSString * const kTableViewReuseIdentifier = @"SystemFontCell";
static NSString * const kDefaultChinese = @"废话少说，放码过来";

@interface JKSystemFontViewController ()<JKTableViewSearchResultUpdating>

//@property(nonatomic, strong) UISearchController *searchController;

/// 全部字体
@property(nonatomic, strong) NSMutableArray<UIFont *> *allSystemFonts;

/// 搜索出的结果
@property(nonatomic, strong) NSMutableArray<UIFont *> *filteredFonts;

/// 中文显示文字，默认为『中文的效果』
@property(nonatomic, copy) NSString *chineseDisplayText;

@end

@implementation JKSystemFontViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.allSystemFonts = [NSMutableArray array];
        self.filteredFonts = [NSMutableArray array];
        self.chineseDisplayText = kDefaultChinese;
        self.shouldShowSearchBar = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 加载数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSString *familyName in [UIFont familyNames]) {
            for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
                [self.allSystemFonts addObject:[UIFont fontWithName:fontName size:16]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self isViewLoaded]) {
                [self.tableView reloadData];
            }
        });
    });
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    
    self.navigationTitle = @"系统字体";
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItems = @[editItem];
}

#pragma mark - touch event
- (void)editAction:(UIBarButtonItem *)sender
{
    //添加提醒框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *changeText = [UIAlertAction actionWithTitle:@"更改展示文字" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *changeTextAlertController = [UIAlertController alertControllerWithTitle:@"修改显示的中文" message:nil preferredStyle:UIAlertControllerStyleAlert];
        __weak __typeof(self)weakSelf = self;
        [changeTextAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            textField.text = strongSelf.chineseDisplayText;
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
        UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = changeTextAlertController.textFields.firstObject;
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.chineseDisplayText = textField.text.length ? textField.text : kDefaultChinese;
            [strongSelf.tableView reloadData];
        }];
        [changeTextAlertController addAction:cancelAction];
        [changeTextAlertController addAction:submitAction];
        [self presentViewController:changeTextAlertController animated:YES completion:NULL];
  
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:changeText];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearchActive && self.searchBarHasText) {
        return self.filteredFonts.count;
    } else {
        return self.allSystemFonts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableViewReuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    }
    
    UIFont *font = [UIFont new];
    if (self.isSearchActive && self.searchBarHasText) {
        font = self.filteredFonts[indexPath.row];
    } else {
        font = self.allSystemFonts[indexPath.row];
    }
    
    cell.textLabel.font = font;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @(indexPath.row + 1), font.fontName];
    cell.detailTextLabel.font = font;
    cell.detailTextLabel.text = self.chineseDisplayText;
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fontName = @"";
    if (self.isSearchActive && self.searchBarHasText) {
        fontName = self.filteredFonts[indexPath.row].fontName;
    } else {
        fontName = self.allSystemFonts[indexPath.row].fontName;
    }
    if ([fontName containsString:@"Zapfino"]) {
        // 这个字体很飘逸，不够高是显示不全的，Thanks QMUI
        return 116;
    }
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKFontLineHeightViewController *fontLineHeightViewController = [[JKFontLineHeightViewController alloc] init];
    UIFont *font = nil;
    if (self.isSearchActive && self.searchBarHasText) {
        font = self.filteredFonts[indexPath.row];
    } else {
        font = self.allSystemFonts[indexPath.row];
    }
    fontLineHeightViewController.font = font;
    fontLineHeightViewController.displayText = self.chineseDisplayText;
    [self.navigationController pushViewController:fontLineHeightViewController animated:YES];
}

- (void)searchResultsForTableView:(UITableView *)tableView updatingResult:(NSString *)resultString
{
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"fontName CONTAINS[c] %@", resultString];
    [self.filteredFonts removeAllObjects];
    //过滤数据
    self.filteredFonts = [NSMutableArray arrayWithArray:[self.allSystemFonts filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}


@end
