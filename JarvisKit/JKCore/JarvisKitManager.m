//
//  JarvisKitManager.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/8.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JarvisKitManager.h"
#import "JKIronmanWindow.h"
#import "JKCrashLogHelper.h"
#import "JKPerformanceManager.h"
#import "JKURLProtocol.h"

@interface JarvisKitManager ()

@property(nonatomic, strong) JKIronmanWindow *ironmanWindow;

@end

@implementation JarvisKitManager

/// ******完整的ARC单例***Begin**********

static JarvisKitManager *jarvisKitManager = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jarvisKitManager = [[super allocWithZone:NULL] init];
    });
    return jarvisKitManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedManager];
}

- (id)copy
{
    return [self.class sharedManager];
}

- (id)mutableCopy
{
    return [self.class sharedManager];
}

/// ******完整的ARC单例***End**********

#pragma mark - public method
- (void)install
{
    self.ironmanWindow = [[JKIronmanWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.ironmanWindow makeKeyAndVisible];
    
    // 奔溃日志
    if ([JKCrashLogHelper jk_crashLogActivate]) {
        [JKCrashLogHelper jk_crashLogRegister];
    }
    
    // 性能检测
    if (JKPerformanceActive) {
        [[JKPerformanceManager sharedManager] showPerformanceModuleOnLaunch];
    }
}

- (void)shutDown
{
    // 关闭
}

@end
