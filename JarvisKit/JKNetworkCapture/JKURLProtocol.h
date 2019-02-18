//
//  JKURLProtocol.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/11.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKURLProtocol : NSURLProtocol

@end

@interface NSURLRequest (JarvisKit)

@property(nonatomic, copy) NSString *requestId;

@end

@interface NSURLSessionConfiguration (JarvisKit)

@end

NS_ASSUME_NONNULL_END
