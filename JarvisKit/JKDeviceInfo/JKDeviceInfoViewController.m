//
//  JKDeviceInfoViewController.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/7.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKDeviceInfoViewController.h"
#import "JKDeviceInfoHelper.h"

static NSString * const kTableViewCellReuseIdentifier = @"DeviceInfoCell";

@interface JKDeviceInfoViewController ()

@property(nonatomic, copy) NSArray<NSDictionary *> *dataArray;

@end

@implementation JKDeviceInfoViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.dataArray = [self getDataArrayWithNetAuthority:@"Unknown"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak __typeof(self)weakSelf = self;
    [JKDeviceInfoHelper fetchNetAuthorityWithCompletion:^(NSString * _Nonnull authority) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.dataArray = [strongSelf getDataArrayWithNetAuthority:authority];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([strongSelf isViewLoaded]) {
                [strongSelf.tableView reloadData];
            }
        });
    }];
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    self.navigationTitle = @"App与设备信息";
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section][@"array"];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kTableViewCellReuseIdentifier];
    }
    
    NSArray *array = self.dataArray[indexPath.section][@"array"];
    NSDictionary *dict = array[indexPath.row];
    
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.text = dict[@"value"];
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.dataArray[section][@"title"];
}

#pragma mark - setter & getter

- (NSArray *)getDataArrayWithNetAuthority:(NSString *)netAuthority
{
    NSArray<NSDictionary *> *array = @[
                                       @{@"title" : @"设备信息", @"array" : @[@{@"title" : @"手机型号", @"value" : [JKDeviceInfoHelper deviceModel]}, @{@"title" : @"系统版本", @"value" : [JKDeviceInfoHelper iOSVersion]}, @{@"title" : @"手机容量", @"value" : [JKDeviceInfoHelper deviceCapacity]}, @{@"title" : @"是否越狱", @"value" : [JKDeviceInfoHelper isJailbreak]}]
                                         },
                                       @{@"title" : @"App信息", @"array" : @[@{@"title" : @"App名称", @"value" : [JKDeviceInfoHelper appDisplayName]}, @{@"title" : @"Bundle ID", @"value" : [JKDeviceInfoHelper bundleId]}, @{@"title" : @"Version", @"value" : [JKDeviceInfoHelper appVersion]}, @{@"title" : @"Build", @"value" : [JKDeviceInfoHelper buildVersion]}, @{@"title" : @"最低支持版本", @"value" : [JKDeviceInfoHelper minimumOSVersion]}]
                                         },
                                       @{@"title" : @"授权信息", @"array" : @[@{@"title" : @"推送授权", @"value" : [JKDeviceInfoHelper pushAuthority]}, @{@"title" : @"网络授权", @"value" : netAuthority}, @{@"title" : @"相机授权", @"value" : [JKDeviceInfoHelper cameraAuthority]}, @{@"title" : @"相册授权", @"value" : [JKDeviceInfoHelper photoAuthority]}, @{@"title" : @"定位授权", @"value" : [JKDeviceInfoHelper locationAuthority]}, @{@"title" : @"麦克风授权", @"value" : [JKDeviceInfoHelper audioAuthority]}, @{@"title" : @"通讯录授权", @"value" : [JKDeviceInfoHelper addressAuthority]}, @{@"title" : @"日历授权", @"value" : [JKDeviceInfoHelper calendarAuthority]}, @{@"title" : @"提醒事项授权", @"value" : [JKDeviceInfoHelper remindAuthority]},]
                                         },
                                       ];
    return array;
}


@end
