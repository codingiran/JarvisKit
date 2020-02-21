//
//  UIColor+JarvisKit.h
//  JarvisKitDemo
//
//  Created by CodingIran on 2020/2/13.
//  Copyright © 2020 CodingIran. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JarvisKit)

+ (UIColor *)jk_colorWithHexString:(NSString *)hexString;

@end

@interface NSString (WEHexStringToRGBAString)

- (nullable NSString *)jk_rgbaString;

@end

NS_ASSUME_NONNULL_END
