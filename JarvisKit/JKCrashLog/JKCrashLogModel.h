//
//  JKCrashLogModel.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/11.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKCrashLogHelper.h"

NS_ASSUME_NONNULL_BEGIN

/// https://nianxi.net/ios/ios-crash-reporter.html

typedef NS_ENUM(NSUInteger, JKCrashExceptionType) {
    JKCrashExceptionTypeUncaughtException,  // NSException异常
    JKCrashExceptionTypeUnixSignal,         // Mach异常与Unix信号

};

@interface JKCrashLogModel : NSObject

/**
 Crash日志产生文件
 */
@property(nonatomic, copy) NSString *crashFileName;
@property(nonatomic, copy) NSString *crashFilePath;

/**
 Crash日志发生的日期
 */
@property(nonatomic, copy) NSString *crashDateString;// 原始的日期格式 yyyy-MM-dd HH:mm:ss
@property(nonatomic, copy) NSString *crashDateShortString;// 简化日期格式 yyyy-MM-dd
@property(nonatomic, copy) NSString *crashTimeString;// 简化日期格式 HH:mm:ss
@property(nonatomic, strong) NSDate *crashDate;// yyyy-MM-dd HH:mm:ss格式转化的NSDate

/**
 Crash日志的类型
 */
@property(nonatomic, assign) JKCrashExceptionType crashExceptionType;

/**
 Crash日志的内容
 */
@property(nonatomic, copy) NSString *crashContent;

/**
 根据crashContent得到的名称，Uncaught类型为NSException.name(【name】)，Signal类型为【Signal Exception】
 */
@property(nonatomic, copy) NSString *crashName;

/**
 根据crashContent得到的简述，Uncaught类型为NSException.reason，Signal类型为【Signal Exception】
 */
@property(nonatomic, copy) NSString *crashBrief;


@end

NS_ASSUME_NONNULL_END
