//
//  JKSandboxModel.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/1.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 沙盒类型
typedef NS_ENUM(NSUInteger, JKSandboxType) {
    JKSandboxTypeRoot,               // 根目录
    JKSandboxTypeSub,                // 子目录
    JKSandboxTypeDirectory,          // 文件夹
    JKSandboxTypeFile,               // 文件
};

/// 文件类型
typedef NS_ENUM(NSUInteger, JKSandboxFileType) {
    JKSandboxFileTypeOther,           // 未支持类型
    JKSandboxFileTypeFolder,          // 文件夹
    JKSandboxFileTypeWord,            // Word
    JKSandboxFileTypeExcel,           // Excel
    JKSandboxFileTypePPT,             // PPT
    JKSandboxFileTypePDF,             // PDF
    JKSandboxFileTypeImage,           // 图片
    JKSandboxFileTypeVideo,           // 视频
    JKSandboxFileTypeSound,           // 音频
    JKSandboxFileTypeArchive,         // 压缩包
    JKSandboxFileTypeTxt,             // 文本
    JKSandboxFileTypePlist,           // plist文件
};

NS_ASSUME_NONNULL_BEGIN

@interface JKSandboxModel : NSObject

/// 名称
@property(nonatomic, copy) NSString *name;
/// 路径
@property(nonatomic, copy) NSString *path;
/// 沙盒类型
@property(nonatomic, assign) JKSandboxType type;
/// 文件类型
@property(nonatomic, assign) JKSandboxFileType fileType;
/// 根据JKSandboxType得到图片名称
@property(nonatomic, copy) NSString *fileTypeImageName;
/// 当前目录下文件size的字符串
@property(nonatomic, copy) NSString *subSizeStr;

/// 计算cell的自适应高度
@property(nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
