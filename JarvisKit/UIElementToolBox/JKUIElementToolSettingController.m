//
//  JKUIElementToolSettingController.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/28.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKUIElementToolSettingController.h"
#import "JKSwitchAccessoryCell.h"
#import "JKUIElementToolManager.h"
#import "JKHelper.h"

@interface JKUIElementToolSettingController ()

@property(nonatomic, copy) NSArray<NSString *> *dataSource;

@end

@implementation JKUIElementToolSettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = @[@"颜色拾取器", @"元素标尺", @"元素边框线", @"元素组件"];
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    self.navigationTitle = @"UI元素调试工具";
}

#pragma mark - private method
- (void)handleSwitchValue:(BOOL)on ofCell:(JKSwitchAccessoryCell *)cell
{
    NSString *text = cell.textLabel.text;
    NSInteger index = [self.dataSource indexOfObject:text];
    
    switch (index) {
        case 0:// color
        {
            [[JKUIElementToolManager sharedManager] setColorPickerActive:on];
        }
            break;
        case 1:// ruler
        {
            [[JKUIElementToolManager sharedManager] setFrameRulerActive:on];
        }
            break;
        case 2:// border
        {
            [[JKUIElementToolManager sharedManager] setViewBorderActive:on];
        }
            break;
        case 3:// component
        {
            [[JKUIElementToolManager sharedManager] setViewComponentActive:on];
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
        case 0:// color
        {
            [cell setSwitchOn:[JKUIElementToolManager sharedManager].colorPickerActive];
        }
            break;
        case 1:// ruler
        {
            [cell setSwitchOn:[JKUIElementToolManager sharedManager].frameRulerActive];
        }
            break;
        case 2:// border
        {
            [cell setSwitchOn:[JKUIElementToolManager sharedManager].viewBorderActive];
        }
            break;
        case 3:// component
        {
            [cell setSwitchOn:[JKUIElementToolManager sharedManager].viewComponentActive];
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
