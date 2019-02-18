//
//  JKUserDefaultsModel.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/4.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JKUserDefaultsValueType) {
    JKUserDefaultsValueTypeNumber,      // 包括Integer,Float,Double,NSNumber
    JKUserDefaultsValueTypeBool,        // __NSCFBoolean
    JKUserDefaultsValueTypeString,
    JKUserDefaultsValueTypeArray,
    JKUserDefaultsValueTypeDictionary,
    JKUserDefaultsValueTypeDate,        // NSDate
    JKUserDefaultsValueTypeData,        // NSData
    JKUserDefaultsValueTypeUnknow
};

NS_ASSUME_NONNULL_BEGIN

@interface JKUserDefaultsModel : NSObject

/// NSUSerDefaults对应的key
@property(nonatomic, copy) NSString *key;
/// NSUSerDefaults对应的value
@property(nonatomic, strong) id value;

/// 判断value之后得出的类型
@property(nonatomic, assign) JKUserDefaultsValueType valueType;
/// 展示的value字符串
@property(nonatomic, copy) NSString *displayValue;
/// 展示的value type字符串
@property(nonatomic, copy) NSString *displayValueType;

/// 是否可被选择进入查看value的详情
@property(nonatomic, assign) BOOL selectable;
/// 是否可被编辑
@property(nonatomic, assign) BOOL editable;
/// 对应是跟节点，也就是JKUserDefaultsViewController的首页
@property(nonatomic, assign) BOOL isRoot;

/// 模型对用cell的高度
@property(nonatomic, assign) CGFloat cellHeight;


/**
 初始化方法

 @param key NSUSerDefaults对应的value
 @param value NSUSerDefaults对应的value
 @return 实例对象
 */
- (instancetype)initWithKey:(NSString *)key andValue:(id)value;

@end

NS_ASSUME_NONNULL_END
