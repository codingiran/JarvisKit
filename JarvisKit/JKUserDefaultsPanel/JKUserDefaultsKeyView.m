//
//  JKUserDefaultsKeyView.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/4.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKUserDefaultsKeyView.h"
#import "UIView+JarvisKit.h"

@interface JKUserDefaultsKeyView ()

@property(nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation JKUserDefaultsKeyView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [UILabel new];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        
        // 移除系统自带控件
        self.textLabel.hidden = YES;
        self.detailTextLabel.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    CGRect titleFrame = self.titleLabel.frame;
    
    // 计算布局
    titleFrame.origin.x = self.contentEdgeInsets.left;
    titleFrame.size.width = self.contentView.jk_width - self.contentEdgeInsets.left - self.contentEdgeInsets.right;
    titleFrame.origin.y = ((self.contentView.jk_height - self.contentEdgeInsets.top - self.contentEdgeInsets.bottom) - self.titleLabel.jk_height) * 0.5 + self.contentEdgeInsets.top;
    
    self.titleLabel.frame = titleFrame;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize resultSize = size;
    
    CGFloat titleLabelWidth = size.width - self.contentEdgeInsets.left - self.contentEdgeInsets.right;
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(titleLabelWidth, CGFLOAT_MAX)];
    resultSize.height = titleLabelSize.height + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    
    return resultSize;
}

#pragma mark - setter & getter
- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
{
    _contentEdgeInsets = contentEdgeInsets;
    [self setNeedsLayout];
}


@end
