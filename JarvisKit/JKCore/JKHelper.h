//
//  JKHelper.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/8.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKNavigtionController.h"
#import "UIViewController+JarvisKit.h"
#import "JKViewController.h"
#import "UIView+JarvisKit.h"
#import "JKOrderedDictionary.h"
#import "JKMenuLabel.h"
#import "JKCommonDefines.h"
#import "JKMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKHelper : NSObject

/**
 获取JarvisKit.bundle内的图片
 
 @param name 图片名称
 @return 创建的图片对象
 */
+ (UIImage * _Nullable)jk_imageWithName:(NSString *)name;


/**
 获取状态栏的背景颜色
 */
+ (UIColor *)jk_getStatusBarColor;


/**
 设置状态栏颜色

 @param statuesBarColor 需要设置的颜色
 */
+ (void)jk_setStatusBarColorWith:(UIColor *)statuesBarColor;

/**
 获取1pixel像素高度
 */
+ (CGFloat)jk_pixelOne;


/**
 使用HEX命名方式的颜色字符串生成一个UIColor对象

 @param hexString #RGB #ARGB #RRGGBB #RRGGBB #AARRGGBB都支持
 @return UIColor对象
 */
+ (UIColor *)jk_colorWithHexString:(NSString *)hexString;

@end

@interface JKHelper (UIViewController)

/**
 @warning 可能拿到nil，表示当前窗口没有可视控制器
 
 @return 当前窗口的可视控制器
 */
+ (UIViewController * _Nullable)jk_visibleViewController;


@end


@interface JKHelper (UIDevice)

/**
 判断是否iPad
 */
+ (BOOL)jk_isIPad;

/**
 判断是否iPod
 */
+ (BOOL)jk_isIPod;

/**
 判断是否iPhone
 */
+ (BOOL)jk_isIPhone;

/**
 判断是否模拟器
 */
+ (BOOL)jk_isSimulator;

/**
 是否全面屏，iPhoneX以上以及18年iPad Pro等
 */
+ (BOOL)jk_isNotchedScreen;

/**
 用于获取 isNotchedScreen 设备的 insets，注意对于 iPad Pro 11-inch 这种无刘海凹槽但却有使用 Home Indicator 的设备，它的 top 返回0，bottom 返回 safeAreaInsets.bottom 的值
 */
+ (UIEdgeInsets)jk_safeAreaInsetsForDeviceWithNotch;


/**
 以375为基准的宽度比率
 */
+ (CGFloat)jk_screenRatio;


@end


@interface JKHelper (Unit)

/**
 将比特转为B KB MB GB...

 @param byte byte数据
 @return 格式化的字符串
 */
+ (NSString *)jk_getFormatUnitFromByte:(CGFloat)byte;

@end

NS_ASSUME_NONNULL_END
