//
//  JKMagnifierView.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/28.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKMagnifierView.h"
#import "JKHelper.h"

static CGFloat const kColorMeterHeight = 16.f;

@interface JKMagnifierView ()

@property(nonatomic, strong) JKMenuLabel *colorLabel;

@property(nonatomic, strong, readwrite) JKMagnifierLayer *magnifierLayer;

@end

@implementation JKMagnifierView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        self.backgroundColor = UIColor.clearColor;
        self.colorMeterPostion = JKColorMeterPostionDown;
        [self.layer addSublayer:self.magnifierLayer];
        [self addSubview:self.colorLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.magnifierLayer.frame = self.bounds;
    
    CGFloat colorLabelWidth = self.jk_width * 0.7;
    CGFloat colorLabelHeight = kColorMeterHeight;
    // ↑
    if (self.colorMeterPostion == JKColorMeterPostionUp) {
        self.colorLabel.frame = CGRectMake((self.jk_width - colorLabelWidth) * 0.5, self.jk_height * 0.5 - 10 - colorLabelHeight, colorLabelWidth, colorLabelHeight);
    }
    // ↖
    if (self.colorMeterPostion == JKColorMeterPostionUpLeft) {
        self.colorLabel.frame = CGRectMake(self.jk_width * 0.5 - colorLabelWidth, self.jk_height * 0.5 - 10 - colorLabelHeight, colorLabelWidth, colorLabelHeight);
    }
    // ↙
    if (self.colorMeterPostion == JKColorMeterPostionDownLeft) {
        self.colorLabel.frame = CGRectMake(self.jk_width * 0.5 - colorLabelWidth, self.jk_height * 0.5 + 10, colorLabelWidth, colorLabelHeight);
    }
    // ↓
    if (self.colorMeterPostion == JKColorMeterPostionDown) {
        self.colorLabel.frame = CGRectMake((self.jk_width - colorLabelWidth) * 0.5, self.jk_height * 0.5 + 10, colorLabelWidth, colorLabelHeight);
    }
    // ↘
    if (self.colorMeterPostion == JKColorMeterPostionDownRight) {
        self.colorLabel.frame = CGRectMake(self.jk_width * 0.5, self.jk_height * 0.5 + 10, colorLabelWidth, colorLabelHeight);
    }
    // ↗
    if (self.colorMeterPostion == JKColorMeterPostionUpRight) {
        self.colorLabel.frame = CGRectMake(self.jk_width * 0.5, self.jk_height * 0.5 - 10 - colorLabelHeight, colorLabelWidth, colorLabelHeight);
    }
}

#pragma mark - public method

- (void)setColorString:(NSString *)colorString
{
    _colorString = colorString.copy;
    self.colorLabel.text = _colorString;
}

#pragma mark - setter & getter

- (void)setColorMeterPostion:(JKColorMeterPostion)colorMeterPostion
{
    _colorMeterPostion = colorMeterPostion;
    if (_colorLabel) {
        [self setNeedsLayout];
    }
}

- (JKMenuLabel *)colorLabel
{
    if (!_colorLabel) {
        _colorLabel = [[JKMenuLabel alloc] init];
        _colorLabel.textAlignment = NSTextAlignmentCenter;
        _colorLabel.textColor = UIColor.lightTextColor;
        _colorLabel.font = [UIFont systemFontOfSize:12];
        _colorLabel.backgroundColor = UIColor.darkTextColor;
        _colorLabel.layer.cornerRadius = 8;
        _colorLabel.layer.masksToBounds = YES;
        _colorLabel.canPerformMenuAction = YES;
        _colorLabel.menuActionType = JKMenuActionTypeCopy;
    }
    return _colorLabel;
}

- (JKMagnifierLayer *)magnifierLayer
{
    if (!_magnifierLayer) {
        _magnifierLayer = [JKMagnifierLayer layer];
        _magnifierLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
    return _magnifierLayer;
}

@end
