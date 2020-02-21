//
//  JkPresentationWindow.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/13.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JkPresentationWindow.h"
#import "JKHelper.h"

@interface JkPresentationWindow ()

@end

@implementation JkPresentationWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = JKPresentationWindowLevel;
        if (!self.rootViewController) {
            self.rootViewController = [[UIViewController alloc] init];
            self.rootViewController.view.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

@end
