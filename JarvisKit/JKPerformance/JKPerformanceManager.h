//
//  JKPerformanceManager.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/24.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKPerformanceHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKPerformanceManager : NSObject

/// FPS
@property(nonatomic, assign) BOOL fpsActive;

/// CPU
@property(nonatomic, assign) BOOL cpuActive;

/// RAM
@property(nonatomic, assign) BOOL ramActive;

/// 流量
@property(nonatomic, assign) BOOL flowActive;

/// 内存泄露
@property(nonatomic, assign) BOOL leakActive;

/// 循环引用
@property(nonatomic, assign) BOOL cycleActive;

/**
 全局单例
 */
+ (instancetype)sharedManager;

/**
 启动的时候根据 NSUserdefaults 存的值显示性能组件
 */
- (void)showPerformanceModuleOnLaunch;

@end

/// MLeaksFinder 和 FBRetainCycleDetector 如果想要做到完美的开关，需要浸入修改源码...
/// ...这边用一个 trick 的方式:  Hook MLeaksFinder 的弹框方法，造成没有开启的"假象"
@interface JKPerformanceManager (MLeaksFinder)

@end

NS_ASSUME_NONNULL_END
