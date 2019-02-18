//
//  JKMagnifierView.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/28.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKMagnifierView : UIView

/**
 边长
 */
@property(nonatomic, assign) CGFloat magnifierSide;

/**
 放大倍数
 */
@property(nonatomic, assign) CGFloat magnification;

/**
 目标视图的Window
 */
@property(nullable, nonatomic, strong) UIView *targetWindow;

/**
 目标视图展示位置
 */
@property(nonatomic, assign) CGPoint targetPoint;




@end

NS_ASSUME_NONNULL_END
