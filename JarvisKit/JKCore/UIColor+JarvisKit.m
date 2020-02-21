//
//  UIColor+JarvisKit.m
//  JarvisKitDemo
//
//  Created by CodingIran on 2020/2/13.
//  Copyright © 2020 CodingIran. All rights reserved.
//

#import "UIColor+JarvisKit.h"

@implementation UIColor (JarvisKit)

+ (UIColor *)jk_colorWithHexString:(NSString *)hexString
{
    if (hexString.length <= 0) return nil;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default: {
            NSAssert(NO, @"Color value %@ is invalid. It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString);
            return nil;
        }
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end

@implementation NSString (WEHexStringToRGBAString)

- (nullable NSString *)jk_rgbaString
{
    if (self.length <= 0) return nil;
    
    NSString *colorString = [[self stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [UIColor colorComponentFrom: colorString start: 0 length: 1];
            green = [UIColor colorComponentFrom: colorString start: 1 length: 1];
            blue  = [UIColor colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [UIColor colorComponentFrom: colorString start: 0 length: 1];
            red   = [UIColor colorComponentFrom: colorString start: 1 length: 1];
            green = [UIColor colorComponentFrom: colorString start: 2 length: 1];
            blue  = [UIColor colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [UIColor colorComponentFrom: colorString start: 0 length: 2];
            green = [UIColor colorComponentFrom: colorString start: 2 length: 2];
            blue  = [UIColor colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [UIColor colorComponentFrom: colorString start: 0 length: 2];
            red   = [UIColor colorComponentFrom: colorString start: 2 length: 2];
            green = [UIColor colorComponentFrom: colorString start: 4 length: 2];
            blue  = [UIColor colorComponentFrom: colorString start: 6 length: 2];
            break;
        default: {
            NSAssert(NO, @"Color value %@ is invalid. It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", self);
            return nil;
        }
            break;
    }
    
    return [NSString stringWithFormat:@"(%.0f,%.0f,%.0f,%.1f)", red * 255.f, green * 255.f, blue * 255.f, alpha];
}

@end
