//
//  JKCrashLogListViewController.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/11.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKCrashLogListViewController.h"
#import "JKCrashLogDetailViewController.h"
#import "JKCrashLogListCell.h"
#import "JKCrashLogModel.h"
#import "JKSandboxHelper.h"

static NSString * const kTableViewReuseIdentifier = @"JKCrashLogListCell";

@interface JKCrashLogListViewController ()

@property(nonatomic, copy) NSArray<NSArray<JKCrashLogModel *> *> *crashLogList;

@end

@implementation JKCrashLogListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.crashLogList = [JKCrashLogHelper jk_sectionCrashList];
}

- (void)jk_initTableView
{
    [super jk_initTableView];
    
    [self.tableView registerClass:[JKCrashLogListCell class] forCellReuseIdentifier:kTableViewReuseIdentifier];
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    
    self.navigationTitle = @"奔溃日志";
    
    UISwitch *switcher = [[UISwitch alloc] init];
    switcher.tintColor = JKColorMake(225, 226, 227);
    switcher.on = [JKCrashLogHelper jk_crashLogActivate];
    [switcher addTarget:self action:@selector(switcher:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *switchActive = [[UIBarButtonItem alloc] initWithCustomView:switcher];
    self.navigationItem.rightBarButtonItems = @[switchActive];
}

#pragma mark - touch event
- (void)switcher:(UISwitch *)switcher
{
    [JKCrashLogHelper jk_setCrashLogActive:switcher.isOn];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.crashLogList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.crashLogList[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKCrashLogListCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewReuseIdentifier];
    cell.crashLogModel = self.crashLogList[indexPath.section][indexPath.row];
    return cell;
}


#pragma mark - table view delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.crashLogList[section].firstObject.crashDateShortString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKCrashLogDetailViewController *crashLogDetailViewController = [[JKCrashLogDetailViewController alloc] initWithCrashLogModel:self.crashLogList[indexPath.section][indexPath.row]];
    [self.navigationController pushViewController:crashLogDetailViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 删除沙盒文件
        JKCrashLogModel *model = self.crashLogList[indexPath.section][indexPath.row];
        [JKSandboxHelper removeFileOfPath:model.crashFilePath];
//        NSAssert(delete, @"JKError: ****Crash日志文件无法删除！****");
        // 删除数据源
        NSMutableArray<NSArray<JKCrashLogModel *> *> *dataArray = self.crashLogList.mutableCopy;
        NSMutableArray<JKCrashLogModel *> *sectionDataArray = dataArray[indexPath.section].mutableCopy;
        [sectionDataArray removeObjectAtIndex:indexPath.row];
        [dataArray replaceObjectAtIndex:indexPath.section withObject:sectionDataArray.copy];
        self.crashLogList = dataArray.copy;
        // 删除cell
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    return @[deleteAction];
}

@end
