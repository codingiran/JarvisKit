//
//  JKSandboxModel.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/1.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKSandboxModel.h"
#import "JKSandboxHelper.h"

@implementation JKSandboxModel

- (void)setPath:(NSString *)path
{
    _path = [path copy];
    
    NSInteger subSize = [JKSandboxHelper getFileSizeOfPath:path];
    //将文件夹大小转换为 M/KB/B
    NSString *fileSizeStr = @"";
    if (subSize > 1024 * 1024){
        fileSizeStr = [NSString stringWithFormat:@"%.2fM",subSize / 1024.00f /1024.00f];
    }else if (subSize > 1024){
        fileSizeStr = [NSString stringWithFormat:@"%.2fKB",subSize / 1024.00f ];
    }else{
        fileSizeStr = [NSString stringWithFormat:@"%.2fB",subSize / 1.00f];
    }
    self.subSizeStr = fileSizeStr;
}

/// 设置沙盒类型
- (void)setType:(JKSandboxType)type
{
    _type = type;
    if (type == JKSandboxTypeDirectory) {// 目录
        self.fileType = JKSandboxFileTypeFolder;
    } else {// 文件
        // 后缀
        NSString *extend = [[self.path pathExtension] lowercaseString];
        self.fileType = JKSandboxFileTypeOther;
        
        if ([extend isEqualToString:@"doc"] || [extend isEqualToString:@"docx"]) {
            self.fileType = JKSandboxFileTypeWord;
        }
        if ([extend isEqualToString:@"xls"] || [extend isEqualToString:@"xlsx"]) {
            self.fileType = JKSandboxFileTypeExcel;
        }
        if ([extend isEqualToString:@"ppt"] || [extend isEqualToString:@"pptx"]) {
            self.fileType = JKSandboxFileTypePPT;
        }
        if ([extend isEqualToString:@"pdf"]) {
            self.fileType = JKSandboxFileTypePDF;
        }
        if ([extend isEqualToString:@"png"] || [extend isEqualToString:@"jpg"] || [extend isEqualToString:@"jpeg"] || [extend isEqualToString:@"bmp"] || [extend isEqualToString:@"gif"] || [extend isEqualToString:@"tif"] || [extend isEqualToString:@"heic"] || [extend isEqualToString:@"ktx"]) {
            self.fileType = JKSandboxFileTypeImage;
        }
        if ([extend isEqualToString:@"mp4"] || [extend isEqualToString:@"mkv"] || [extend isEqualToString:@"rmvb"] || [extend isEqualToString:@"rm"] || [extend isEqualToString:@"mov"] || [extend isEqualToString:@"avi"] || [extend isEqualToString:@"flv"] || [extend isEqualToString:@"wmv"]) {
            self.fileType = JKSandboxFileTypeVideo;
        }
        if ([extend isEqualToString:@"mp3"] || [extend isEqualToString:@"wav"] || [extend isEqualToString:@"aac"] || [extend isEqualToString:@"ape"] || [extend isEqualToString:@"flac"] || [extend isEqualToString:@"alac"] || [extend isEqualToString:@"mod"] || [extend isEqualToString:@"ogg"]) {
            self.fileType = JKSandboxFileTypeSound;
        }
        if ([extend isEqualToString:@"rar"] || [extend isEqualToString:@"zip"]) {
            self.fileType = JKSandboxFileTypeArchive;
        }
        if ([extend isEqualToString:@"txt"] || [extend isEqualToString:@"strings"] || [extend isEqualToString:@"log"] || [extend isEqualToString:@"csv"] || [extend isEqualToString:@"md"]) {
            self.fileType = JKSandboxFileTypeTxt;
        }
        if ([extend isEqualToString:@"plist"]) {
            self.fileType = JKSandboxFileTypePlist;
        }
    }
}

- (void)setFileType:(JKSandboxFileType)fileType
{
    _fileType = fileType;
    
    switch (fileType) {
        case JKSandboxFileTypeFolder:
            self.fileTypeImageName = @"jarvis_filetype_foler";
            break;
        case JKSandboxFileTypeWord:
            self.fileTypeImageName = @"jarvis_filetype_word";
            break;
        case JKSandboxFileTypeExcel:
            self.fileTypeImageName = @"jarvis_filetype_excel";
            break;
        case JKSandboxFileTypePPT:
            self.fileTypeImageName = @"jarvis_filetype_ppt";
            break;
        case JKSandboxFileTypePDF:
            self.fileTypeImageName = @"jarvis_filetype_pdf";
            break;
        case JKSandboxFileTypeImage:
            self.fileTypeImageName = @"jarvis_filetype_image";
            break;
        case JKSandboxFileTypeVideo:
            self.fileTypeImageName = @"jarvis_filetype_video";
            break;
        case JKSandboxFileTypeSound:
            self.fileTypeImageName = @"jarvis_filetype_sound";
            break;
        case JKSandboxFileTypeArchive:
            self.fileTypeImageName = @"jarvis_filetype_archive";
            break;
        case JKSandboxFileTypeTxt:
            self.fileTypeImageName = @"jarvis_filetype_txt";
            break;
        case JKSandboxFileTypePlist:
            self.fileTypeImageName = @"jarvis_filetype_plist";
            break;
            
        default:
            self.fileTypeImageName = @"jarvis_filetype_other";
            break;
    }
}

// 计算当前model对应的cell自适应高度
- (CGFloat)cellHeight
{
    // size label
    CGSize sizeLabelMaxSize = CGSizeMake(MAXFLOAT, 30);
    CGFloat sizeLabelW = [self.subSizeStr boundingRectWithSize:sizeLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor], NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.width;
    // name label
    CGSize nameLabelMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 12 - 40 - 5 - 10 - sizeLabelW - 5/* name和size的间距 */, MAXFLOAT);
    CGFloat nameLabelH = [self.name boundingRectWithSize:nameLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height;
    
    return nameLabelH + 15 + 15;// 10是上下边距
}

@end
