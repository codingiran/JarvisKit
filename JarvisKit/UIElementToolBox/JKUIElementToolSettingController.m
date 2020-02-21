//
//  JKUIElementToolSettingController.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/28.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKUIElementToolSettingController.h"
#import "JKSwitchAccessoryCell.h"
#import "JKUIElementToolManager.h"
#import "JKHelper.h"

static NSString * const kColorMeter = @"颜色拾取器";
static NSString * const kUIElement = @"UI元素信息";
static NSString * const k3DChecker = @"3D UI界面调试";
static NSString * const kLookInExport = @"导出 Lookin 文件";

@interface JKUIElementToolSettingController ()

@property(nonatomic, copy) NSArray<NSString *> *dataSource;

@end

@implementation JKUIElementToolSettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *dataSource = @[kColorMeter].mutableCopy;
    if (NSClassFromString(@"Lookin")) {
        [dataSource addObject:kUIElement];
        [dataSource addObject:k3DChecker];
        [dataSource addObject:kLookInExport];
    }
    self.dataSource = dataSource.copy;
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    self.navigationTitle = @"UI 调试工具";
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
    cell.textLabel.text = self.dataSource[indexPath.row];
    NSInteger index = indexPath.row;
    cell.showSwitch = NO;
    switch (index) {
        case 0:// color
        {
            cell.showSwitch = YES;
            [cell setSwitchOn:[JKUIElementToolManager sharedManager].colorPickerActive];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKSwitchAccessoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:kUIElement]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];
            });
        }];
    }
    if ([cell.textLabel.text isEqualToString:k3DChecker]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
            });
        }];
    }
    if ([cell.textLabel.text isEqualToString:kLookInExport]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
            });
        }];
    }
}

@end
