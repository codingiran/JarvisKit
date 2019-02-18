//
//  JKFloatWindow.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/24.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKFloatWindow.h"

@interface JKFloatWindow ()

@property(nonatomic, weak, readwrite) __kindof UIView *entityView;

@end

@implementation JKFloatWindow

- (instancetype)initWithEntity:(__kindof UIView *)entity
{
    // 为了增加响应触摸事件的面积，取长宽中的较大值做边长做正方形
    CGFloat side = MAX(entity.jk_width, entity.jk_height);
    CGRect frame = CGRectMake(entity.jk_left, entity.jk_top, side, side);
    
    if (self = [super initWithFrame:frame]) {
        self.entityView = entity;
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = JKFloatWindowLevel;
        if (!self.rootViewController) {
            self.rootViewController = [[UIViewController alloc] init];
            self.rootViewController.view.frame = CGRectMake(0, 0, side, side);
            self.rootViewController.view.backgroundColor = [UIColor clearColor];
        }
        if (![entity isDescendantOfView:self.rootViewController.view]) {
            // 居中
            entity.frame = CGRectMake((side - entity.jk_width) * 0.5, (side - entity.jk_height) * 0.5, entity.jk_width, entity.jk_height);
            [self.rootViewController.view addSubview:entity];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        
        // kvo hidden property
        [self addObserver:self forKeyPath:@"hidden" options:0 context:NULL];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == self) {
        if ([keyPath isEqualToString:@"hidden"]) {
            if (self.hidden) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(floatWindow:didhideEntity:)]) {
                        [self.delegate floatWindow:self didhideEntity:self.entityView];
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(floatWindow:didShowEntity:)]) {
                        [self.delegate floatWindow:self didShowEntity:self.entityView];
                    }
                });
            }
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"hidden"];
}

#pragma mark - touch event
- (void)tap:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(floatWindow:punchOnEntity:)]) {
        [self.delegate floatWindow:self punchOnEntity:self.entityView];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(floatWindow:beginMoveEntity:)]) {
            [self.delegate floatWindow:self beginMoveEntity:self.entityView];
        }
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        // 移动
        CGPoint transP = [pan translationInView:self];
        UIView *panView = pan.view;
        [pan setTranslation:CGPointZero inView:self];
        CGFloat newCenterX = panView.jk_centerX + transP.x;
        CGFloat newCenterY = panView.jk_centerY + transP.y;
        panView.center = CGPointMake(newCenterX, newCenterY);

        // 回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(floatWindow:moveEntity:withPangesrure:)]) {
            [self.delegate floatWindow:self moveEntity:self.entityView withPangesrure:pan];
        }
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        // 回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(floatWindow:endMoveEntity:)]) {
            [self.delegate floatWindow:self endMoveEntity:self.entityView];
        }
    }
}

#pragma mark - private method
- (void)becomeKeyWindow
{
    // 把keywindow交还
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    if (appWindow != self) {
        [appWindow makeKeyWindow];
    }
}


@end
