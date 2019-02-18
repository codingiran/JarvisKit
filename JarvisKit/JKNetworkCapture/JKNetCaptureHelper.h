//
//  JKNetCaptureHelper.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/16.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKNetCaptureHelper : JKHelper

/**
 网络抓包功能是否开启
 */
+ (BOOL)jk_netCaptureActivate;

/**
 开启或关闭网络抓包
 
 @param active YES为开启
 */
+ (void)jk_netCaptureActive:(BOOL)active;


/**
 将NSData数据转为JSON字符串

 @param data NSData数据
 */
+ (NSString * _Nullable)convertJsonStringFromData:(NSData *)data;


/**
 从NSURLRequest获取请求体

 @param request NSURLRequest对象
 */
+ (NSData * _Nullable)getHttpBodyOfRequest:(NSURLRequest *)request;


/**
 获取请求的上行流量

 @param request 请求
 */
+ (NSUInteger)getRequestLength:(NSURLRequest *)request;


/**
 获取返回结果的下行流量

 @param response 请求的返回结果
 @param responseData 请求的返回数据
 */
+ (int64_t)getLengthOfResponse:(NSHTTPURLResponse *)response andResponseData:(NSData *)responseData;


/**
 从timeIntervalSince1970转为yyyy-MM-dd HH:mm:ss

 @param timeInterval timeIntervalSince1970时间戳
 */
+ (NSString *)jk_getDateFromTimeInterval:(NSTimeInterval)timeInterval;

@end


@interface JKNetCaptureHelper (NSString)


/**
 给一段字符串首尾加上空格

 @param string 给定字符串
 */
+ (NSString *)addWhitespaceBesideString:(NSString *)string;


/**
 将一段文字两边的空格和换行去除

 @param string 给定字符串
 */
+ (NSString *)trimWhitespaceBesideString:(NSString *)string;


@end

#define JKWhitespaceString(string)       [JKNetCaptureHelper addWhitespaceBesideString:string]
#define JKTrimWhitespaceString(string)   [JKNetCaptureHelper trimWhitespaceBesideString:string]


NS_ASSUME_NONNULL_END
