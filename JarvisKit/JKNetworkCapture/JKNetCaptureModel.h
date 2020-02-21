//
//  JKNetCaptureModel.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/16.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKNetCaptureHelper.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT CGFloat const kLeftMargin;      // 距左边的距离
FOUNDATION_EXPORT CGFloat const kRightMargin;     // 距右边的距离
FOUNDATION_EXPORT CGFloat const kTopBottomMargin; // 距右边的距离
FOUNDATION_EXPORT CGFloat const kLineMargin;      // 每行之间的距离
FOUNDATION_EXPORT CGFloat const kBetweenMargin;   // 没一行两个label之间的距离

#define JKNetCaptureListCellTextFont  JKFontMake(13)

@interface JKNetCaptureModel : NSObject

#pragma mark - 请求
/// 请求标识
@property(nonatomic, copy) NSString *requestId;
/// 请求的NSURLRequest对象
@property(nonatomic, strong) NSURLRequest *request;
/// 请求的url
@property(nonatomic, copy) NSString *url;
/// 请求方法，通常GET或POST
@property(nonatomic, copy) NSString *method;
/// 请求体
@property(nonatomic, copy) NSString *requestBody;

#pragma mark - 返回
/// 返回状态码
@property(nonatomic, copy) NSString *statusCode;
/// 返回的NSURLResponse对象
@property(nonatomic, strong) NSURLResponse *response;
/// 返回的数据
@property(nonatomic, copy) NSData *responseData;
/// 返回体
@property(nonatomic, copy) NSString *responseBody;
/// response的MINEType
@property(nonatomic, copy) NSString *mineType;

#pragma mark - 数据统计
/// 请求开始时间
@property(nonatomic, assign) NSTimeInterval startTime;
/// 请求结束时间
@property(nonatomic, assign) NSTimeInterval endTime;
/// 请求耗时
@property(nonatomic, copy) NSString *totalDuration;
/// 上行流量
@property(nonatomic, copy) NSString *uploadFlow;
/// 下行流量
@property(nonatomic, copy) NSString *downFlow;

#pragma mark - 数据源
@property(nonatomic, assign) CGFloat cellHeight;


#pragma mark - public方法

/**
 初始化方法

 @param request NSURLRequest请求
 @param response NSURLResponse返回
 @param responseData 返回的NSData数据
 @return 实例对象
 */
- (instancetype)initWithRequest:(NSURLRequest *)request andResponse:(NSURLResponse *)response andResponseData:(NSData *)responseData;

@end

NS_ASSUME_NONNULL_END
