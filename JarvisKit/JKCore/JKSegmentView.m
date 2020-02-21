//
//  JKSegmentView.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/18.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKSegmentView.h"
#import "JKHelper.h"

@interface JKSegmentView ()

@property(nonatomic, strong) UISegmentedControl *segmentControl;
/// 下方分隔线
@property(nonatomic, strong) CALayer *borderLayer;

@end

@implementation JKSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"请求数据", @"响应数据"]];
        [self.segmentControl addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
        self.segmentControl.selectedSegmentIndex = 0;
        self.segmentControl.tintColor = JKThemeColor;
        [self addSubview:self.segmentControl];
        
        // 下方添加border
        self.borderLayer = [CALayer layer];
        self.borderLayer.backgroundColor = JKSeparatorColor.CGColor;
        [self.layer addSublayer:self.borderLayer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.segmentControl.frame = JKCGRectInsetEdges(self.bounds, edgeInsets);
    self.borderLayer.frame = CGRectMake(0, self.jk_bottom - JKPixelOne, self.jk_width, JKPixelOne);
}


#pragma mark - touch event
- (void)segmentValueChange:(UISegmentedControl *)segment
{
    // 代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentDidSelecteIndex:)]) {
        [self.delegate segmentDidSelecteIndex:segment.selectedSegmentIndex];
    }
    
    // block
    if (self.segmentSelectedIndex) {
        self.segmentSelectedIndex(segment.selectedSegmentIndex);
    }
}


@end
