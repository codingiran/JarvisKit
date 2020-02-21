//
//  JKCrashLogModel.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/11.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKCrashLogModel.h"

@implementation JKCrashLogModel

- (void)setCrashFileName:(NSString *)crashFileName
{
    _crashFileName = crashFileName.copy;
    
    NSArray<NSString *> *array = [[crashFileName stringByDeletingPathExtension] componentsSeparatedByString:@"_"];
    
    NSAssert(array.count == 3, @"JKError:*******Crash日志的文件格式为『Crash_type_date』*******");
    
    // 日期
    self.crashDateString = array.lastObject;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.crashDate = [formatter dateFromString:self.crashDateString];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.crashDateShortString = [formatter stringFromDate:self.crashDate];
    formatter.dateFormat = @"HH:mm:ss";
    self.crashTimeString = [formatter stringFromDate:self.crashDate];
    
    // 类型
    NSString *typeString = array[1];
    if ([typeString containsString:@"Uncaught"]) {
        self.crashExceptionType = JKCrashExceptionTypeUncaughtException;
    } else if ([typeString containsString:@"Signal"]) {
        self.crashExceptionType = JKCrashExceptionTypeUnixSignal;
    } else {
        NSAssert(NO, @"JKError:******JKCrash日志类型只有Uncaught和Signal两种类型******");
    }
    
    // 内容
    NSString *crashFilePath = [[JKCrashLogHelper jk_crashDirectory] stringByAppendingPathComponent:crashFileName];
    NSError *error;
    self.crashContent = [[NSString stringWithContentsOfFile:crashFilePath encoding:NSUTF8StringEncoding error:&error] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 获取名称和简介
    if (self.crashExceptionType == JKCrashExceptionTypeUncaughtException) {
        self.crashName = [self getSandwichInContent:self.crashContent fromBeginTag:@"【name】:" toEndTag:@"【reason】"];
        self.crashBrief = [self getSandwichInContent:self.crashContent fromBeginTag:@"【reason】:" toEndTag:@"【callStackSymbols】"];
    } else if (self.crashExceptionType == JKCrashExceptionTypeUnixSignal) {
        self.crashName = [self getSandwichInContent:self.crashContent fromBeginTag:@"【Signal Exception】:" toEndTag:@"【Call Stack】"];
        self.crashBrief = [self getSandwichInContent:self.crashContent fromBeginTag:@"【Call Stack】:" toEndTag:@"【threadInfo】"];
    }
    
}



/**
 例: "abcdefghi" 中，获取 "abc" 和 "fgh" 之间的字符串
 
 @warning 会去掉首尾的空格和换行符

 @param content 给定的整个字符串
 @param beginTag 开始字符串, "abc"
 @param endTag 结束字符串, "fhg"
 @return 中间的字符串, "de"
 */
- (NSString *)getSandwichInContent:(NSString *)content fromBeginTag:(NSString *)beginTag toEndTag:(NSString *)endTag
{
    NSRange range = [content rangeOfString:beginTag];
    NSUInteger beginLocation = NSMaxRange(range);
    range = [content rangeOfString:endTag];
    NSUInteger endLocation = range.location;
    NSUInteger length = endLocation - beginLocation;
    range = NSMakeRange(beginLocation, length);
    
    NSString *resultString = [content substringWithRange:range];
    resultString = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return resultString;
}

@end
