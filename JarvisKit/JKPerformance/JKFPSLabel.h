//
//  JKFPSLabel.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2018/12/25.
//  Copyright © 2018 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 显示当前屏幕的刷新率FPS
 */
@interface JKFPSLabel : UILabel

/**
 初始化
 @return 实例对象
 */
+ (instancetype)fpsLabel;


@end

NS_ASSUME_NONNULL_END
