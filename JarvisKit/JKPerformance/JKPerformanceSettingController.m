//
//  JKPerformanceSettingController.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/23.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKPerformanceSettingController.h"
#import "JKSwitchAccessoryCell.h"
#import "JKPerformanceManager.h"
#import "JKHelper.h"

@interface JKPerformanceSettingController ()

@property(nonatomic, copy) NSArray<NSString *> *dataSource;

@end

@implementation JKPerformanceSettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = @[@"FPS-帧率实时显示", @"CPU-占用率", @"RAM-内存使用", @"FLOW-网络流量"];
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    self.navigationTitle = @"性能检测工具";
}

#pragma mark - private method
- (void)handleSwitchValue:(BOOL)on ofCell:(JKSwitchAccessoryCell *)cell
{
    NSString *text = cell.textLabel.text;
    NSInteger index = [self.dataSource indexOfObject:text];
    
    switch (index) {
        case 0:// fps
        {
            [[JKPerformanceManager sharedManager] setFpsActive:on];
        }
            break;
        case 1:// cpu
        {
            [[JKPerformanceManager sharedManager] setCpuActive:on];
        }
            break;
        case 2:// ram
        {
            [[JKPerformanceManager sharedManager] setRamActive:on];
        }
            break;
        case 3:// flow
        {
            [[JKPerformanceManager sharedManager] setFlowActive:on];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKSwitchAccessoryCell *cell = [JKSwitchAccessoryCell switchAccessoryCellInTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.row];
    NSInteger index = indexPath.row;
    switch (index) {
        case 0:// fps
        {
            [cell setSwitchOn:JKFPSActiveStatus];
        }
            break;
        case 1:// cpu
        {
            [cell setSwitchOn:JKCPUActiveStatus];
        }
            break;
        case 2:// ram
        {
            [cell setSwitchOn:JKRAMActiveStatus];
        }
            break;
        case 3:// flow
        {
            [cell setSwitchOn:JKFLOWActiveStatus];
        }
            break;
            
        default:
            break;
    }
    
    __weak __typeof(self)weakSelf = self;
    cell.switchValueChangedResult = ^(JKSwitchAccessoryCell * _Nonnull cell, UISwitch * _Nonnull switcher, BOOL on) {
        [weakSelf handleSwitchValue:on ofCell:cell];
    };
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


@end
