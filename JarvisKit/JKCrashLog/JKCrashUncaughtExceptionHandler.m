//
//  JKCrashUncaughtExceptionHandler.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/11.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKCrashUncaughtExceptionHandler.h"
#import "JKCrashLogHelper.h"

// 记录之前的崩溃回调函数
static NSUncaughtExceptionHandler *previousUncaughtExceptionHandler = NULL;

@implementation JKCrashUncaughtExceptionHandler

#pragma mark - Register

+ (void)registerHandler
{
    // Backup original handler
    previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&JKUncaughtExceptionHandler);
}

#pragma mark - Private

// 崩溃时的回调函数
static void JKUncaughtExceptionHandler(NSException *exception) {
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"====【UncaughtException异常错误报告】====\n\n【name】:%@\n\n【reason】:\n%@\n\n【callStackSymbols】:\n%@", name, reason, [stackArray componentsJoinedByString:@"\n"]];
    
    // 保存崩溃日志到沙盒cache目录
    [JKCrashLogHelper jk_saveCrashLog:exceptionInfo fileName:@"Crash_Uncaught"];
    
    // 调用之前崩溃的回调函数
    if (previousUncaughtExceptionHandler) {
        previousUncaughtExceptionHandler(exception);
    }
    
    // 杀掉程序，这样可以防止同时抛出的SIGABRT被SignalException捕获
    kill(getpid(), SIGKILL);
}


@end
