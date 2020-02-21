//
//  JarvisKitManager.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/8.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JarvisKitManager : NSObject

/// 单例
+ (instancetype)sharedManager;

/// 启动方法
- (void)install;

/// 关闭方法
- (void)shutDown;

@end

NS_ASSUME_NONNULL_END
