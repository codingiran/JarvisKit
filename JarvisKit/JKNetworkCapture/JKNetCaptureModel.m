//
//  JKNetCaptureModel.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/16.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKNetCaptureModel.h"

CGFloat const kLeftMargin = 15.0f;// 距左边的距离
CGFloat const kRightMargin = 10.0f;// 距右边的距离
CGFloat const kTopBottomMargin = 10.0f;// 距右边的距离
CGFloat const kLineMargin = 5.0f;// 每行之间的距离
CGFloat const kBetweenMargin = 5.0f;// 没一行两个label之间的距离

@implementation JKNetCaptureModel

- (instancetype)initWithRequest:(NSURLRequest *)request andResponse:(NSURLResponse *)response andResponseData:(NSData *)responseData
{
    if (self = [super init]) {
        
        // request
//        self.requestId = request
        self.request = request;
        self.url = request.URL.absoluteString;
        self.method = request.HTTPMethod;
        NSData *httpBody = [JKNetCaptureHelper getHttpBodyOfRequest:request];
        self.requestBody = [JKNetCaptureHelper convertJsonStringFromData:httpBody];
        self.uploadFlow = [NSString stringWithFormat:@"%zd", [JKNetCaptureHelper getRequestLength:request]];
        
        // response
        self.response = response;
        self.mineType = response.MIMEType;
        self.responseData = responseData;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        self.statusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
        self.responseBody = [JKNetCaptureHelper convertJsonStringFromData:responseData];
        self.downFlow = [NSString stringWithFormat:@"%lli", [JKNetCaptureHelper getLengthOfResponse:httpResponse andResponseData:responseData]];
        
    }
    return self;
}

- (void)setEndTime:(NSTimeInterval)endTime
{
    _endTime = endTime;
    self.totalDuration = [NSString stringWithFormat:@"%f", endTime - self.startTime];
}

- (CGFloat)cellHeight
{
    // 计算cell高度
    CGSize labelMaxSize = CGSizeMake(JK_SCREEN_WIDTH - 10 - kLeftMargin - kRightMargin, MAXFLOAT);
    CGFloat urlH = [self.url boundingRectWithSize:labelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor], NSFontAttributeName : JKNetCaptureListCellTextFont} context:nil].size.height;
    
    labelMaxSize = CGSizeMake(MAXFLOAT, 20);
    CGFloat methodH = [JKWhitespaceString(self.method) boundingRectWithSize:labelMaxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor], NSFontAttributeName : JKNetCaptureListCellTextFont} context:nil].size.height;
    
    return kTopBottomMargin + urlH + kLineMargin + methodH + kLineMargin + methodH + kLineMargin + methodH + kTopBottomMargin;
}

@end
