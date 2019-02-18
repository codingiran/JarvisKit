//
//  JKPerformanceManager.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/24.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKPerformanceHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKPerformanceManager : NSObject

@property(nonatomic, assign) BOOL fpsActive;

@property(nonatomic, assign) BOOL cpuActive;

@property(nonatomic, assign) BOOL ramActive;

@property(nonatomic, assign) BOOL flowActive;

/**
 全局单例
 */
+ (instancetype)sharedManager;

/**
 启动的时候根据NSUserdefaults存的值显示性能组件
 */
- (void)showPerformanceModuleOnLaunch;

@end

NS_ASSUME_NONNULL_END
