//
//  JKCrashLogHelper.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/11.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKHelper.h"
@class JKCrashLogModel;

NS_ASSUME_NONNULL_BEGIN

@interface JKCrashLogHelper : JKHelper

/**
 奔溃日志功能注册
 */
+ (void)jk_crashLogRegister;

/**
 奔溃日志功能是否开启
 */
+ (BOOL)jk_crashLogActivate;

/**
 开启或关闭日志功能
 
 @param active YES为开启
 */
+ (void)jk_setCrashLogActive:(BOOL)active;

/**
 保存崩溃日志到沙盒中的Library/Caches/JKCrash目录下
 
 @param log 崩溃日志的内容
 @param fileName 保存的文件名
 */
+ (void)jk_saveCrashLog:(NSString *)log fileName:(NSString *)fileName;

/**
 获取崩溃日志的目录 
 */
+ (NSString *)jk_crashDirectory;

/**
 获取奔溃日志列表数组
 */
+ (NSArray<JKCrashLogModel *> * _Nullable)jk_crashList;

/**
 按照日期分组后的奔溃日志数组
 */
+ (NSArray<NSArray<JKCrashLogModel *> *> *)jk_sectionCrashList;

@end

NS_ASSUME_NONNULL_END
