//
//  JKMagnifierLayer.h
//  JarvisKitDemo
//
//  Created by CodingIran on 2020/2/13.
//  Copyright © 2020 CodingIran. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKMagnifierLayer : CALayer

/**
 获取指定点的颜色值
 */
@property(nonatomic, copy) NSString * (^pointColorHandler)(CGPoint point);

/**
 目标视图展示位置
 */
@property (nonatomic, assign) CGPoint targetPoint;

@end

NS_ASSUME_NONNULL_END
