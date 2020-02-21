//
//  JKUIElementToolManager.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/28.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKUIElementToolManager.h"
#import "JKFloatWindow.h"
#import "JKMagnifierView.h"
#import "JKUIElementToolHelper.h"
#import <AudioToolbox/AudioToolbox.h>

@interface JKUIElementToolManager ()<JKFloatWindowDelegate>

@property(nonatomic, strong) JKFloatWindow *colorPickerWindow;
@property(nonatomic, strong) UIImage *screenShotImage;
@property(nonatomic, copy) NSString *hexString;
@property(nonatomic, copy) NSString *rgbaString;

@property(nonatomic, strong) JKFloatWindow *frameRulerWindow;
@property(nonatomic, strong) JKFloatWindow *viewBorderWindow;
@property(nonatomic, strong) JKFloatWindow *viewComponentWindow;

@end

@implementation JKUIElementToolManager

/// ******完整的ARC单例***Begin**********
static JKUIElementToolManager *jkUIElementToolManager = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jkUIElementToolManager = [[super allocWithZone:NULL] init];
    });
    return jkUIElementToolManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedManager];
}

- (id)copy
{
    return [self.class sharedManager];
}

- (id)mutableCopy
{
    return [self.class sharedManager];
}

/// ******完整的ARC单例***End**********

#pragma mark - JKFloatWindowDelegate

- (void)floatWindow:(JKFloatWindow *)floatWindow didShowEntity:(__kindof UIView *)entity
{
    if (floatWindow == self.colorPickerWindow) {
        if (floatWindow.rootViewController.view.superview) {
            floatWindow.rootViewController.view.superview.clipsToBounds = NO;
        }
    }
}

- (void)floatWindow:(JKFloatWindow *)floatWindow beginMoveEntity:(__kindof UIView *)entity
{
    if (floatWindow == self.colorPickerWindow) {
        JKMagnifierView *magnifierView = (JKMagnifierView *)entity;
        if (magnifierView) {
            [self updateScreeShotImage];
            CGPoint centerPoint = floatWindow.center;
            [self handleMagnifier:magnifierView moveToPoint:centerPoint];
        }
    }
}

- (void)floatWindow:(JKFloatWindow *)floatWindow moveEntity:(__kindof UIView *)entity withPangesrure:(UIPanGestureRecognizer *)gesture
{
    if (floatWindow == self.colorPickerWindow) {
        JKMagnifierView *magnifierView = (JKMagnifierView *)entity;
        if (magnifierView) {
            CGPoint centerPoint = floatWindow.center;
            [self handleMagnifier:magnifierView moveToPoint:centerPoint];
        }
    }
}

- (void)floatWindow:(JKFloatWindow *)floatWindow endMoveEntity:(__kindof UIView *)entity
{
    if (floatWindow == self.colorPickerWindow) {
        JKMagnifierView *magnifierView = (JKMagnifierView *)entity;
        if (magnifierView) {
            CGPoint centerPoint = floatWindow.center;
            [self handleMagnifier:magnifierView moveToPoint:centerPoint];
        }
    }
}

- (void)floatWindow:(JKFloatWindow *)floatWindow punchOnEntity:(__kindof UIView *)entity
{
    if (floatWindow == self.colorPickerWindow) {
        JKMagnifierView *magnifierView = (JKMagnifierView *)entity;
        if (magnifierView) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            if (!magnifierView.colorString.length) {
                return;
            }
            pasteboard.string = magnifierView.colorString;
            if (@available(iOS 10.0, *)) {
                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];
                [generator prepare];
                [generator impactOccurred];
            } else {
                AudioServicesPlaySystemSound(1519);
            }
        }
    }
}

- (void)handleMagnifier:(JKMagnifierView *)magnifierView moveToPoint:(CGPoint)point
{
    magnifierView.magnifierLayer.targetPoint = point;
    [magnifierView.magnifierLayer setNeedsDisplay];
    self.hexString = [self.screenShotImage jk_HexColorStringAtPoint:point];
    NSLog(@"hexString:----%@", self.hexString);
    
    // 更改取色器颜色文字的位置
    CGFloat horizontalTrigger = magnifierView.jk_width * 0.35;
    CGFloat verticalTrigger = magnifierView.jk_width * 0.2;

    BOOL up = NO, left = NO, right = NO;
    right = (point.x < horizontalTrigger);
    left = (point.x > JK_SCREEN_WIDTH - horizontalTrigger);
    up = (point.y > JK_SCREEN_HEIGHT - verticalTrigger);
    
    JKColorMeterPostion postion = JKColorMeterPostionDown;
    if (!left && !right) {
        postion = up ? JKColorMeterPostionUp : JKColorMeterPostionDown;
    } else if (left) {
        postion = up ? JKColorMeterPostionUpLeft : JKColorMeterPostionDownLeft;
    } else if (right) {
        postion = up ? JKColorMeterPostionUpRight : JKColorMeterPostionDownRight;
    }
    magnifierView.colorMeterPostion = postion;
}

#pragma mark - private method

- (void)updateScreeShotImage
{
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    [[[UIApplication sharedApplication].delegate window].layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.screenShotImage = image;
}


#pragma mark - setter * getter

- (void)setColorPickerActive:(BOOL)colorPickerActive
{
    BOOL hasChange = colorPickerActive != _colorPickerActive;
    if (!hasChange) return;
    
    _colorPickerActive = colorPickerActive;
    self.colorPickerWindow.hidden = !colorPickerActive;
    
    if (!colorPickerActive) {
        self.colorPickerWindow = nil;
    }
}

- (void)setHexString:(NSString *)hexString
{
    _hexString = hexString.copy;
    self.rgbaString = [_hexString jk_rgbaString];
}

- (void)setRgbaString:(NSString *)rgbaString
{
    _rgbaString = rgbaString.copy;
    if (self.colorPickerWindow && [self.colorPickerWindow.entityView isKindOfClass:JKMagnifierView.class]) {
        JKMagnifierView *magnifierView = (JKMagnifierView *)self.colorPickerWindow.entityView;
        [magnifierView setColorString:_rgbaString];
    }
}

- (JKFloatWindow *)colorPickerWindow
{
    if (!_colorPickerWindow) {
        CGRect frame = CGRectMake((JK_SCREEN_WIDTH - 140 * JK_WIDTH_RATIO) * 0.5, (JK_SCREEN_HEIGHT - 140 * JK_WIDTH_RATIO) * 0.5, 140 * JK_WIDTH_RATIO, 140 * JK_WIDTH_RATIO);
        JKMagnifierView *magnifierView = [[JKMagnifierView alloc] initWithFrame:frame];
        __weak __typeof(self)weakSelf = self;
        magnifierView.magnifierLayer.pointColorHandler = ^NSString * _Nonnull(CGPoint point) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            return [strongSelf.screenShotImage jk_HexColorStringAtPoint:point];
        };
        _colorPickerWindow = [[JKFloatWindow alloc] initWithEntity:magnifierView];
        _colorPickerWindow.delegate = self;
    }
    return _colorPickerWindow;
}

- (JKFloatWindow *)frameRulerWindow
{
    if (!_frameRulerWindow) {
        _frameRulerWindow = [[JKFloatWindow alloc] initWithEntity:nil];
        _frameRulerWindow.delegate = self;
    }
    return _frameRulerWindow;
}
- (JKFloatWindow *)viewBorderWindow
{
    if (!_viewBorderWindow) {
        _viewBorderWindow = [[JKFloatWindow alloc] initWithEntity:nil];
        _viewBorderWindow.delegate = self;
    }
    return _viewBorderWindow;
}
- (JKFloatWindow *)viewComponentWindow
{
    if (!_viewComponentWindow) {
        _viewComponentWindow = [[JKFloatWindow alloc] initWithEntity:nil];
        _viewComponentWindow.delegate = self;
    }
    return _viewComponentWindow;
}

@end
