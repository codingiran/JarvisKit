//
//  JKMagnifierView.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/28.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKMagnifierLayer.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JKColorMeterPostion) {
    JKColorMeterPostionUp,         // ↑
    JKColorMeterPostionUpLeft,     // ↖
    JKColorMeterPostionDownLeft,   // ↙
    JKColorMeterPostionDown,       // ↓
    JKColorMeterPostionDownRight,  // ↘
    JKColorMeterPostionUpRight,    // ↗
};

@interface JKMagnifierView : UIView

@property(nonatomic, strong, readonly) JKMagnifierLayer *magnifierLayer;

/// 移动取色器时防止遮挡自动调整上下左右的位置
@property(nonatomic, assign) JKColorMeterPostion colorMeterPostion;

@property(nonatomic, copy) NSString *colorString;

@end

NS_ASSUME_NONNULL_END
