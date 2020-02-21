//
//  JKSwitchAccessoryCell.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/23.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKSwitchAccessoryCell.h"
#import "JKMacro.h"
#import "UIView+JarvisKit.h"

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
        self.switcher.tintColor = JKColorMake(225, 226, 227);
        [self.switcher addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.switcher];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.switcher sizeToFit];
    self.switcher.frame = CGRectMake(self.contentView.jk_width - 15 - self.switcher.jk_width, (self.contentView.jk_height -  self.switcher.jk_height) * 0.5, self.switcher.jk_width, self.switcher.jk_height);
}

#pragma mark - public method
- (void)setSwitchOn:(BOOL)on
{
    if (!self.showSwitch) return;
    if (self.switcher) {
        BOOL hasChange = on != self.switcher.isOn;
        if (!hasChange) return;
        [self.switcher setOn:on];
    }
}

#pragma mark - touch event

- (void)switchValueChanged:(UISwitch *)switcher
{
    if (!self.showSwitch) return;
    if (self.switchValueChangedResult) {
        self.switchValueChangedResult(self, switcher, switcher.isOn);
    }
}

#pragma mark - setter & getter

- (void)setShowSwitch:(BOOL)showSwitch
{
    _showSwitch = showSwitch;
    self.switcher.hidden = !_showSwitch;
    self.accessoryType = _showSwitch ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle =  _showSwitch ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
}

@end
