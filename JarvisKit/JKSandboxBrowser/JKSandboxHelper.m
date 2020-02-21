//
//  JKSandboxHelper.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/2.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKSandboxHelper.h"
#import "JKSandboxFavPathModel.h"

@implementation JKSandboxHelper

+ (NSString *)sanboxRootPath
{
    return NSHomeDirectory();
}

+ (NSString *)getRelativePathFromAbsolutePath:(NSString *)pathString
{
    if (!pathString.isAbsolutePath) {
        return nil;
    }
    return [pathString stringByReplacingOccurrencesOfString:[self sanboxRootPath] withString:@"~"];
}

+ (NSString *)getAbsolutePathFromRelativePath:(NSString *)pathString
{
    if (![pathString containsString:@"~"]) {
        return nil;
    }
    return [pathString stringByReplacingOccurrencesOfString:@"~" withString:[self sanboxRootPath]];
}

+ (void)addFavoritePath:(JKSandboxFavPathModel *)pathModel
{
    NSString *pathString = pathModel.favoritePath;
    if (!pathString || !pathString.length) return;
    
    NSArray<NSDictionary<NSString *, NSString *> *> *paths = [[NSUserDefaults standardUserDefaults] objectForKey:JKSandboxFavoritePathKey];
    if (!paths) {
        paths = @[@{@"favoritePathName" : pathModel.favoriteName, @"favoritePath" : pathString}];
        [[NSUserDefaults standardUserDefaults] setObject:paths forKey:JKSandboxFavoritePathKey];
    } else {
        NSMutableArray<NSDictionary<NSString *, NSString *> *> *multablePaths = [paths mutableCopy];
        [multablePaths addObject:@{@"favoritePathName" : pathModel.favoriteName, @"favoritePath" : pathString}];
        [[NSUserDefaults standardUserDefaults] setObject:multablePaths.copy forKey:JKSandboxFavoritePathKey];
    }
}

+ (BOOL)removeFavoritePath:(NSInteger)pathIndex
{
    NSArray<NSDictionary<NSString *, NSString *> *> *paths = [[NSUserDefaults standardUserDefaults] objectForKey:JKSandboxFavoritePathKey];
    
    if (!paths || ![paths isKindOfClass:[NSArray class]] || !paths.count) return NO;
    
    NSMutableArray<NSDictionary<NSString *, NSString *> *> *multablePaths = [paths mutableCopy];
    if (multablePaths.count - 1 < pathIndex) return NO;
    
    [multablePaths removeObjectAtIndex:pathIndex];
    [[NSUserDefaults standardUserDefaults] setObject:multablePaths.copy forKey:JKSandboxFavoritePathKey];
    return YES;
}

+ (nullable NSArray<JKSandboxFavPathModel *> *)getAllFavoritePaths
{
    NSArray<NSDictionary<NSString *, NSString *> *> *paths = [[NSUserDefaults standardUserDefaults] objectForKey:JKSandboxFavoritePathKey];
    if (!paths || ![paths isKindOfClass:[NSArray class]] || !paths.count) return nil;
    
    NSMutableArray<JKSandboxFavPathModel *> *pathModels = [NSMutableArray arrayWithCapacity:paths.count];
    [paths enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKSandboxFavPathModel *model = [[JKSandboxFavPathModel alloc] init];
        model.favoriteName = obj[@"favoritePathName"];
        model.favoritePath = obj[@"favoritePath"];
        [pathModels addObject:model];
    }];
    
    return pathModels.copy;
}

@end

@implementation JKSandboxHelper (FileManager)

+ (BOOL)isDirectoryWithPath:(NSString *)path
{
    BOOL isDir = YES;
    BOOL exsist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    return exsist && isDir;
}

+ (BOOL)creatFileWithPath:(NSString *)filePath
{
    BOOL isSuccess = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL temp = [fileManager fileExistsAtPath:filePath];
    if (temp) {
        return YES;
    }
    NSError *error;
    //stringByDeletingLastPathComponent:删除最后一个路径节点
    NSString *dirPath = [filePath stringByDeletingLastPathComponent];
    isSuccess = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"creat File Failed. errorInfo:%@",error);
    }
    if (!isSuccess) {
        return isSuccess;
    }
    isSuccess = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    return isSuccess;
}

+ (BOOL)creatDirectoryWithPath:(NSString *)dirPath
{
    BOOL ret = YES;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:dirPath];
    if (!isExist) {
        NSError *error;
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!isSuccess) {
            ret = NO;
//            NSLog(@"creat Directory Failed. errorInfo:%@",error);
        }
    } else {
        dirPath = [dirPath stringByAppendingString:@"_new"];
        ret = [self creatDirectoryWithPath:dirPath];
    }
    return ret;
}

+ (BOOL)removeFileOfPath:(NSString *)filePath
{
    BOOL flag = YES;
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:filePath]) {
        if (![fileManage removeItemAtPath:filePath error:nil]) {
            flag = NO;
        }
    }
    return flag;
}

+ (BOOL)saveFile:(NSString *)filePath withData:(NSData *)data
{
    BOOL ret = YES;
    ret = [self creatFileWithPath:filePath];
    if (ret) {
        ret = [data writeToFile:filePath atomically:YES];
        if (!ret) {
            NSLog(@"%s Failed",__FUNCTION__);
        }
    } else {
        NSLog(@"%s Failed",__FUNCTION__);
    }
    return ret;
}

+ (BOOL)isDeletableFileAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager isDeletableFileAtPath:filePath];
}

+ (BOOL)isWritableFileAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager isWritableFileAtPath:filePath];
}

+ (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fromPath]) {
        NSLog(@"Error: fromPath Not Exist");
        return NO;
    }
    if (![fileManager fileExistsAtPath:toPath]) {
        NSLog(@"Error: toPath Not Exist");
        return NO;
    }
    NSString *headerComponent = [toPath stringByDeletingLastPathComponent];
    if ([self creatFileWithPath:headerComponent]) {
        return [fileManager moveItemAtPath:fromPath toPath:toPath error:nil];
    } else {
        return NO;
    }
}

+ (BOOL)renameFileOrDirectoryAtPath:(NSString *)path withNewName:(NSString *)newName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 文件不存在或者新名称为空
    if (![fileManager fileExistsAtPath:path] || !newName.length) return NO;
    
    if ([self isDirectoryWithPath:path]) {
        // 文件夹
        NSError *error;
        NSString *newDirPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
        BOOL isSuccess = [fileManager moveItemAtPath:path toPath:newDirPath error:&error];
        return isSuccess;
    } else {
        // 文件
        NSError *error;
        NSString *extend = [path pathExtension];// 文件后缀
        NSString *newDirPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", newName, extend]];
        BOOL isSuccess = [fileManager moveItemAtPath:path toPath:newDirPath error:&error];
        return isSuccess;
    }
}

+ (BOOL)renameFileAtPath:(NSString *)filePath withNewName:(NSString *)newName
{
    if (![self isDirectoryWithPath:filePath]) {// 文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSString *extend = [filePath pathExtension];// 文件后缀
        NSString *newDirPath = [[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", newName, extend]];
        BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:newDirPath error:&error];
        return isSuccess;
    } else {// 文件夹
        return NO;
    }
    
    
    return YES;
}

+ (BOOL)renameDirectoryAtPath:(NSString *)dirPath withNewName:(NSString *)newName
{
    if ([self isDirectoryWithPath:dirPath]) {// 文件夹
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSString *newDirPath = [[dirPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
        BOOL isSuccess = [fileManager moveItemAtPath:dirPath toPath:newDirPath error:&error];
        return isSuccess;
    } else {// 文件
        return NO;
    }
}

+ (NSInteger)getFileSizeOfPath:(NSString *)path
{
    NSInteger fileSize = 0;
    NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    if (isExist){
        if(isDir){
            //文件夹
            NSArray *dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            NSString *subPath = nil;
            for(NSString *str in dirArray) {
                subPath = [path stringByAppendingPathComponent:str];
                fileSize += [self getFileSizeOfPath:subPath];
            }
        }else{
            //文件
            NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            NSInteger size = [dict[@"NSFileSize"] integerValue];
            fileSize += size;
        }
    }else{
        fileSize = 0;
    }
    
    return fileSize;
}

@end


@implementation JKSandboxHelper (ImagePicker)

+ (BOOL)isPhotoLibraryAvailable
{
    return [self isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL)isCameraAvailable
{
    return [self isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)isSavedPhotosAlbumAvailable
{
    return [self isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

+ (BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType
{
    return [UIImagePickerController isSourceTypeAvailable:sourceType];
}

@end
