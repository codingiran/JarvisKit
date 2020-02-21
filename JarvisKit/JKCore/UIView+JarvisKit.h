//
//  UIView+JarvisKit.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/9.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+JarvisKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JarvisKit)

/**
 == initWithFrame:CGRectMake(0, 0, size.width, size.height)
 
 @param size 初始化时的 size
 @return 初始化得到的实例
 */
- (instancetype)jk_initWithSize:(CGSize)size;

/**
 移除当前所有的 subviews
 */
- (void)jk_removeAllSubviews;

/**
 移除所有Class type为[subview class]的子视图
 */
- (void)jk_removeSubViewsOfType:(__kindof UIView *)subview;

@end


@interface UIView (JK_Layout)

/// == CGRectGetMinY(frame)
@property(nonatomic, assign) CGFloat jk_top;

/// == CGRectGetMinX(frame)
@property(nonatomic, assign) CGFloat jk_left;

/// == CGRectGetMaxY(frame)
@property(nonatomic, assign) CGFloat jk_bottom;

/// == CGRectGetMaxX(frame)
@property(nonatomic, assign) CGFloat jk_right;

/// == CGRectGetWidth(frame)
@property(nonatomic, assign) CGFloat jk_width;

/// == CGRectGetHeight(frame)
@property(nonatomic, assign) CGFloat jk_height;

/// == self.center.x
@property(nonatomic, assign) CGFloat jk_centerX;

/// == self.center.y
@property(nonatomic, assign) CGFloat jk_centerY;

@end


@interface UIView (JK_Snapshotting)

- (UIImage *)jk_snapshotLayerImage;
- (UIImage *)jk_snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates;

@end

NS_ASSUME_NONNULL_END
