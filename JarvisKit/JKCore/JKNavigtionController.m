//
//  JKNavigtionController.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/8.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKNavigtionController.h"
#import "JKHelper.h"

@interface JKNavigtionController ()

@end

@implementation JKNavigtionController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 导航栏主题色和背景
    self.navigationBar.tintColor = [UIColor redColor];
}

/// 将状态栏的样式交给topViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

@end
