//
//  JKUserDefaultsValueCell.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/4.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKUserDefaultsValueCell.h"
#import "JKUserDefaultsModel.h"
#import "JKHelper.h"

@interface JKUserDefaultsValueCell ()

@property(nonatomic, strong) UIView *keyBackgroudView;
@property(nonatomic, strong) UILabel *keyLabel;

@property(nonatomic, strong) UIView *valueBackgroudView;
@property(nonatomic, strong) UILabel *valueLabel;
@property(nonatomic, strong) UILabel *valueTypeLabel;

@property(nonatomic, strong) UIImageView *arrow;

@end

@implementation JKUserDefaultsValueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.keyBackgroudView = [UIView new];
        self.keyBackgroudView.backgroundColor = JKColorMake(229, 229, 229);
        
        self.keyLabel = [UILabel new];
        self.keyLabel.adjustsFontSizeToFitWidth = YES;
        self.keyLabel.textAlignment = NSTextAlignmentLeft;
        self.keyLabel.numberOfLines = 1;
        self.keyLabel.textColor = [UIColor darkTextColor];
        self.keyLabel.font = [UIFont systemFontOfSize:17];
        
        self.valueBackgroudView = [UIView new];
        self.valueBackgroudView.backgroundColor = [UIColor whiteColor];
        
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
        
        self.arrow = [[UIImageView alloc] initWithImage:JKImageMake(@"jarvis_cell_accessArrow")];
        
        [self addSubview:self.keyBackgroudView];
        [self.keyBackgroudView addSubview:self.keyLabel];
        
        [self addSubview:self.valueBackgroudView];
        [self.valueBackgroudView addSubview:self.valueTypeLabel];
        [self.valueBackgroudView addSubview:self.valueLabel];
        [self.valueBackgroudView addSubview:self.arrow];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize resultSize = CGSizeMake(size.width, 0);
    
    // key bkg 高度
    resultSize.height += self.needShowKey ? 44.f : 0.f;
    
    if (!self.userDefaultsModel.selectable) {
        // value top
        resultSize.height += 12.f;
        
        // value type width
        CGSize valueTypeSize = [self.valueTypeLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        CGFloat valueTypeWidth = valueTypeSize.width;
        
        CGFloat valueWidth = resultSize.width - 15 - valueTypeWidth - 18;
        CGSize valueSize = [self.valueLabel sizeThatFits:CGSizeMake(valueWidth, CGFLOAT_MAX)];
        // value height
        resultSize.height += MAX(valueSize.height, 20);// give a min height 20px
        
        // value bottom
        resultSize.height += 12.f;
    } else {
        resultSize.height += 44.f;
    }
    
    return resultSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.keyBackgroudView.frame = CGRectMake(0, 0, self.jk_width, self.needShowKey ? self.jk_height * 0.5 : 0.f);
    CGFloat keyLabelWidth = self.jk_width - 30.f;
    CGSize keyLabelSize = [self.keyLabel sizeThatFits:CGSizeMake(keyLabelWidth, CGFLOAT_MAX)];
    self.keyLabel.frame = CGRectMake(15, (self.keyBackgroudView.jk_height - self.keyLabel.jk_height) * 0.5, keyLabelWidth, keyLabelSize.height);
    
    self.valueBackgroudView.frame = CGRectMake(0, self.keyBackgroudView.jk_bottom, self.jk_width, self.jk_height - self.keyBackgroudView.jk_height);
    
    [self.valueTypeLabel sizeToFit];
    self.valueTypeLabel.frame = CGRectMake(15, (self.valueBackgroudView.jk_height - self.valueTypeLabel.jk_height) * 0.5, self.valueTypeLabel.jk_width, self.valueTypeLabel.jk_height);
    
    [self.valueLabel sizeToFit];
    self.valueLabel.frame = CGRectMake(self.valueTypeLabel.jk_right + 10, (self.valueBackgroudView.jk_height - self.valueLabel.jk_height) * 0.5, self.valueBackgroudView.jk_width - self.valueTypeLabel.jk_right - 10 - 18, self.valueLabel.jk_height);
    
    [self.arrow sizeToFit];
    self.arrow.frame = CGRectMake(self.valueBackgroudView.jk_width - 20.f - self.arrow.jk_width, (self.valueBackgroudView.jk_height - self.arrow.jk_height) * 0.5, self.arrow.jk_width, self.arrow.jk_height);
}

- (void)setUserDefaultsModel:(JKUserDefaultsModel *)userDefaultsModel
{
    _userDefaultsModel = userDefaultsModel;
    
    self.selectionStyle = _userDefaultsModel.selectable ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    self.arrow.hidden = !_userDefaultsModel.selectable;
    self.keyBackgroudView.hidden = !self.needShowKey;
    self.keyLabel.text = self.needShowKey ? [NSString stringWithFormat:@"%@", _userDefaultsModel.key] : nil;
    self.valueLabel.text = [NSString stringWithFormat:@"%@",_userDefaultsModel.displayValue];
    self.valueTypeLabel.text = [NSString stringWithFormat:@"%@",_userDefaultsModel.displayValueType];
}

@end
