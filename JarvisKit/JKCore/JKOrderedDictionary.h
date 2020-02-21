//
//  JKOrderedDictionary.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/23.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKOrderedDictionary<__covariant KeyType, __covariant ObjectType> : NSObject

/**
 有序字典的初始化方法
 
 @warning 这不是`NSDictionary`的拓展，需要更完整优雅的*有序`NSdictionary`*，
 可以参考[https://github.com/nicklockwood/OrderedDictionary]

 @param firstKey 将所有的参数以"key, value, key, value..."的方式传入
 @return 有序的的字典
 */
- (instancetype)initWithKeysAndObjects:(id)firstKey,...;

@property(nonatomic, assign) NSUInteger count;
@property(nonatomic, copy, readonly) NSArray<KeyType> *allKeys;

- (void)setObject:(ObjectType)object forKey:(KeyType)key;
- (void)addObject:(ObjectType)object forKey:(KeyType)key;
- (void)addObjects:(NSArray<ObjectType> *)objects forKeys:(NSArray<KeyType> *)keys;
- (void)insertObject:(ObjectType)object forKey:(KeyType)key atIndex:(NSInteger)index;
- (void)insertObjects:(NSArray<ObjectType> *)objects forKeys:(NSArray<KeyType> *)keys atIndex:(NSInteger)index;
- (void)removeObject:(ObjectType)object forKey:(KeyType)key;
- (void)removeObject:(ObjectType)object atIndex:(NSInteger)index;
- (ObjectType)objectForKey:(KeyType)key;
- (ObjectType)objectAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
