//
//  JKFloatWindow.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/24.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKHelper.h"
@class JKFloatWindow;

NS_ASSUME_NONNULL_BEGIN

@protocol JKFloatWindowDelegate <NSObject>

@optional;

/**
 出现
 */
- (void)floatWindow:(JKFloatWindow *)floatWindow didShowEntity:(__kindof UIView *)entity;

/**
 隐藏
 */
- (void)floatWindow:(JKFloatWindow *)floatWindow didhideEntity:(__kindof UIView *)entity;

/**
 点击
 */
- (void)floatWindow:(JKFloatWindow *)floatWindow punchOnEntity:(__kindof UIView *)entity;

/**
 开始移动
 */
- (void)floatWindow:(JKFloatWindow *)floatWindow beginMoveEntity:(__kindof UIView *)entity;

/**
 移动进行中
 */
- (void)floatWindow:(JKFloatWindow *)floatWindow moveEntity:(__kindof UIView *)entity withPangesrure:(UIPanGestureRecognizer *)gesture;

/**
 移动结束
 */
- (void)floatWindow:(JKFloatWindow *)floatWindow endMoveEntity:(__kindof UIView *)entity;


@end

@interface JKFloatWindow : UIWindow

/// JKFloatWindowDelegate代理方法
@property(nonatomic, weak) id<JKFloatWindowDelegate> delegate;

/// 上面添加的实体view
@property(nullable, nonatomic, weak, readonly) __kindof UIView *entityView;

/**
 初始化方法
 @param entity 上面添加的实体view
 @return 实例对象
 */
- (instancetype)initWithEntity:(__kindof UIView * _Nullable)entity;

@end

NS_ASSUME_NONNULL_END
