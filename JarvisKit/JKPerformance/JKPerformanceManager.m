//
//  JKPerformanceManager.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/24.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKPerformanceManager.h"
#import "JKNetCaptureListViewController.h"
#import "JKPerformanceSettingController.h"
#import "JKNetCaptureDataSource.h"
#import "JKFloatWindow.h"
#import "JKFPSLabel.h"
#import "JKCPULabel.h"
#import "JKRAMLabel.h"
#import "JKFlowLabel.h"

@interface JKPerformanceManager ()<JKFloatWindowDelegate>

@property(nonatomic, strong) JKFloatWindow *fpsWindow;
@property(nonatomic, strong) JKFloatWindow *cpuWindow;
@property(nonatomic, strong) JKFloatWindow *ramWindow;
@property(nonatomic, strong) JKFloatWindow *flowWindow;

@end

@implementation JKPerformanceManager

/// ******完整的ARC单例***Begin**********
static JKPerformanceManager *jkPerformanceManager = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jkPerformanceManager = [[super allocWithZone:NULL] init];
    });
    return jkPerformanceManager;
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

#pragma mark - public methods

- (void)showPerformanceModuleOnLaunch
{
    if (JKFPSActiveStatus) {
        [self setFpsActive:YES];
    }
    if (JKCPUActiveStatus) {
        [self setCpuActive:YES];
    }
    if (JKRAMActiveStatus) {
        [self setRamActive:YES];
    }
    if (JKFLOWActiveStatus) {
        [self setFlowActive:YES];
    }
}

#pragma mark - JKFloatWindowDelegate
- (void)floatWindow:(JKFloatWindow *)floatWindow punchOnEntity:(__kindof UIView *)entity
{
    if (floatWindow == self.flowWindow) {
        // 打开抓包工具
        if (![[JKHelper jk_visibleViewController] isKindOfClass:[JKNetCaptureListViewController class]]) {
            JKNetCaptureListViewController *netCaptureListVc = [[JKNetCaptureListViewController alloc] init];
            JKNavigtionController *navigationController = [[JKNavigtionController alloc] initWithRootViewController:netCaptureListVc];
            [[JKHelper jk_visibleViewController] presentViewController:navigationController animated:YES completion:NULL];
        }
    } else {
        // 打开性能检测设置页面
        if (![[JKHelper jk_visibleViewController] isKindOfClass:[JKPerformanceSettingController class]]) {
            JKPerformanceSettingController *performanceSettingController = [[JKPerformanceSettingController alloc] init];
            JKNavigtionController *navigationController = [[JKNavigtionController alloc] initWithRootViewController:performanceSettingController];
            [[JKHelper jk_visibleViewController] presentViewController:navigationController animated:YES completion:NULL];
        }
    }
}


#pragma mark - setter & getter
- (void)setFpsActive:(BOOL)fpsActive
{
    BOOL hasChange = fpsActive != _fpsActive;
    if (!hasChange) return;
    
    _fpsActive = fpsActive;
    self.fpsWindow.hidden = !fpsActive;
    JKSaveFPSActiveStatus(fpsActive);
    
    // 关闭需要从delegate.windows中删除
    if (!fpsActive) {
        [self.fpsWindow removeFromSuperview];
        self.fpsWindow = nil;
    }
}

- (void)setCpuActive:(BOOL)cpuActive
{
    BOOL hasChange = cpuActive != _cpuActive;
    if (!hasChange) return;
    
    _cpuActive = cpuActive;
    self.cpuWindow.hidden = !cpuActive;
    JKSaveCPUActiveStatus(cpuActive);
    
    // 关闭需要从delegate.windows中删除
    if (!cpuActive) {
        [self.cpuWindow removeFromSuperview];
        self.cpuWindow = nil;
    }
}

- (void)setRamActive:(BOOL)ramActive
{
    BOOL hasChange = ramActive != _ramActive;
    if (!hasChange) return;
    
    _ramActive = ramActive;
    self.ramWindow.hidden = !ramActive;
    JKSaveRAMActiveStatus(ramActive);
    
    // 关闭需要从delegate.windows中删除
    if (!ramActive) {
        [self.ramWindow removeFromSuperview];
        self.ramWindow = nil;
    }
}

- (void)setFlowActive:(BOOL)flowActive
{
    BOOL hasChange = flowActive != _flowActive;
    if (!hasChange) return;
    
    _flowActive = flowActive;
    
    // 流量开关前要先开关抓包工具
    [JKNetCaptureDataSource sharedDataSource].netCaptureActive = flowActive;
    
    self.flowWindow.hidden = !flowActive;
    JKSaveFLOWActiveStatus(flowActive);
    
    // 关闭需要从delegate.windows中删除
    if (!flowActive) {
        [self.flowWindow removeFromSuperview];
        self.flowWindow = nil;
    }
}

- (JKFloatWindow *)fpsWindow
{
    if (!_fpsWindow) {
        JKFPSLabel *fpsLabel = [JKFPSLabel fpsLabel];
        _fpsWindow = [[JKFloatWindow alloc] initWithEntity:fpsLabel];
        _fpsWindow.delegate = self;
    }
    return _fpsWindow;
}

- (JKFloatWindow *)cpuWindow
{
    if (!_cpuWindow) {
        JKCPULabel *cpuLabel = [JKCPULabel cpuLabel];
        _cpuWindow = [[JKFloatWindow alloc] initWithEntity:cpuLabel];
        _cpuWindow.delegate = self;
    }
    return _cpuWindow;
}
- (JKFloatWindow *)ramWindow
{
    if (!_ramWindow) {
        JKRAMLabel *ramLabel = [JKRAMLabel ramLabel];
        _ramWindow = [[JKFloatWindow alloc] initWithEntity:ramLabel];
        _ramWindow.delegate = self;
    }
    return _ramWindow;
}
- (JKFloatWindow *)flowWindow
{
    if (!_flowWindow) {
        JKFlowLabel *flowLabel = [JKFlowLabel flowLabel];
        _flowWindow = [[JKFloatWindow alloc] initWithEntity:flowLabel];
        _flowWindow.delegate = self;
    }
    return _flowWindow;
}

@end
