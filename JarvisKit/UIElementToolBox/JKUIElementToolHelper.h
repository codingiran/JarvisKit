//
//  JKUIElementToolHelper.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/29.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKUIElementToolHelper : JKHelper

/**
 获取视图上某一点的颜色

 @param point 视图上的点
 @param view 视图
 @return 颜色对象
 */
+ (UIColor *)jk_getColorWithPoint:(CGPoint)point inView:(UIView *)view;

@end


@interface UIColor (JKUIElementTool)

/**
 将当前色值转换为hex字符串，通道排序是AARRGGBB（与Android保持一致）
 */
- (nullable NSString *)jk_hexString;

/**
 获取当前UIColor对象里的红色色值
 
 @return 红色通道的色值，值范围为0.0-1.0
 */
- (CGFloat)jk_red;

/**
 获取当前UIColor对象里的绿色色值
 
 @return 绿色通道的色值，值范围为0.0-1.0
 */
- (CGFloat)jk_green;

/**
 获取当前UIColor对象里的蓝色色值
 
 @return 蓝色通道的色值，值范围为0.0-1.0
 */
- (CGFloat)jk_blue;

/**
 获取当前UIColor对象里的透明色值
 
 @return 透明通道的色值，值范围为0.0-1.0
 */
- (CGFloat)jk_alpha;

/**
 获取当前UIColor对象里的hue（色相）
 */
- (CGFloat)jk_hue;

/**
 获取当前UIColor对象里的saturation（饱和度）
 */
- (CGFloat)jk_saturation;

/**
 获取当前UIColor对象里的brightness（亮度）
 */
- (CGFloat)jk_brightness;

@end

NS_ASSUME_NONNULL_END
