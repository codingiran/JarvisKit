//
//  JKMagnifierView.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/28.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKMagnifierView.h"
#import "JKHelper.h"

@interface JKMagnifierView ()

/// 中间的圆点
@property(nonatomic, strong) UIView *dot;

/// 屏幕截图
@property(nonatomic, strong) UIImage *fullScreenSnapshot;

@end

@implementation JKMagnifierView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.magnifierSide = MAX(frame.size.width, frame.size.height);
        self.magnification = 2.0;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
        self.dot = [[UIView alloc] initWithFrame:JKRectWithSize(5, 5)];
        self.dot.backgroundColor = JKThemeColor;
//        [self addSubview:self.cutScreenImage];
        [self addSubview:self.dot];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.dot.center = CGPointMake(self.jk_width * 0.5, self.jk_height * 0.5);
}

#pragma mark - setter & getter

- (void)setMagnifierSide:(CGFloat)magnifierSide
{
    BOOL hasChange = magnifierSide != _magnifierSide;
    if (!hasChange) return;
    _magnifierSide = magnifierSide;
    NSAssert(magnifierSide > 50.0, @"JKWarning: 放大镜设置的太小了!");
    self.jk_width = magnifierSide;
    self.jk_height = magnifierSide;
    self.layer.cornerRadius = magnifierSide / 2;
    self.layer.masksToBounds = YES;
}

- (void)setMagnification:(CGFloat)magnification
{
    BOOL hasChange = magnification != _magnification;
    if (hasChange && magnification > 0) {
        _magnification = magnification;
    }
}

- (void)setTargetWindow:(UIView *)targetWindow
{
    _targetWindow = targetWindow;
    // 获取window的全屏截图
    if (!targetWindow) {
        self.fullScreenSnapshot = nil;
    }
    self.fullScreenSnapshot = [targetWindow jk_snapshotImageAfterScreenUpdates:YES];
}

- (void)setTargetPoint:(CGPoint)targetPoint
{
    _targetPoint = targetPoint;
    if (self.fullScreenSnapshot) {
        // 根据目标点获取截取的图
        CGRect clippedRect = CGRectMake(targetPoint.x - self.magnifierSide / self.magnification/ 2, targetPoint.y - self.magnifierSide / self.magnification / 2, self.magnifierSide / self.magnification, self.magnifierSide / self.magnification);
        UIImage *image = [self.fullScreenSnapshot jk_imageWithClippedRect:clippedRect];
        self.layer.contents = (__bridge id _Nullable)(image.CGImage);
    }
}

@end
