//
//  JKURLProtocol.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/11.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKURLProtocol.h"
#import "JKNetCaptureModel.h"
#import "JKNetCaptureDataSource.h"

//为了避免 canInitWithRequest 和 canonicalRequestForRequest 出现死循环
static NSString * const kJkProtocolKey = @"JarvisKitProtocolKey";

@interface JKURLProtocol ()<NSURLSessionDataDelegate>

/**
 * 记录请求开始的时间
 */
@property(nonatomic, assign) NSTimeInterval requestStartTime;

/**
 * 记录请求结束的时间
 */
@property(nonatomic, assign) NSTimeInterval requestEndTime;

/**
 * 请求对应的NSURLSession
 */
@property(nonatomic, strong) NSURLSession *urlSession;

/**
 * 请求得到的NSURLResponse，比如GET和POST请求的数据
 */
@property(nonatomic, strong) NSURLResponse *response;

/**
 * 下载请求得到的数据，比如用AF下载文件的NSData
 */
@property(nonatomic, strong) NSMutableData *reponseData;

/**
 * 请求的错误
 */
@property(nonatomic, strong) NSError *error;

@end

@implementation JKURLProtocol


/**
 这个方法判断协议是否处理传入的请求

 @param request 传入的请求
 @return 是否处理
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //为了避免 canInitWithRequest 和 canonicalRequestForRequest 出现死循环
    if ([NSURLProtocol propertyForKey:kJkProtocolKey inRequest:request]) {
        return NO;
    }
    
    // 未开启
    if (![JKNetCaptureDataSource sharedDataSource].netCaptureActive) {
        return NO;
    }
    
    // 只处理http和https协议的请求
    if (![request.URL.scheme isEqualToString:@"http"] && [request.URL.scheme isEqualToString:@"https"] ) {
        return NO;
    }
    
    return YES;
}

/**
 是否处理传入的NSURLSessionTask

 @param task NSURLSessionTask请求
 @return 是否处理
 */
+ (BOOL)canInitWithTask:(NSURLSessionTask *)task
{
    return task.currentRequest ? [self canInitWithRequest:task.currentRequest] : NO;
}

/**
 这个方法可以用来对reuqest进行标准化处理，可以理解将原始的request格式化为你需要的标准("canonical")的NSURLRequest
 
 @param request 传入的NSURLRequest
 @return 格式化后的NSURLRequest
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    // 此处拦截request，对其进行标记（可以理解为四代火影对敌人做飞雷神的标记）
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [NSURLProtocol setProperty:@(YES) forKey:kJkProtocolKey inRequest:mutableRequest];
    return mutableRequest.copy;
}

/**
 发起请求
 */
- (void)startLoading
{
    // 记录开始时间
    self.requestStartTime = [[NSDate date] timeIntervalSince1970];
    
    // 初始化文件下载的数据
    self.reponseData = [NSMutableData data];
    
    NSMutableURLRequest *request = [JKURLProtocol canonicalRequestForRequest:self.request].mutableCopy;
    NSURLSessionTask *task = [self.urlSession dataTaskWithRequest:request];
    [task resume];
}

/**
 结束请求
 */
- (void)stopLoading
{
    // 记录结束时间
    self.requestEndTime = [[NSDate date] timeIntervalSince1970];
    
    // 创建模型
    JKNetCaptureModel *model = [[JKNetCaptureModel alloc] initWithRequest:self.request andResponse:self.response andResponseData:self.reponseData];
    model.startTime = self.requestStartTime;
    model.endTime = self.requestEndTime;
    
    // 加入全局数据源
    [[JKNetCaptureDataSource sharedDataSource] addHttpCaptureModel:model];
    
    // 销毁请求
    [self.urlSession invalidateAndCancel];
    self.urlSession = nil;
}


#pragma mark - NSURLSessionDataDelegate
/**
 * 请求完成后拿到的NSURLResponse
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    self.response = response;
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 通常是文件下载后拿到的
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [self.reponseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

/**
 * NSURLSession错误的回调
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    if (error) {
        self.error = error;
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        self.error = nil;
        [self.client URLProtocolDidFinishLoading:self];
    }
}

/**
 * 处理SSL证书等相关的问题
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    //判断服务器返回的证书类型, 是否是服务器信任
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        //强制信任
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

#pragma mark - setter & getter
- (NSURLSession *)urlSession
{
    if (!_urlSession) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return _urlSession;
}


@end


@implementation NSURLRequest (JarvisKit)
static char kAssociatedObjectKey_requestId;
- (void)setRequestId:(NSString *)requestId
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_requestId, requestId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)requestId
{
    return (NSString *)objc_getAssociatedObject(self, &kAssociatedObjectKey_requestId);
}

@end


@implementation NSURLSessionConfiguration (JarvisKit)

#ifdef DEBUG
+ (void)load
{
    JKExchangeClassMethod([self class], @selector(defaultSessionConfiguration), @selector(jk_defaultSessionConfiguration));
    JKExchangeClassMethod([self class], @selector(ephemeralSessionConfiguration), @selector(jk_ephemeralSessionConfiguration));
}
#endif

+ (NSURLSessionConfiguration *)jk_defaultSessionConfiguration
{
    NSURLSessionConfiguration *configuration = [self jk_defaultSessionConfiguration];
    [self setEnabled:YES forSessionConfiguration:configuration];
    return configuration;
}

+ (NSURLSessionConfiguration *)jk_ephemeralSessionConfiguration
{
    NSURLSessionConfiguration *configuration = [self jk_ephemeralSessionConfiguration];
    [self setEnabled:YES forSessionConfiguration:configuration];
    return configuration;
}

+ (void)setEnabled:(BOOL)enabled forSessionConfiguration:(NSURLSessionConfiguration *)sessionConfig{
    if ([sessionConfig respondsToSelector:@selector(protocolClasses)]
        && [sessionConfig respondsToSelector:@selector(setProtocolClasses:)])
    {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray:sessionConfig.protocolClasses];
        Class protoCls = JKURLProtocol.class;
        if (enabled && ![urlProtocolClasses containsObject:protoCls])
        {
            [urlProtocolClasses insertObject:protoCls atIndex:0];
        }
        else if (!enabled && [urlProtocolClasses containsObject:protoCls])
        {
            [urlProtocolClasses removeObject:protoCls];
        }
        sessionConfig.protocolClasses = urlProtocolClasses;
    }
}

@end
