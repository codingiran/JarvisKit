//
//  JKMacro.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/14.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Bundle资源
/// JarvisKit框架内获取bundle图片资源的方法
#define JKImageMake(img)           [JKHelper jk_imageWithName:img]

#pragma mark - UIDevice设备信息
/// 用户界面横屏了才会返回YES
#define JK_IS_LANDSCAPE UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
/// 无论支不支持横屏，只要设备横屏了，就会返回YES
#define JK_IS_DEVICE_LANDSCAPE UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

/// 设备的SafeAreaInsets，如果不是全面屏，则返回UIEdgeInsetsZero
#define JKSafeAreaInsets           [JKHelper jk_safeAreaInsetsForDeviceWithNotch]

/// 屏幕宽度，会根据横竖屏的变化而变化
#define JK_SCREEN_WIDTH            ([[UIScreen mainScreen] bounds].size.width)
/// 考虑了SafeArea的屏幕宽度
#define JK_SafeArea_SCREEN_WIDTH   (JK_SCREEN_WIDTH - JKSafeAreaInsets.left - JKSafeAreaInsets.right)

/// 屏幕高度，会根据横竖屏的变化而变化
#define JK_SCREEN_HEIGHT           ([[UIScreen mainScreen] bounds].size.height)
/// 考虑了SafeArea的屏幕高度
#define JK_SafeArea_SCREEN_HEIGHT  (JK_SCREEN_HEIGHT - JKSafeAreaInsets.top - JKSafeAreaInsets.bottom)

/// 一个像素的高度
#define JKPixelOne                 [JKHelper jk_pixelOne]

/// 设备类型
#define JK_IS_IPAD                 [JKHelper jk_isIPad]
#define JK_IS_IPOD                 [JKHelper jk_isIPod]
#define JK_IS_IPHONE               [JKHelper jk_isIPhone]
#define JK_IS_SIMULATOR            [JKHelper jk_isSimulator]
#define JK_IS_NotchedScreen        [JKHelper jk_isNotchedScreen]// 全面屏

#define JK_WIDTH_RATIO             [JKHelper jk_screenRatio]

#pragma mark - UIFont
/// 创建字体对象
#define JKFontMake(size)           [UIFont systemFontOfSize:size]
#define JKFontItalicMake(size)     [UIFont italicSystemFontOfSize:size] // Italic 对中文无效
#define JKFontBoldMake(size)       [UIFont boldSystemFontOfSize:size]
#define JKFontBoldWithFont(_font)  [UIFont boldSystemFontOfSize:_font.pointSize]

#pragma mark - UIColor
/// UIColor
#define JKColorMake(r, g, b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define JKColorMakeWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
#define JKColorMakeWithHex(hex)         [JKHelper jk_colorWithHexString:hex]
#define JKThemeColor                    JKColorMake(74, 144, 226)// 主题色
#define JKSeparatorColor                JKColorMake(200, 199, 204)


#pragma mark - Frame
#define JKRectWithSize(width, height)  JKRectMakeWithSize(CGSizeMake(width, height))
#define JKPerformanceLabelSize      CGSizeMake(55, 20)
#define JKPFSLabelFrame             CGRectMake(20, JK_SCREEN_HEIGHT * 0.10, JKPerformanceLabelSize.width, JKPerformanceLabelSize.height)
#define JKCPULabelFrame             CGRectMake(20, JK_SCREEN_HEIGHT * 0.15, JKPerformanceLabelSize.width, JKPerformanceLabelSize.height)
#define JKRAMLabelFrame             CGRectMake(20, JK_SCREEN_HEIGHT * 0.20, JKPerformanceLabelSize.width, JKPerformanceLabelSize.height)
#define JKFLOWLabelFrame            CGRectMake(20, JK_SCREEN_HEIGHT * 0.25, JKPerformanceLabelSize.width, JKPerformanceLabelSize.height)


#pragma mark - 忽略编译器警告
#define JKArgumentToString(macro) #macro
#define JKClangWarningConcat(warning_name) JKArgumentToString(clang diagnostic ignored warning_name)

/// 参数可直接传入 clang 的 warning 名，warning 列表参考：https://clang.llvm.org/docs/DiagnosticsReference.html
#define JKBeginIgnoreClangWarning(warningName) _Pragma("clang diagnostic push") _Pragma(JKClangWarningConcat(#warningName))
#define JKEndIgnoreClangWarning _Pragma("clang diagnostic pop")

#define JKBeginIgnorePerformSelectorLeaksWarning JKBeginIgnoreClangWarning(-Warc-performSelector-leaks)
#define JKEndIgnorePerformSelectorLeaksWarning JKEndIgnoreClangWarning

#define JKBeginIgnoreAvailabilityWarning JKBeginIgnoreClangWarning(-Wpartial-availability)
#define JKEndIgnoreAvailabilityWarning JKEndIgnoreClangWarning

#define JKBeginIgnoreDeprecatedWarning JKBeginIgnoreClangWarning(-Wdeprecated-declarations)
#define JKEndIgnoreDeprecatedWarning JKEndIgnoreClangWarning


#pragma mark - UIWindow
/// UIWindow level
#define JKIronmanWindowLevel            (UIWindowLevelStatusBar - 10.0)
#define JKFloatWindowLevel              (UIWindowLevelAlert + 4.0)
#define JKPresentationWindowLevel       (UIWindowLevelStatusBar - 5.0)

#pragma mark - NSUserDefaults JarvisKit用到的的UserDefaults key
// 沙盒路径收藏
#define JKSandboxFavoritePathKey    @"JKSandboxFavoritePathKey"
// 奔溃日志
#define JKCrashLogActiveKey         @"JKCrashLogActiveKey"
// 抓包
#define JKNetCaptureActiveKey       @"JKNetCaptureActiveKey"
