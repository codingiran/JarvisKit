//
//  JKPerformanceHelper.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/26.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKPerformanceHelper.h"
#include <mach/mach.h>

NSString * const kPerformanceActiveKey   = @"JKPerformanceActiveKey";
NSString * const kFPSActiveKey           = @"JKFPSActiveKey";
NSString * const kCPUActiveKey           = @"JKCPUActiveKey";
NSString * const kRAMActiveKey           = @"JKRAMActiveKey";
NSString * const kFLOWActiveKey          = @"JKFLOWActiveKey";
NSString * const kLEAKActiveKey          = @"kLEAKActiveKey";
NSString * const kCYCLEActiveKey         = @"kCYCLEActiveKey";

@implementation JKPerformanceHelper

+ (BOOL)savedFpsActiveStatus
{
    return [self getActiveStatusValuefromUserDefaultsWithKey:kFPSActiveKey];
}

+ (void)setSavedFpsActiveStatus:(BOOL)savedFpsActiveStatus
{
    [self setActiveStatusValue:savedFpsActiveStatus toUserDefaultsKey:kFPSActiveKey];
}

+ (BOOL)savedCpuActiveStatus
{
    return [self getActiveStatusValuefromUserDefaultsWithKey:kCPUActiveKey];
}

+ (void)setSavedCpuActiveStatus:(BOOL)savedCpuActiveStatus
{
    [self setActiveStatusValue:savedCpuActiveStatus toUserDefaultsKey:kCPUActiveKey];
}

+ (BOOL)savedRamActiveStatus
{
    return [self getActiveStatusValuefromUserDefaultsWithKey:kRAMActiveKey];
}

+ (void)setSavedRamActiveStatus:(BOOL)savedRamActiveStatus
{
    [self setActiveStatusValue:savedRamActiveStatus toUserDefaultsKey:kRAMActiveKey];
}

+ (BOOL)savedFlowActiveStatus
{
    return [self getActiveStatusValuefromUserDefaultsWithKey:kFLOWActiveKey];
}

+ (void)setSavedFlowActiveStatus:(BOOL)savedFlowActiveStatus
{
    [self setActiveStatusValue:savedFlowActiveStatus toUserDefaultsKey:kFLOWActiveKey];
}

+ (BOOL)savedLeakActiveStatus
{
    return [self getActiveStatusValuefromUserDefaultsWithKey:kLEAKActiveKey];
}

+ (void)setSavedLeakActiveStatus:(BOOL)savedLeakActiveStatus
{
    [self setActiveStatusValue:savedLeakActiveStatus toUserDefaultsKey:kLEAKActiveKey];
}

+ (BOOL)savedCycleActiveStatus
{
    return [self getActiveStatusValuefromUserDefaultsWithKey:kCYCLEActiveKey];
}

+ (void)setSavedCycleActiveStatus:(BOOL)savedCycleActiveStatus
{
    [self setActiveStatusValue:savedCycleActiveStatus toUserDefaultsKey:kCYCLEActiveKey];
}

+ (void)setActiveStatusValue:(BOOL)active toUserDefaultsKey:(NSString *)activeKey
{
    NSMutableDictionary<NSString *, NSNumber *> *multablePerformanceActiveValue = [[self getPerformanceActiveValueFromUserDefaults] mutableCopy];
    [multablePerformanceActiveValue setValue:@(active) forKey:activeKey];
    [[NSUserDefaults standardUserDefaults] setObject:multablePerformanceActiveValue.copy forKey:kPerformanceActiveKey];
}

+ (BOOL)getActiveStatusValuefromUserDefaultsWithKey:(NSString *)activeKey
{
    return [[[self getPerformanceActiveValueFromUserDefaults] valueForKey:activeKey] boolValue];
}

+ (NSDictionary<NSString *, NSNumber *> *)getPerformanceActiveValueFromUserDefaults
{
    NSDictionary<NSString *, NSNumber *> *performanceActiveValue = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kPerformanceActiveKey];
    if (!performanceActiveValue) {
        // 第一次创建
        performanceActiveValue = @{
            kFPSActiveKey   : @(NO),
            kCPUActiveKey   : @(NO),
            kRAMActiveKey   : @(NO),
            kFLOWActiveKey  : @(NO),
            kLEAKActiveKey  : @(NO),
            kCYCLEActiveKey : @(NO),
        };
    }
    return performanceActiveValue;
}

/// 获取cpu占用率
+ (CGFloat)cpuUsageForApp
{
    kern_return_t kr;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t basic_info_th;
    
    // get threads in the task
    //  获取当前进程中 线程列表
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS)
        return -1;
    
    float tot_cpu = 0;
    
    for (int j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        //获取每一个线程信息
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS)
            return -1;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            // cpu_usage : Scaled cpu usage percentage. The scale factor is TH_USAGE_SCALE.
            //宏定义TH_USAGE_SCALE返回CPU处理总频率：
            tot_cpu += basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
        
    } // for each thread
    
    // 注意方法最后要调用 vm_deallocate，防止出现内存泄漏
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

/// 获取当前使用的内存
+ (NSInteger)useMemoryForApp
{
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        int64_t memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        return (NSInteger)memoryUsageInByte/1024/1024;
    } else {
        return -1;
    }
}

/// 设备总的内存
+ (NSInteger)totalMemoryForDevice
{
    return (NSInteger)[NSProcessInfo processInfo].physicalMemory / 1024 / 1024;
}

@end
