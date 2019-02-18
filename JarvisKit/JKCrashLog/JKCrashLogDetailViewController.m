//
//  JKCrashLogDetailViewController.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/15.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKCrashLogDetailViewController.h"
#import "JKCrashLogModel.h"

@interface JKCrashLogDetailViewController ()

@property(nonatomic, strong) UITextView *textView;// 文本

@property(nonatomic, strong) JKCrashLogModel *crashLogModel;

@end

@implementation JKCrashLogDetailViewController

- (instancetype)initWithCrashLogModel:(JKCrashLogModel *)model
{
    if (self = [super init]) {
        self.crashLogModel = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}

- (void)jk_initSubviews
{
    [super jk_initSubviews];
    self.textView.text = self.crashLogModel.crashContent;
    [self.view addSubview:self.textView];
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    
    self.navigationTitle =  self.crashLogModel.crashName;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareLog:)];
    self.navigationItem.rightBarButtonItems = @[shareItem];    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.textView.frame = self.view.bounds;
}

#pragma mark - touch event
- (void)shareLog:(UIBarButtonItem *)sender
{
    NSString *textToShare = self.textView.text;
    NSArray *activityItems = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

#pragma mark - getter & getter
- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        _textView.alwaysBounceVertical = YES;
        _textView.font = JKFontMake(14);
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

@end
