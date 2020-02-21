//
//  JKDeviceInfoHelper.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/7.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKDeviceInfoHelper.h"
#import <sys/utsname.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <sys/mount.h>
#import <CoreLocation/CLLocationManager.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
@import EventKit;
@import CoreTelephony;

@implementation JKDeviceInfoHelper

/// 设备型号
+ (NSString *)deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *device = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([device isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([device isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([device isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([device isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([device isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([device isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([device isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([device isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([device isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    if ([device isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    if ([device isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    if ([device isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([device isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([device isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([device isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    if ([device isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    if ([device isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([device isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([device isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([device isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([device isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    if ([device isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([device isEqualToString:@"iPhone10.4"]) return @"iPhone 8";
    if ([device isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([device isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([device isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([device isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([device isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([device isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    if ([device isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([device isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([device isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([device isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([device isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    
    return device;
}

/// 系统版本
+ (NSString *)iOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

/// 是否越狱
+ (NSString *)isJailbreak;
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]) {
        return @"YES";
    } else {
        return @"NO";
    }
}

/// 机身容量
+ (NSString *)deviceCapacity
{
    // 总容量
    struct statfs buf;
    unsigned long long totalSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        totalSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    
    // 可用容量
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
        
    return [NSString stringWithFormat:@"%lluG", (totalSpace / 1024 / 1024 / 1024)];
}

+ (NSString *)appDisplayName
{
    NSString *appDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    if (!appDisplayName) {
        appDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    }
    return appDisplayName ? : @"unknown";
}

/// BundleId
+ (NSString *)bundleId
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

/// app版本号
+ (NSString *)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ? : @"unknown";
}

/// build号
+ (NSString *)buildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ? : @"unknown";
}

+ (NSString *)minimumOSVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"MinimumOSVersion"] ? : @"unknown";
}

@end

@implementation JKDeviceInfoHelper (Authorization)

/// 定位权限
+ (NSString *)locationAuthority
{
    NSString *authority = @"";
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus state = [CLLocationManager authorizationStatus];
        if (state == kCLAuthorizationStatusNotDetermined) {
            authority = @"NotDetermined";
        }else if(state == kCLAuthorizationStatusRestricted){
            authority = @"Restricted";
        }else if(state == kCLAuthorizationStatusDenied){
            authority = @"Denied";
        }else if(state == kCLAuthorizationStatusAuthorizedAlways){
            authority = @"Authorized";
        }else if(state == kCLAuthorizationStatusAuthorizedWhenInUse){
            authority = @"WhenInUse";
        }
    }else{
        authority = @"NoEnabled";
    }
    return authority;
}

/// 推送权限
+ (NSString *)pushAuthority
{
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
        return @"NO";
    }
    return @"YES";
}

/// 网络访问权限
+ (void)fetchNetAuthorityWithCompletion:(void (^)(NSString *authority))completion
{
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        NSString *authority = @"Unknown";
        switch (state) {
            case kCTCellularDataRestricted:
                authority = @"网络访问受限";
                break;
            case kCTCellularDataNotRestricted:
                authority = @"网络访问正常";
                break;
            case kCTCellularDataRestrictedStateUnknown:
                authority = @"网络访问状态未知";
                break;
            default:
                break;
        }
        completion(authority);
    };
}

/// 相机权限
+ (NSString *)cameraAuthority
{
    NSString *authority = @"";
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            authority = @"NotDetermined";
            break;
        case AVAuthorizationStatusRestricted:
            authority = @"Restricted";
            break;
        case AVAuthorizationStatusDenied:
            authority = @"Denied";
            break;
        case AVAuthorizationStatusAuthorized:
            authority = @"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

/// 录音权限
+ (NSString *)audioAuthority
{
    NSString *authority = @"";
    NSString *mediaType = AVMediaTypeAudio;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            authority = @"NotDetermined";
            break;
        case AVAuthorizationStatusRestricted:
            authority = @"Restricted";
            break;
        case AVAuthorizationStatusDenied:
            authority = @"Denied";
            break;
        case AVAuthorizationStatusAuthorized:
            authority = @"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

/// 相册权限
+ (NSString *)photoAuthority
{
    NSString *authority = @"";
    PHAuthorizationStatus current = [PHPhotoLibrary authorizationStatus];
    switch (current) {
        case PHAuthorizationStatusNotDetermined:    //用户还没有选择(第一次)
        {
            authority = @"NotDetermined";
        }
            break;
        case PHAuthorizationStatusRestricted:       //家长控制
        {
            authority = @"Restricted";
        }
            break;
        case PHAuthorizationStatusDenied:           //用户拒绝
        {
            authority = @"Denied";
        }
            break;
        case PHAuthorizationStatusAuthorized:       //已授权
        {
            authority = @"Authorized";
        }
            break;
        default:
            break;
    }
    return authority;
}

/// 通讯录权限
+ (NSString *)addressAuthority
{
    NSString *authority = @"";
    CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (authStatus) {
        case CNAuthorizationStatusAuthorized:
            authority = @"Authorized";
            break;
        case CNAuthorizationStatusDenied:
        {
            authority = @"Denied";
        }
            break;
        case CNAuthorizationStatusNotDetermined:
        {
            authority = @"NotDetermined";
        }
            break;
        case CNAuthorizationStatusRestricted:
            authority = @"Restricted";
            break;
    }
    return authority;
}

/// 日历访问权限
+ (NSString *)calendarAuthority
{
    NSString *authority = @"";
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status) {
        case EKAuthorizationStatusNotDetermined:
            authority = @"NotDetermined";
            break;
        case EKAuthorizationStatusRestricted:
            authority = @"Restricted";
            break;
        case EKAuthorizationStatusDenied:
            authority = @"Denied";
            break;
        case EKAuthorizationStatusAuthorized:
            authority = @"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

/// 备忘录访问权限
+ (NSString *)remindAuthority
{
    NSString *authority = @"";
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    switch (status) {
        case EKAuthorizationStatusNotDetermined:
            authority = @"NotDetermined";
            break;
        case EKAuthorizationStatusRestricted:
            authority = @"Restricted";
            break;
        case EKAuthorizationStatusDenied:
            authority = @"Denied";
            break;
        case EKAuthorizationStatusAuthorized:
            authority = @"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

/// 蓝牙权限
+ (NSString *)bluetoothAuthority
{
    return @"";
}

/// Biometry权限(FaceID & TouchID)
+ (NSString *)biometryAuthority
{
    return @"";
}

@end
