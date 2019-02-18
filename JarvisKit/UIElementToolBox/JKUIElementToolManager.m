//
//  JKUIElementToolManager.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/28.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKUIElementToolManager.h"
#import "JKFloatWindow.h"
#import "JKMagnifierView.h"
#import "JKUIElementToolHelper.h"

@interface JKUIElementToolManager ()<JKFloatWindowDelegate>

@property(nonatomic, strong) JKFloatWindow *colorPickerWindow;
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
        JKMagnifierView *magnifierView = (JKMagnifierView *)entity;
        if (magnifierView) {
            magnifierView.targetWindow = [UIApplication sharedApplication].keyWindow;
            magnifierView.targetPoint = floatWindow.center;
        }
    }
}

- (void)floatWindow:(JKFloatWindow *)floatWindow beginMoveEntity:(__kindof UIView *)entity
{
    if (floatWindow == self.colorPickerWindow) {
        JKMagnifierView *magnifierView = (JKMagnifierView *)entity;
        if (magnifierView) {
            magnifierView.targetWindow = [UIApplication sharedApplication].keyWindow;
            magnifierView.targetPoint = floatWindow.center;
        }
    }
}

- (void)floatWindow:(JKFloatWindow *)floatWindow moveEntity:(__kindof UIView *)entity withPangesrure:(UIPanGestureRecognizer *)gesture
{
    if (floatWindow == self.colorPickerWindow) {
        JKMagnifierView *magnifierView = (JKMagnifierView *)entity;
        if (magnifierView) {
            magnifierView.targetPoint = floatWindow.center;
        }
        UIColor *color = [JKUIElementToolHelper jk_getColorWithPoint:floatWindow.center inView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)floatWindow:(JKFloatWindow *)floatWindow endMoveEntity:(__kindof UIView *)entity
{
    if (floatWindow == self.colorPickerWindow) {
        JKMagnifierView *magnifierView = (JKMagnifierView *)entity;
        if (magnifierView) {
            magnifierView.targetWindow = nil;
        }
    }
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


- (JKFloatWindow *)colorPickerWindow
{
    if (!_colorPickerWindow) {
        CGRect frame = CGRectMake((JK_SCREEN_WIDTH - 100 * JK_WIDTH_RATIO) * 0.5, (JK_SCREEN_HEIGHT - 100 * JK_WIDTH_RATIO) * 0.5, 100 * JK_WIDTH_RATIO, 100 * JK_WIDTH_RATIO);
        JKMagnifierView *magnifierView = [[JKMagnifierView alloc] initWithFrame:frame];
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
