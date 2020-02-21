//
//  NSString+JarvisKit.h
//
//  Created by CodingIran on 16/7/11.
//

#import <Foundation/Foundation.h>

@interface NSString (JarvisKit)

@end

@interface NSString (Hash)

@property (nonatomic, copy, readonly) NSString *md5String;

@property (nonatomic, copy, readonly) NSString *sha1String;

@property (nonatomic, copy, readonly) NSString *sha256String;

@property (nonatomic, copy, readonly) NSString *sha512String;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

@end
