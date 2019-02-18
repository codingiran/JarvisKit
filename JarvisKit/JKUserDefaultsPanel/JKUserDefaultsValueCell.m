//
//  JKUserDefaultsValueCell.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/4.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKUserDefaultsValueCell.h"
#import "JKUserDefaultsModel.h"

@interface JKUserDefaultsValueCell ()

@property(nonatomic, strong) UILabel *valueLabel;
@property(nonatomic, strong) UILabel *valueTypeLabel;

@end

@implementation JKUserDefaultsValueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.valueTypeLabel = [UILabel new];
        self.valueTypeLabel.textAlignment = NSTextAlignmentLeft;
        self.valueTypeLabel.numberOfLines = 1;
        self.valueTypeLabel.textColor = [UIColor lightGrayColor];
        self.valueTypeLabel.font = [UIFont systemFontOfSize:15];
        
        self.valueLabel = [UILabel new];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.numberOfLines = 0;
        self.valueLabel.textColor = [UIColor darkTextColor];
        self.valueLabel.font = [UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:self.valueTypeLabel];
        [self.contentView addSubview:self.valueLabel];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.valueTypeLabel sizeToFit];
    self.valueTypeLabel.frame = CGRectMake(15, (self.contentView.frame.size.height - self.valueTypeLabel.frame.size.height) * 0.5, self.valueTypeLabel.frame.size.width, self.valueTypeLabel.frame.size.height);
    
    [self.valueLabel sizeToFit];
    self.valueLabel.frame = CGRectMake(CGRectGetMaxX(self.valueTypeLabel.frame) + 10, (self.contentView.frame.size.height - self.valueLabel.frame.size.height) * 0.5, self.contentView.frame.size.width - CGRectGetMaxX(self.valueTypeLabel.frame) - 10 - 18, self.valueLabel.frame.size.height);
}

- (void)setUserDefaultsModel:(JKUserDefaultsModel *)userDefaultsModel
{
    _userDefaultsModel = userDefaultsModel;
    
    if (userDefaultsModel.selectable) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    self.valueLabel.text = [NSString stringWithFormat:@"%@",userDefaultsModel.displayValue];
    self.valueTypeLabel.text = [NSString stringWithFormat:@"%@",userDefaultsModel.displayValueType];
    
}

@end
