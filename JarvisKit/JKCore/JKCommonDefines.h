//
//  JKCommonDefines.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/2/12.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#pragma mark - UIEdgeInsets

/// 传入size，返回一个x/y为0的CGRect
CG_INLINE CGRect
JKRectMakeWithSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}

/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
JKUIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
JKUIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}
/// 为给定的rect往内部缩小insets的大小
CG_INLINE CGRect
JKCGRectInsetEdges(CGRect rect, UIEdgeInsets insets) {
    rect.origin.x += insets.left;
    rect.origin.y += insets.top;
    rect.size.width -= JKUIEdgeInsetsGetHorizontalValue(insets);
    rect.size.height -= JKUIEdgeInsetsGetVerticalValue(insets);
    return rect;
}

/**
 某些地方可能会将 CGFLOAT_MIN 作为一个数值参与计算（但其实 CGFLOAT_MIN 更应该被视为一个标志位而不是数值），可能导致一些精度问题，所以提供这个方法快速将 CGFLOAT_MIN 转换为 0
 */
CG_INLINE CGFloat
JKRemoveFloatMin(CGFloat floatValue) {
    return floatValue == CGFLOAT_MIN ? 0 : floatValue;
}

/**
 基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
 */
CG_INLINE CGFloat
JKFlatSpecificScale(CGFloat floatValue, CGFloat scale) {
    floatValue = JKRemoveFloatMin(floatValue);
    scale = scale ?: ([[UIScreen mainScreen] scale]);
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}

/**
 基于当前设备的屏幕倍数，对传进来的 floatValue 进行像素取整。
 */
CG_INLINE CGFloat
JKFlat(CGFloat floatValue) {
    return JKFlatSpecificScale(floatValue, 0);
}

/// 判断一个 CGRect 是否存在 NaN
CG_INLINE BOOL
JKRectIsNaN(CGRect rect) {
    return isnan(rect.origin.x) || isnan(rect.origin.y) || isnan(rect.size.width) || isnan(rect.size.height);
}

/// 系统提供的 CGRectIsInfinite 接口只能判断 CGRectInfinite 的情况，而该接口可以用于判断 INFINITY 的值
CG_INLINE BOOL
JKRectIsInf(CGRect rect) {
    return isinf(rect.origin.x) || isinf(rect.origin.y) || isinf(rect.size.width) || isinf(rect.size.height);
}

/// 判断一个 CGRect 是否合法（例如不带无穷大的值、不带非法数字）
CG_INLINE BOOL
JKCGRectIsValidated(CGRect rect) {
    return !CGRectIsNull(rect) && !CGRectIsInfinite(rect) && !JKRectIsNaN(rect) && !JKRectIsInf(rect);
}

/// 判断一个 CGSize 是否为空（宽或高为0）
CG_INLINE BOOL
JKSizeIsEmpty(CGSize size) {
    return size.width <= 0 || size.height <= 0;
}

/// 将一个 CGSize 像素对齐
CG_INLINE CGSize
JKSizeFlatted(CGSize size) {
    return CGSizeMake(JKFlat(size.width), JKFlat(size.height));
}

/// 对CGRect的x/y、width/height都调用一次flat，以保证像素对齐
CG_INLINE CGRect
JKRectFlatted(CGRect rect) {
    return CGRectMake(JKFlat(rect.origin.x), JKFlat(rect.origin.y), JKFlat(rect.size.width), JKFlat(rect.size.height));
}

#pragma mark - Frame相关
CG_INLINE CGRect
JKRectSetX(CGRect rect, CGFloat x) {
    rect.origin.x = JKFlat(x);
    return rect;
}

CG_INLINE CGRect
JKRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = JKFlat(y);
    return rect;
}

CG_INLINE CGRect
JKRectSetXY(CGRect rect, CGFloat x, CGFloat y) {
    rect.origin.x = JKFlat(x);
    rect.origin.y = JKFlat(y);
    return rect;
}

CG_INLINE CGRect
JKRectSetWidth(CGRect rect, CGFloat width) {
    if (width < 0) {
        return rect;
    }
    rect.size.width = JKFlat(width);
    return rect;
}

CG_INLINE CGRect
JKRectSetHeight(CGRect rect, CGFloat height) {
    if (height < 0) {
        return rect;
    }
    rect.size.height = JKFlat(height);
    return rect;
}

CG_INLINE CGRect
JKRectSetSize(CGRect rect, CGSize size) {
    rect.size = JKSizeFlatted(size);
    return rect;
}

/// 为一个CGRect叠加scale计算
CG_INLINE CGRect
JKRectApplyScale(CGRect rect, CGFloat scale) {
    return JKRectFlatted(CGRectMake(CGRectGetMinX(rect) * scale, CGRectGetMinY(rect) * scale, CGRectGetWidth(rect) * scale, CGRectGetHeight(rect) * scale));
}


#pragma mark - 交换方法

CG_INLINE BOOL
JKExchangeMethod(Class _class, SEL _originSelector, Method _originMethod, SEL _newSelector, Method _newMethod) {
    if (!_class) {
        return NO;
    }
    if (!_newMethod) {
        return NO;
    }
    BOOL isAddedMethod = class_addMethod(_class, _originSelector, method_getImplementation(_newMethod), method_getTypeEncoding(_newMethod));
    if (isAddedMethod) {
        // 如果 class_addMethod 成功了，说明之前 fromClass 里并不存在 originSelector，所以要用一个空的方法代替它，以避免 class_replaceMethod 后，后续 toClass 的这个方法被调用时可能会 crash
        IMP oriMethodIMP = method_getImplementation(_originMethod) ?: imp_implementationWithBlock(^(id selfObject) {});
        const char *oriMethodTypeEncoding = method_getTypeEncoding(_originMethod) ?: "v@:";
        class_replaceMethod(_class, _newSelector, oriMethodIMP, oriMethodTypeEncoding);
    } else {
        method_exchangeImplementations(_originMethod, _newMethod);
    }
    return YES;
}

// 交换实例方法
CG_INLINE BOOL
JKExchangeInstanceMethod(Class _class, SEL _originSelector, SEL _newSelector) {
    Method originMethod = class_getInstanceMethod(_class, _originSelector);
    Method newMethod = class_getInstanceMethod(_class, _newSelector);
    return JKExchangeMethod(_class, _originSelector, originMethod, _newSelector, newMethod);
}

// 交换类方法
CG_INLINE BOOL
JKExchangeClassMethod(Class _class, SEL _originSelector, SEL _newSelector) {
    Class cls = object_getClass(_class);
    Method originMethod = class_getClassMethod(cls, _originSelector);
    Method newMethod = class_getClassMethod(cls, _newSelector);
    return JKExchangeMethod(cls, _originSelector, originMethod, _newSelector, newMethod);
}


#pragma mark - UIImagePickerControllerInfoKey
typedef NSString * UIImagePickerControllerInfoKey NS_TYPED_ENUM;

