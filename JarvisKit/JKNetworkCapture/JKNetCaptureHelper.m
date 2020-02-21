//
//  JKNetCaptureHelper.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/16.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKNetCaptureHelper.h"

@implementation JKNetCaptureHelper

+ (BOOL)jk_netCaptureActivate
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:JKNetCaptureActiveKey];
}

+ (void)jk_netCaptureActive:(BOOL)active
{
    [[NSUserDefaults standardUserDefaults] setBool:active forKey:JKNetCaptureActiveKey];
}


+ (NSString *)convertJsonStringFromData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    
    NSString *jsonString = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    if ([NSJSONSerialization isValidJSONObject:jsonObject]) {
        jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    } else {
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


+ (NSData *)getHttpBodyOfRequest:(NSURLRequest *)request
{
    NSData *httpBody;
    if (request.HTTPBody) {
        httpBody = request.HTTPBody;
    }else{
        if ([request.HTTPMethod isEqualToString:@"POST"]) {
            if (!request.HTTPBody) {
                uint8_t d[1024] = {0};
                NSInputStream *stream = request.HTTPBodyStream;
                NSMutableData *data = [[NSMutableData alloc] init];
                [stream open];
                while ([stream hasBytesAvailable]) {
                    NSInteger len = [stream read:d maxLength:1024];
                    if (len > 0 && stream.streamError == nil) {
                        [data appendBytes:(void *)d length:len];
                    }
                }
                httpBody = [data copy];
                [stream close];
            }
        }
    }
    return httpBody;
}


+ (NSUInteger)getRequestLength:(NSURLRequest *)request
{
    NSDictionary<NSString *, NSString *> *headerFields = request.allHTTPHeaderFields;
    NSDictionary<NSString *, NSString *> *cookiesHeader = [self getCookies:request];
    if (cookiesHeader.count) {
        NSMutableDictionary *headerFieldsWithCookies = [NSMutableDictionary dictionaryWithDictionary:headerFields];
        [headerFieldsWithCookies addEntriesFromDictionary:cookiesHeader];
        headerFields = [headerFieldsWithCookies copy];
    }
    
    NSUInteger headersLength = [self getHeadersLength:headerFields];
    NSData *httpBody = [self getHttpBodyOfRequest:request];
    NSUInteger bodyLength = [httpBody length];
    return headersLength + bodyLength;
}

+ (NSUInteger)getHeadersLength:(NSDictionary *)headers
{
    NSUInteger headersLength = 0;
    if (headers) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:headers options:NSJSONWritingPrettyPrinted error:nil];
        headersLength = data.length;
    }
    
    return headersLength;
}

+ (NSDictionary<NSString *, NSString *> *)getCookies:(NSURLRequest *)request
{
    NSDictionary<NSString *, NSString *> *cookiesHeader;
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray<NSHTTPCookie *> *cookies = [cookieStorage cookiesForURL:request.URL];
    if (cookies.count) {
        cookiesHeader = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    }
    return cookiesHeader;
}

+ (int64_t)getLengthOfResponse:(NSHTTPURLResponse *)response andResponseData:(NSData *)responseData
{
    int64_t responseLength = 0;
    if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary<NSString *, NSString *> *headerFields = httpResponse.allHeaderFields;
        NSUInteger headersLength = [self getHeadersLength:headerFields];
        
        int64_t contentLength = 0.;
        if(httpResponse.expectedContentLength != NSURLResponseUnknownLength){
            contentLength = httpResponse.expectedContentLength;
        }else{
            contentLength = responseData.length;
        }
        
        responseLength = headersLength + contentLength;
    }
    return responseLength;
}

+ (NSString *)jk_getDateFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}

@end


@implementation JKNetCaptureHelper (NSString)

+ (NSString *)addWhitespaceBesideString:(NSString *)string
{
    return [NSString stringWithFormat:@" %@ ", string];
}


+ (NSString *)trimWhitespaceBesideString:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
