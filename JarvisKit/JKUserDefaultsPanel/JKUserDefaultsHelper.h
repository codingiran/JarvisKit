//
//  JKUserDefaultsHelper.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/4.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKUserDefaultsHelper : JKHelper

/**
 从沙盒中中的xxx.plist获取偏好设置，路径为:~/Library/Preferences/xxxxx.plist, xxxxx为此app的bundle id
 */
+ (NSDictionary * _Nullable)achieveUserDefaultsFromSandboxPlist;

@end

@interface JKUserDefaultsHelper (NSDate)

/**
 将NSDate转为字符串类型（yyyy-MM-dd HH:mm:ss）
 */
+ (NSString *)dateStringFromDate:(NSDate *)date;

@end


@interface JKUserDefaultsHelper (NSNumber)

/**
 将字符串转为NSNumber
 */
+ (NSNumber *)numberFromString:(NSString *)string;

/**
 将字符串转为BOOL 
 */
+ (BOOL)booleanFromString:(NSString *)string;

@end


NS_ASSUME_NONNULL_END
