//
//  JKCrashLogHelper.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/11.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKCrashLogHelper.h"
#import "JKCrashUncaughtExceptionHandler.h"
#import "JKCrashSignalExceptionHandler.h"
#import "JKCrashLogModel.h"

@implementation JKCrashLogHelper

+ (void)jk_crashLogRegister
{
    [JKCrashUncaughtExceptionHandler registerHandler];
    [JKCrashSignalExceptionHandler registerHandler];
}

+ (BOOL)jk_crashLogActivate
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:JKCrashLogActiveKey];
}

+ (void)jk_setCrashLogActive:(BOOL)active
{
    [[NSUserDefaults standardUserDefaults] setBool:active forKey:JKCrashLogActiveKey];
}

+ (void)jk_saveCrashLog:(NSString *)log fileName:(NSString *)fileName
{
    if ([log isKindOfClass:[NSString class]] && (log.length > 0)) {
        // 时间戳
        NSDateFormatter *dateFormart = [[NSDateFormatter alloc]init];
        [dateFormart setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateFormart.timeZone = [NSTimeZone systemTimeZone];
        NSString *dateString = [dateFormart stringFromDate:[NSDate date]];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *crashDirectory = [self jk_crashDirectory];
        if (crashDirectory && [manager fileExistsAtPath:crashDirectory]) {
            // 获取crash保存的路径
            NSString *crashPath = [crashDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Crash_%@.txt", dateString]];
            if ([fileName isKindOfClass:[NSString class]] && (fileName.length > 0)) {
                crashPath = [crashDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.txt", fileName, dateString]];
            }
            
            [log writeToFile:crashPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
}

+ (NSString *)jk_crashDirectory
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *directory = [cachePath stringByAppendingPathComponent:@"JKCrash"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:directory]) {
        [manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return directory;
}

+ (NSArray<JKCrashLogModel *> *)jk_crashList
{
    NSString *crashDirectory = [self jk_crashDirectory];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    NSArray<NSString *> *contentsArray =  [manager contentsOfDirectoryAtPath:crashDirectory error:&error];
    if (!contentsArray || !contentsArray.count) {
        return nil;
    }
    
    NSMutableArray<JKCrashLogModel *> *crashList = [NSMutableArray arrayWithCapacity:contentsArray.count];
    [contentsArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKCrashLogModel *model = [[JKCrashLogModel alloc] init];
        model.crashFileName = obj;
        model.crashFilePath = [crashDirectory stringByAppendingPathComponent:obj];
        [crashList addObject:model];
    }];
    
    return crashList.copy;
}

+ (NSArray<NSArray<JKCrashLogModel *> *> *)jk_sectionCrashList
{
    NSArray<JKCrashLogModel *> *crashList = [self jk_crashList];
    
    // 用valueForKeyPath拿到所有属性crashDateShortString的value
    NSMutableArray<NSString *> *indexArray = [crashList valueForKeyPath:@"crashDateShortString"];
    // 出重
    NSSet<NSString *> *indexSet = [NSSet setWithArray:indexArray];
    // 排序
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]];
    NSArray<NSString *> *sortSetArray = [indexSet sortedArrayUsingDescriptors:sortDesc];
    
    NSMutableArray<NSArray<JKCrashLogModel *> *> *resultArray = [NSMutableArray arrayWithCapacity:sortSetArray.count];
    
    [sortSetArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 根据NSPredicate获取array
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"crashDateShortString == %@",obj];
        NSArray<JKCrashLogModel *> *indexArray = [crashList filteredArrayUsingPredicate:predicate];
        [resultArray addObject:indexArray];
    }];

    return resultArray;
}

@end
