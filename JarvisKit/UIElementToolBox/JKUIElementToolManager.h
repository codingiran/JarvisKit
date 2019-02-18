//
//  JKUIElementToolManager.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/28.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKUIElementToolManager : NSObject

/// 颜色c拾取器
@property(nonatomic, assign) BOOL colorPickerActive;

/// 尺寸标尺
@property(nonatomic, assign) BOOL frameRulerActive;

/// 元素边框线
@property(nonatomic, assign) BOOL viewBorderActive;

/// 元素组建
@property(nonatomic, assign) BOOL viewComponentActive;

/**
 全局单例
 */
+ (instancetype)sharedManager;


@end

NS_ASSUME_NONNULL_END
