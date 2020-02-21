//
//  UIImage+JarvisKit.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/30.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (JarvisKit)

/**
 对传进来的 `UIView` 截图，生成一个 `UIImage` 并返回。注意这里使用的是 view.layer 来渲染图片内容。
 
 @param view 要截图的 `UIView`
 
 @return `UIView` 的截图
 
 @warning UIView 的 transform 并不会在截图里生效
 */
+ (UIImage *)jk_imageWithView:(UIView *)view;

/**
 对传进来的 `UIView` 截图，生成一个 `UIImage` 并返回。注意这里使用的是 iOS 7的系统截图接口。
 
 @param view         要截图的 `UIView`
 @param afterUpdates 是否要在界面更新完成后才截图
 
 @return `UIView` 的截图
 
 @warning UIView 的 transform 并不会在截图里生效
 */
+ (UIImage *)jk_imageWithView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates;

/**
 切割出在指定位置中的图片
 
 @param rect 要切割的rect
 
 @return 切割后的新图片
 */
- (UIImage *)jk_imageWithClippedRect:(CGRect)rect;

/**
 获取图片上某个点的颜色 Hex

 @param point 需要获取 image 上的点坐标
 @return RGB 字符串(R,G,B,A)
 */
- (NSString *)jk_HexColorStringAtPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
