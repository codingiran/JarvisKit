//
//  JKSandboxFilePreviewViewController.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/2.
//  Copyright © 2019 wekids. All rights reserved.
//
#import <AVKit/AVKit.h>
#import "JKSandboxFilePreviewViewController.h"
#import <QuickLook/QuickLook.h>
#import <WebKit/WebKit.h>
#import "JKSandboxModel.h"
#import "JKSandboxHelper.h"

@interface JKSandboxFilePreviewViewController ()<UIDocumentInteractionControllerDelegate>

@property(nonatomic, strong) JKSandboxModel *sandboxModel;
@property(nonatomic, strong) UIImageView *imageView;// 图片
@property(nonatomic, strong) UITextView *textView;// 文本
@property(nonatomic, strong) AVPlayerViewController *mediaPlayer;// 视频音频
@property(nonatomic, strong) WKWebView *documentViewer;// 通过webview查看文档

@end

@implementation JKSandboxFilePreviewViewController

- (instancetype)initWithSandboxModel:(JKSandboxModel *)model
{
    if (self = [super init]) {
        self.sandboxModel = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JKSandboxFileType fileType = self.sandboxModel.fileType;
    NSString *filePath = self.sandboxModel.path;
    
    if (fileType == JKSandboxFileTypeImage) {
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        self.imageView.image = image;
        [self.view addSubview:self.imageView];
    } else if (fileType == JKSandboxFileTypeTxt) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        self.textView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.view addSubview:self.textView];
    } else if (fileType == JKSandboxFileTypePlist) {
        self.textView.text = [[NSDictionary dictionaryWithContentsOfFile:filePath] description];
        [self.view addSubview:self.textView];
    } else if (fileType == JKSandboxFileTypeSound || fileType == JKSandboxFileTypeVideo) {
        NSURL *sourceMediaURL = [NSURL fileURLWithPath:filePath];
        AVAsset *mediaAsset = [AVURLAsset URLAssetWithURL:sourceMediaURL options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:mediaAsset];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        self.mediaPlayer.player = player;
        self.mediaPlayer.view.translatesAutoresizingMaskIntoConstraints = YES;
        self.mediaPlayer.showsPlaybackControls = YES;
        self.mediaPlayer.view.bounds = self.view.bounds;
        [self.mediaPlayer.player play];
        [self addChildViewController:self.mediaPlayer];
        [self.view addSubview:self.mediaPlayer.view];
    } else if (fileType == JKSandboxFileTypePDF || fileType == JKSandboxFileTypeWord || fileType == JKSandboxFileTypeExcel || fileType == JKSandboxFileTypePPT || fileType == JKSandboxFileTypeHTML) {
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        [self.documentViewer loadRequest:[NSURLRequest requestWithURL:fileUrl]];
        [self.view addSubview:self.documentViewer];
    } else {
        // 不支持的文件类型
        NSDictionary *attrDict = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightRegular]};
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"暂不支持此文件类型的查看\n\n建议使用分享功能将文件传输到Mac查看" attributes:attrDict];
        [self.textView setAttributedText:attrStr];
        [self.view addSubview:self.textView];
    }
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    
    self.navigationTitle = @"文件预览";
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithImage:JKImageMake(@"jarvis_navi_close") style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
    self.navigationItem.leftBarButtonItem = close;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (_imageView) {
        _imageView.frame = self.view.bounds;
    }
    
    if (_textView) {
        _textView.frame = self.view.bounds;
    }
    
    if (_documentViewer) {
        _documentViewer.frame = self.view.bounds;
    }
}

#pragma mark - UIDocumentInteractionController
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.bounds;
}

#pragma mark - touch event
- (void)dismiss:(UIBarButtonItem *)sender
{
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}


#pragma mark - getter & getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = NO;
        _textView.dataDetectorTypes = UIDataDetectorTypeLink;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.layer.borderWidth = 2.0f;
    }
    return _textView;
}

- (AVPlayerViewController *)mediaPlayer
{
    if (!_mediaPlayer) {
        _mediaPlayer = [[AVPlayerViewController alloc] init];
    }
    return _mediaPlayer;
}

- (WKWebView *)documentViewer
{
    if (!_documentViewer) {
        _documentViewer = [[WKWebView alloc] initWithFrame:self.view.bounds];
    }
    return _documentViewer;
}

@end
