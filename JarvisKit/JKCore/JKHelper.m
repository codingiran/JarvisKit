//
//  JKHelper.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/8.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKHelper.h"

@implementation JKHelper

+ (NSBundle *)resourcesBundleWithName:(NSString *)bundleName
{
    NSBundle *bundle = [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundleName]];
    return bundle;
}

+ (UIImage *)jk_imageWithName:(NSString *)name
{
    NSBundle *bundle = [self resourcesBundleWithName:@"JarvisKit.bundle"];
    return [self imageInBundle:bundle withName:name];
}

+ (UIImage *)imageInBundle:(NSBundle *)bundle withName:(NSString *)name {
    if (bundle && name) {
        if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
            return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
        } else {
            NSString *imagePath = [[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
            return [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    return nil;
}

+ (__kindof UIView * _Nullable)jk_statusBar
{
    if (@available(iOS 13, *)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
        id _statusBar = nil;
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *_localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([_localStatusBar respondsToSelector:@selector(statusBar)]) {
                _statusBar = [_localStatusBar performSelector:@selector(statusBar)];
            }
        }
#pragma clang diagnostic pop
        return _statusBar;
    } else {
        // Tip: statusBarWindow 不在 [UIApplication sharedApplication].windows 里，需要通过 statusBarWindow 拿到
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        return statusBar;
    }
}

+ (UIColor *)jk_getStatusBarColor
{
    UIView *statusBar = [self jk_statusBar];
    if (statusBar) {
        if ([statusBar respondsToSelector:@selector(backgroundColor)]) {
            return statusBar.backgroundColor;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

+ (void)jk_setStatusBarColorWith:(UIColor *)statusBarColor
{
    UIView *statusBar = [self jk_statusBar];
    if (statusBar) {
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            [statusBar setBackgroundColor:statusBarColor];
        }
    }
}

static CGFloat pixelOne = -1.0f;
+ (CGFloat)jk_pixelOne {
    if (pixelOne < 0) {
        pixelOne = 1 / [[UIScreen mainScreen] scale];
    }
    return pixelOne;
}


+ (UIColor *)jk_colorWithHexString:(NSString *)hexString
{
    if (hexString.length <= 0) return nil;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default: {
            NSAssert(NO, @"JKError: Color value %@ is invalid. It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString);
            return nil;
        }
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end


@implementation JKHelper (UIViewController)

+ (UIViewController * _Nullable)jk_visibleViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *visibleViewController = [rootViewController jk_visibleViewControllerIfExist];
    
    return visibleViewController;
}

@end


@implementation JKHelper (UIDevice)

static NSInteger isIPad = -1;
+ (BOOL)jk_isIPad {
    if (isIPad < 0) {
        isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0;
    }
    return isIPad > 0;
}

static NSInteger isIPod = -1;
+ (BOOL)jk_isIPod {
    if (isIPod < 0) {
        NSString *string = [[UIDevice currentDevice] model];
        isIPod = [string rangeOfString:@"iPod touch"].location != NSNotFound ? 1 : 0;
    }
    return isIPod > 0;
}

static NSInteger isIPhone = -1;
+ (BOOL)jk_isIPhone {
    if (isIPhone < 0) {
        NSString *string = [[UIDevice currentDevice] model];
        isIPhone = [string rangeOfString:@"iPhone"].location != NSNotFound ? 1 : 0;
    }
    return isIPhone > 0;
}

static NSInteger isSimulator = -1;
+ (BOOL)jk_isSimulator
{
    if (isSimulator < 0) {
#if TARGET_OS_SIMULATOR
        isSimulator = 1;
#else
        isSimulator = 0;
#endif
    }
    return isSimulator > 0;
}

+ (UIEdgeInsets)jk_safeAreaInsetsForDeviceWithNotch {
    if (![self jk_isNotchedScreen]) {
        return UIEdgeInsetsZero;
    }
    
    if ([self jk_isIPad]) {
        return UIEdgeInsetsMake(20, 0, 20, 0);
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            return UIEdgeInsetsMake(44, 0, 34, 0);
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIEdgeInsetsMake(34, 0, 44, 0);
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return UIEdgeInsetsMake(0, 44, 21, 44);
            
        case UIInterfaceOrientationUnknown:
        default:
            return UIEdgeInsetsMake(44, 0, 34, 0);
    }
}

static NSInteger isNotchedScreen = -1;
+ (BOOL)jk_isNotchedScreen
{
    if (@available(iOS 11, *)) {
        if (isNotchedScreen < 0) {
            if (@available(iOS 12, *)) {
                UIWindow *window = [[UIWindow alloc] init];
                isNotchedScreen = window.safeAreaInsets.bottom > 0 ? 1 : 0;
            } else {
                isNotchedScreen = [self jk_is58InchScreen] ? 1 : 0;
            }
        }
    } else {
        isNotchedScreen = 0;
    }
    
    return isNotchedScreen > 0;
}

static NSInteger is58InchScreen = -1;
+ (BOOL)jk_is58InchScreen
{
    if (is58InchScreen < 0) {
        is58InchScreen = (JK_SCREEN_WIDTH == self.jk_screenSizeFor58Inch.width && JK_SCREEN_HEIGHT == self.jk_screenSizeFor58Inch.height) ? 1 : 0;
    }
    return is58InchScreen > 0;
}

+ (CGSize)jk_screenSizeFor58Inch
{
    return CGSizeMake(375, 812);
}

+ (CGFloat)jk_screenRatio
{
    return JK_SCREEN_WIDTH / 375.0f;
}

@end


@implementation JKHelper (Unit)

+ (NSString *)jk_getFormatUnitFromByte:(CGFloat)byte
{
    double convertedValue = byte;
    int multiplyFactor = 0;
    NSArray *tokens = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.2f%@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

@end

