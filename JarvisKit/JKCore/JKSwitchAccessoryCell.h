//
//  JKSwitchAccessoryCell.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/23.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKSwitchAccessoryCell : UITableViewCell

@property(nonatomic, assign) BOOL showSwitch;

/// UISwitch开关回调，做好weakSelf防护
@property(nonatomic, copy) void (^switchValueChangedResult)(JKSwitchAccessoryCell *cell ,UISwitch *switcher, BOOL on);

/// 初始化方法
+ (instancetype)switchAccessoryCellWithStyle:(UITableViewCellStyle)style inTableView:(UITableView *)tableView;
+ (instancetype)switchAccessoryCellInTableView:(UITableView *)tableView;

- (void)setSwitchOn:(BOOL)on;

@end

NS_ASSUME_NONNULL_END
