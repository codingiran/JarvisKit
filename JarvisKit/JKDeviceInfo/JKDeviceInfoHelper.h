//
//  JKDeviceInfoHelper.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/7.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKDeviceInfoHelper : JKHelper

/// 设备型号
+ (NSString *)deviceModel;

/// 系统版本
+ (NSString *)iOSVersion;

/// 是否越狱
+ (NSString *)isJailbreak;

/// 机身容量
+ (NSString *)deviceCapacity;

/// App名称
+ (NSString *)appDisplayName;

/// BundleId
+ (NSString *)bundleId;

/// app版本号
+ (NSString *)appVersion;

/// build号
+ (NSString *)buildVersion;

/// 最低支持版本号
+ (NSString *)minimumOSVersion;

@end

@interface JKDeviceInfoHelper (Authorization)


/// 定位权限
+ (NSString *)locationAuthority;

/// 推送权限
+ (NSString *)pushAuthority;

/// 网络访问权限（MARK: 网络权限是通过异步回调返回）
+ (void)fetchNetAuthorityWithCompletion:(void (^)(NSString *authority))completion;

/// 相机权限
+ (NSString *)cameraAuthority;

/// 麦克风权限
+ (NSString *)audioAuthority;

/// 相册权限
+ (NSString *)photoAuthority;

/// 通讯录权限
+ (NSString *)addressAuthority;

/// 日历访问权限
+ (NSString *)calendarAuthority;

/// 备忘录访问权限
+ (NSString *)remindAuthority;

/// 蓝牙权限
+ (NSString *)bluetoothAuthority;

/// Biometry权限(FaceID & TouchID)
+ (NSString *)biometryAuthority;


@end



NS_ASSUME_NONNULL_END
