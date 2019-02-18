//
//  JKSandboxHelper.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/2.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKHelper.h"
@class JKSandboxFavPathModel;

NS_ASSUME_NONNULL_BEGIN

@interface JKSandboxHelper : JKHelper

/**
 将绝对路径转为相对路径
 */
+ (NSString *)getRelativePathFromAbsolutePath:(NSString *)pathString;

/**
 将相对路径转为绝对路径
 */
+ (NSString *)getAbsolutePathFromRelativePath:(NSString *)pathString;

/**
 将文件路径写入本地收藏
 */
+ (void)addFavoritePath:(JKSandboxFavPathModel *)pathModel;

/**
 从本地收藏从删除路径
 */
+ (BOOL)removeFavoritePath:(NSInteger)pathIndex;

/**
 获取本地收藏的所有路径
 */
+ (nullable NSArray<JKSandboxFavPathModel *> *)getAllFavoritePaths;

@end

/// 文件管理相关
@interface JKSandboxHelper (FileManager)

/**
 判断路径下是否文件夹

 @param path 需要判断的路径
 */
+ (BOOL)isDirectoryWithPath:(NSString *)path;

/**
 创建文件

 @param filePath 需要创建的路径
 */
+ (BOOL)creatFileWithPath:(NSString *)filePath;

/**
 创建路径

 @param dirPath 需要创建的路径
 */
+ (BOOL)creatDirectoryWithPath:(NSString *)dirPath;

/**
 是否可以删除

 @param filePath 需要判断被删除的文件路径
 */
+ (BOOL)isDeletableFileAtPath:(NSString *)filePath;

/**
 是否可以写入
 
 @param filePath 需要判断被写入的文件路径
 */
+ (BOOL)isWritableFileAtPath:(NSString *)filePath;

/**
 删除路径，文件

 @param filePath 需要删除的路径
 */
+ (BOOL)removeFileOfPath:(NSString *)filePath;


/**
 保存文件

 @param filePath 文件所要保存的路径
 @param data 文件数据
 */
+ (BOOL)saveFile:(NSString *)filePath withData:(NSData *)data;


/**
 移动文件

 @param fromPath 移动文件的初始路径
 @param toPath 移动文件的目标路径
 */
+ (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;


/**
 重命名文件或文件夹(对是文件夹或文件做了区分处理) = renameFileAtPath: + renameDirectoryAtPath:

 @param path 需要重命名的文件或文件夹路径
 @param newName 新的名称
 */
+ (BOOL)renameFileOrDirectoryAtPath:(NSString *)path withNewName:(NSString *)newName;

/**
 重命名文件

 @param filePath 需要重命名的文件路径
 @param newName 新的名称
 */
+ (BOOL)renameFileAtPath:(NSString *)filePath withNewName:(NSString *)newName;


/**
 重命名文件夹

 @param dirPath 需要重命名的文件夹
 @param newName 新的名称
 */
+ (BOOL)renameDirectoryAtPath:(NSString *)dirPath withNewName:(NSString *)newName;


/**
 获取路径下文件的大小，如果是文件夹进统计该文件夹下所有文件的总大小

 @param path 路径
 @return 文件的大小
 */
+ (NSInteger)getFileSizeOfPath:(NSString *)path;

@end

/// 图片、视频选择相关
@interface JKSandboxHelper (ImagePicker)

/**
 相册是否可用
 */
+ (BOOL)isPhotoLibraryAvailable;

/**
 相机是否可用
 */
+ (BOOL)isCameraAvailable;

/**
 相簿是否可用
 */
+ (BOOL)isSavedPhotosAlbumAvailable;

@end


NS_ASSUME_NONNULL_END
