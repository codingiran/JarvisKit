//
//  UIView+JarvisKit.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/9.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "UIView+JarvisKit.h"
#import "UIImage+JarvisKit.h"
#import "JKCommonDefines.h"

@implementation UIView (JarvisKit)

- (instancetype)jk_initWithSize:(CGSize)size
{
    return [self initWithFrame:JKRectMakeWithSize(size)];
}

- (void)jk_removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)jk_removeSubViewsOfType:(__kindof UIView *)subviewType
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[subviewType class]]) {
            [obj removeFromSuperview];
        }
    }];
}

@end

@implementation UIView (JK_Layout)

- (CGFloat)jk_top
{
    return CGRectGetMinY(self.frame);
}

- (void)setJk_top:(CGFloat)top
{
    self.frame = JKRectSetY(self.frame, top);
}

- (CGFloat)jk_left
{
    return CGRectGetMinX(self.frame);
}

- (void)setJk_left:(CGFloat)left
{
    self.frame = JKRectSetX(self.frame, left);
}

- (CGFloat)jk_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setJk_bottom:(CGFloat)bottom
{
    self.frame = JKRectSetY(self.frame, bottom - CGRectGetHeight(self.frame));
}

- (CGFloat)jk_right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setJk_right:(CGFloat)right
{
    self.frame = JKRectSetX(self.frame, right - CGRectGetWidth(self.frame));
}

- (CGFloat)jk_width
{
    return CGRectGetWidth(self.frame);
}

- (void)setJk_width:(CGFloat)width
{
    self.frame = JKRectSetWidth(self.frame, width);
}

- (CGFloat)jk_height
{
    return CGRectGetHeight(self.frame);
}

- (void)setJk_height:(CGFloat)height
{
    self.frame = JKRectSetHeight(self.frame, height);
}

- (CGFloat)jk_centerX
{
    return self.center.x;
}

- (void)setJk_centerX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)jk_centerY
{
    return self.center.y;
}

- (void)setJk_centerY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

@end


@implementation UIView (jk_Snapshotting)

- (UIImage *)jk_snapshotLayerImage {
    return [UIImage jk_imageWithView:self];
}

- (UIImage *)jk_snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates {
    return [UIImage jk_imageWithView:self afterScreenUpdates:afterScreenUpdates];
}

@end
