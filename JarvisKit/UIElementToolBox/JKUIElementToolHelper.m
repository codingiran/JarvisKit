//
//  JKUIElementToolHelper.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/29.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKUIElementToolHelper.h"

@implementation JKUIElementToolHelper

+ (UIColor *)jk_getColorWithPoint:(CGPoint)point inView:(UIView *)view
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, - point.x, - point.y);
    [view.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    NSString *hexColor = [NSString stringWithFormat:@"#%02x%02x%02x",pixel[0],pixel[1],pixel[2]];
    
    UIColor *color = JKColorMakeWithHex(hexColor);
    return color;
}

@end


@implementation UIColor (JKUIElementTool)

- (NSString *)jk_hexString
{
    NSInteger alpha = self.jk_alpha * 255;
    NSInteger red = self.jk_red * 255;
    NSInteger green = self.jk_green * 255;
    NSInteger blue = self.jk_blue * 255;
    return [[NSString stringWithFormat:@"#%@%@%@%@",
             [self alignColorHexStringLength:[self jk_hexStringWithInteger:alpha]],
             [self alignColorHexStringLength:[self jk_hexStringWithInteger:red]],
             [self alignColorHexStringLength:[self jk_hexStringWithInteger:green]],
             [self alignColorHexStringLength:[self jk_hexStringWithInteger:blue]]] lowercaseString];
}

// 对于色值只有单位数的，在前面补一个0，例如“F”会补齐为“0F”
- (NSString *)alignColorHexStringLength:(NSString *)hexString
{
    return hexString.length < 2 ? [@"0" stringByAppendingString:hexString] : hexString;
}

- (NSString *)jk_hexStringWithInteger:(NSInteger)integer
{
    NSString *hexString = @"";
    NSInteger remainder = 0;
    for (NSInteger i = 0; i < 9; i++) {
        remainder = integer % 16;
        integer = integer / 16;
        NSString *letter = [self hexLetterStringWithInteger:remainder];
        hexString = [letter stringByAppendingString:hexString];
        if (integer == 0) {
            break;
        }
        
    }
    return hexString;
}

- (NSString *)hexLetterStringWithInteger:(NSInteger)integer
{
    NSAssert(integer < 16, @"要转换的数必须是16进制里的个位数，也即小于16，但你传给我是%@", @(integer));
    
    NSString *letter = nil;
    switch (integer) {
        case 10:
            letter = @"A";
            break;
        case 11:
            letter = @"B";
            break;
        case 12:
            letter = @"C";
            break;
        case 13:
            letter = @"D";
            break;
        case 14:
            letter = @"E";
            break;
        case 15:
            letter = @"F";
            break;
        default:
            letter = [[NSString alloc] initWithFormat:@"%@", @(integer)];
            break;
    }
    return letter;
}

- (CGFloat)jk_red
{
    CGFloat r;
    if ([self getRed:&r green:0 blue:0 alpha:0]) {
        return r;
    }
    return 0;
}

- (CGFloat)jk_green
{
    CGFloat g;
    if ([self getRed:0 green:&g blue:0 alpha:0]) {
        return g;
    }
    return 0;
}

- (CGFloat)jk_blue
{
    CGFloat b;
    if ([self getRed:0 green:0 blue:&b alpha:0]) {
        return b;
    }
    return 0;
}

- (CGFloat)jk_alpha
{
    CGFloat a;
    if ([self getRed:0 green:0 blue:0 alpha:&a]) {
        return a;
    }
    return 0;
}

- (CGFloat)jk_hue
{
    CGFloat h;
    if ([self getHue:&h saturation:0 brightness:0 alpha:0]) {
        return h;
    }
    return 0;
}

- (CGFloat)jk_saturation
{
    CGFloat s;
    if ([self getHue:0 saturation:&s brightness:0 alpha:0]) {
        return s;
    }
    return 0;
}

- (CGFloat)jk_brightness
{
    CGFloat b;
    if ([self getHue:0 saturation:0 brightness:&b alpha:0]) {
        return b;
    }
    return 0;
}

@end
