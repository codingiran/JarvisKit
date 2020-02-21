//
//  JKUserDefaultsModel.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/4.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKUserDefaultsModel.h"
#import "JKUserDefaultsHelper.h"

@implementation JKUserDefaultsModel

- (instancetype)init
{
    if (self = [super init]) {
        self.isRoot = NO;
        self.selectable = NO;
    }
    return self;
}

- (instancetype)initWithKey:(NSString *)key andValue:(id)value
{
    if (self = [super init]) {
        self.key = key;
        self.value = value;
    }
    return self;
}

- (void)setValue:(id)value
{
    _value = value;
    
    self.valueType = JKUserDefaultsValueTypeUnknow;
    self.displayValue = [NSString stringWithFormat:@""];
    self.displayValueType = @"类型: 未知";
    self.selectable = NO;
    self.editable = NO;

    NSString *classString = NSStringFromClass([value class]);
    if ([classString isEqualToString:@"__NSCFArray"] || [value isKindOfClass:[NSArray class]]) {
        self.valueType = JKUserDefaultsValueTypeArray;
    }
    if ([classString isEqualToString:@"__NSCFDictionary"] || [value isKindOfClass:[NSDictionary class]]) {
        self.valueType = JKUserDefaultsValueTypeDictionary;
    }
    if ([classString isEqualToString:@"__NSCFString"] || [classString isEqualToString:@"NSTaggedPointerString"]  || [value isKindOfClass:[NSString class]]) {
        self.valueType = JKUserDefaultsValueTypeString;
    }
    if ([classString isEqualToString:@"__NSDate"]) {
        self.valueType = JKUserDefaultsValueTypeDate;
    }
    if ([classString isEqualToString:@"__NSCFBoolean"]) {
        self.valueType = JKUserDefaultsValueTypeBool;
    }
    if ([classString isEqualToString:@"__NSCFNumber"]) {
        self.valueType = JKUserDefaultsValueTypeNumber;
    }
    
    if ([classString isEqualToString:@"__NSCFData"]) {
        self.valueType = JKUserDefaultsValueTypeData;
    }
    
//    if (self.valueType != JKUserDefaultsValueTypeUnknow) {
//        self.displayValueType = [NSString stringWithFormat:@"类型: %@", NSStringFromClass([value class])];
//    }
}

- (void)setValueType:(JKUserDefaultsValueType)valueType
{
    _valueType = valueType;
    
    if (valueType == JKUserDefaultsValueTypeArray) {
        self.displayValue = [NSString stringWithFormat:@""];
        self.displayValueType = @"类型: NSArray";
        self.selectable = YES;
        self.editable = NO;
    }
    if (valueType == JKUserDefaultsValueTypeDictionary) {
        self.displayValue = [NSString stringWithFormat:@""];
        self.displayValueType = @"类型: NSDictionary";
        self.selectable = YES;
        self.editable = NO;
    }
    if (valueType == JKUserDefaultsValueTypeString) {
        self.displayValue = [NSString stringWithFormat:@"%@", self.value];
        self.displayValueType = @"类型: NSString";
        self.selectable = NO;
        self.editable = YES;
    }
    if (valueType == JKUserDefaultsValueTypeDate) {
        NSDate *date = (NSDate *)self.value;
        self.displayValue = [NSString stringWithFormat:@"%@", [JKUserDefaultsHelper dateStringFromDate:date]];
        self.displayValueType = @"类型: NSDate";
        self.selectable = NO;
        self.editable = NO;
    }
    if (valueType == JKUserDefaultsValueTypeBool) {
        self.displayValue = [[self.value description] isEqualToString:@"1"] ? @"YES" : @"NO";
        self.displayValueType = @"类型: BOOL";
        self.selectable = NO;
        self.editable = YES;
    }
    if (valueType == JKUserDefaultsValueTypeNumber) {
        NSNumber *number = (NSNumber *)self.value;
        self.displayValue = [NSString stringWithFormat:@"%@", [number description]];
        self.displayValueType = @"类型: NSNumber";
        self.selectable = NO;
        self.editable = YES;
    }
    if (valueType == JKUserDefaultsValueTypeData) {
        self.displayValue = @"不支持查看";
        self.displayValueType = @"类型: NSData";
        self.selectable = NO;
        self.editable = NO;
    }
}

@end
