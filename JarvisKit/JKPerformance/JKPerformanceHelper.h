//
//  JKPerformanceHelper.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/26.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKHelper.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const           kPerformanceActiveKey;
FOUNDATION_EXPORT NSString * const           kFPSActiveKey;
FOUNDATION_EXPORT NSString * const           kCPUActiveKey;
FOUNDATION_EXPORT NSString * const           kRAMActiveKey;
FOUNDATION_EXPORT NSString * const           kFLOWActiveKey;

#define JKFPSActiveStatus                    [JKPerformanceHelper savedFpsActiveStatus]
#define JKSaveFPSActiveStatus(fpsActive)     [JKPerformanceHelper setSavedFpsActiveStatus:fpsActive]

#define JKCPUActiveStatus                    [JKPerformanceHelper savedCpuActiveStatus]
#define JKSaveCPUActiveStatus(cpuActive)     [JKPerformanceHelper setSavedCpuActiveStatus:cpuActive]

#define JKRAMActiveStatus                    [JKPerformanceHelper savedRamActiveStatus]
#define JKSaveRAMActiveStatus(ramActive)     [JKPerformanceHelper setSavedRamActiveStatus:ramActive]

#define JKFLOWActiveStatus                   [JKPerformanceHelper savedFlowActiveStatus]
#define JKSaveFLOWActiveStatus(flowActive)   [JKPerformanceHelper setSavedFlowActiveStatus:flowActive]

#define JKPerformanceActive                  (JKFPSActiveStatus || JKCPUActiveStatus || JKRAMActiveStatus || JKFLOWActiveStatus)


@interface JKPerformanceHelper : JKHelper

/**
 类属性，存在本地的FPS开关状态
 */
@property(class, nonatomic, assign) BOOL savedFpsActiveStatus;
/**
 类属性，存在本地的CPU开关状态
 */
@property(class, nonatomic, assign) BOOL savedCpuActiveStatus;
/**
 类属性，存在本地的RAM开关状态
 */
@property(class, nonatomic, assign) BOOL savedRamActiveStatus;
/**
 类属性，存在本地的流量开关状态
 */
@property(class, nonatomic, assign) BOOL savedFlowActiveStatus;


/**
 获取当前cpu使用率，格式为0.03,0.12,0.99...
 */
+ (CGFloat)cpuUsageForApp;

/**
 获取当前内存使用，单位为M
 */
+ (NSInteger)useMemoryForApp;

/**
 获取设备的内内存，单位为M
 */
+ (NSInteger)totalMemoryForDevice;

@end

NS_ASSUME_NONNULL_END
