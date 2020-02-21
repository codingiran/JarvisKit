//
//  JKNetCaptureDataSource.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/16.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKNetCaptureDataSource.h"
#import "JKURLProtocol.h"

@implementation JKNetCaptureDataSource
{
    dispatch_semaphore_t semaphore;
}

/// ******完整的ARC单例***Begin**********

static JKNetCaptureDataSource *jkNetCaptureDataSource = nil;

+ (instancetype)sharedDataSource
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jkNetCaptureDataSource = [[super allocWithZone:NULL] init];
    });
    return jkNetCaptureDataSource;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedDataSource];
}

- (id)copy
{
    return [self.class sharedDataSource];
}

- (id)mutableCopy
{
    return [self.class sharedDataSource];
}
/// ******完整的ARC单例***End**********


- (instancetype)init
{
    if (self = [super init]) {
        self.httpCaptureModelArray = [NSMutableArray array];
        semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)addHttpCaptureModel:(JKNetCaptureModel *)captureModel
{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self.httpCaptureModelArray insertObject:captureModel atIndex:0];
    dispatch_semaphore_signal(semaphore);
}

- (void)empty
{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self.httpCaptureModelArray removeAllObjects];
    dispatch_semaphore_signal(semaphore);
}

- (void)setNetCaptureActive:(BOOL)netCaptureActive
{
    _netCaptureActive = netCaptureActive;
    
    if (netCaptureActive) {
        // 开启网络抓包
        [NSURLProtocol registerClass:[JKURLProtocol class]];
    } else {
        // 关闭网络抓包
        [NSURLProtocol unregisterClass:[JKURLProtocol class]];
        
        // 关闭后清空抓包数据
        [self.httpCaptureModelArray removeAllObjects];
    }
}

@end
