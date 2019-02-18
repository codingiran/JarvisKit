//
//  JKSwitchAccessoryCell.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/23.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKSwitchAccessoryCell.h"
#import "JKMacro.h"

static NSString * const kTableViewReuseIdentifier = @"JKSwitchAccessoryCell";

@interface JKSwitchAccessoryCell ()

@property(nonatomic, strong) UISwitch *switcher;

@end

@implementation JKSwitchAccessoryCell

+ (instancetype)switchAccessoryCellInTableView:(UITableView *)tableView
{
    return [self switchAccessoryCellWithStyle:UITableViewCellStyleDefault inTableView:tableView];
}

+ (instancetype)switchAccessoryCellWithStyle:(UITableViewCellStyle)style inTableView:(UITableView *)tableView
{
    JKSwitchAccessoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewReuseIdentifier];
    if (!cell) {
        cell = [[JKSwitchAccessoryCell alloc] initWithStyle:style reuseIdentifier:kTableViewReuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.switcher = [[UISwitch alloc] init];
        self.switcher.onTintColor = JKThemeColor;
        self.accessoryView = self.switcher;
        [self.switcher addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}


#pragma mark - public method
- (void)setSwitchOn:(BOOL)on
{
    if (self.switcher) {
        BOOL hasChange = on != self.switcher.isOn;
        if (!hasChange) return;
        [self.switcher setOn:on];
    }
}

#pragma mark - touch event
- (void)switchValueChanged:(UISwitch *)switcher
{
    if (self.switchValueChangedResult) {
        self.switchValueChangedResult(self, switcher, switcher.isOn);
    }
}


@end
