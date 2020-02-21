//
//  JKNetCaptureDataSource.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/16.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKNetCaptureModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKNetCaptureDataSource : NSObject

/**
 网络抓包是否开启
 */
@property(nonatomic, assign) BOOL netCaptureActive;

/**
 JKNetCaptureModel数组
 */
@property(nonatomic, strong) NSMutableArray<JKNetCaptureModel *> *httpCaptureModelArray;


/**
 使用全局单例保存JKURLProtocol拦截的请求模型

 @return 实例对象
 */
+ (instancetype)sharedDataSource;


/**
 往httpCaptureArray塞入JKNetCaptureModel

 @param captureModel JKNetCaptureModel模型
 */
- (void)addHttpCaptureModel:(JKNetCaptureModel *)captureModel;


/**
 清空httpCaptureArray内所有模型数据
 */
- (void)empty;



@end

NS_ASSUME_NONNULL_END
