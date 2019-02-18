//
//  JKUserDefaultsHelper.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/4.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKUserDefaultsHelper.h"

@implementation JKUserDefaultsHelper

+ (NSDictionary *)achieveUserDefaultsFromSandboxPlist
{
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = filePaths.firstObject;
    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *plistPath = [libraryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Preferences/%@.plist", bundleId]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        return dictionary;
    } else {
        return nil;
    }
}

@end

@implementation JKUserDefaultsHelper (NSDate)

+ (NSString *)dateStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

@end

@implementation JKUserDefaultsHelper (NSNumber)

+ (NSNumber *)numberFromString:(NSString *)string
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterNoStyle;
    NSNumber *number = [numberFormatter numberFromString:string];
    return number;
}

+ (BOOL)booleanFromString:(NSString *)string
{
    if (!string.length || [string isEqualToString:@"0"]) {
        return NO;
    } else {
        return YES;
    }
}

@end
