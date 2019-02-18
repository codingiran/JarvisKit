//
//  UIImage+JarvisKit.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/30.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "UIImage+JarvisKit.h"
#import "JKHelper.h"

@implementation UIImage (JarvisKit)


+ (UIImage *)jk_imageWithView:(UIView *)view
{
    return [UIImage jk_imageWithSize:view.bounds.size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        [view.layer renderInContext:contextRef];
    }];
}

+ (UIImage *)jk_imageWithView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates
{
    // iOS 7 截图新方式，性能好会好一点，不过不一定适用，因为这个方法的使用条件是：界面要已经render完，否则截到得图将会是empty。
    return [UIImage jk_imageWithSize:view.bounds.size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        [view drawViewHierarchyInRect:JKRectMakeWithSize(view.bounds.size) afterScreenUpdates:afterUpdates];
    }];
}

- (UIImage *)jk_imageWithClippedRect:(CGRect)rect
{
    CGRect imageRect = JKRectMakeWithSize(self.size);
    if (CGRectContainsRect(rect, imageRect)) {
        // 要裁剪的区域比自身大，所以不用裁剪直接返回自身即可
        return self;
    }
    // 由于CGImage是以pixel为单位来计算的，而UIImage是以point为单位，所以这里需要将传进来的point转换为pixel
    CGRect scaledRect = JKRectApplyScale(rect, self.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, scaledRect);
    UIImage *imageOut = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return imageOut;
}

+ (UIImage *)jk_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale actions:(void (^)(CGContextRef contextRef))actionBlock
{
    if (!actionBlock || JKSizeIsEmpty(size)) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    actionBlock(context);
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}


@end
