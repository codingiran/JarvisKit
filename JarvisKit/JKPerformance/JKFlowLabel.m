//
//  JKFlowLabel.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/25.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKFlowLabel.h"
#import "JKNetCaptureDataSource.h"
#import "JKHelper.h"

@interface JKFlowLabel ()

/// 计时器
@property (nonatomic, strong) dispatch_source_t gcdTimer;

@end

@implementation JKFlowLabel
{
    UIFont *_font;
    UIFont *_subFont;
}

+ (instancetype)flowLabel
{
    JKFlowLabel *label = [[JKFlowLabel alloc] initWithFrame:JKFLOWLabelFrame];
    return label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
        
        _font = [UIFont fontWithName:@"Menlo" size:14];
        if (_font) {
            _subFont = [UIFont fontWithName:@"Menlo" size:4];
        } else {
            _font = [UIFont fontWithName:@"Courier" size:14];
            _subFont = [UIFont fontWithName:@"Courier" size:4];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self beginClockRunning];
}

- (void)dealloc
{
    // 取消定时器
    dispatch_source_cancel(_gcdTimer);
    // 清空定时器
    _gcdTimer = nil;
}

/**
 设置计时器
 */
- (void)beginClockRunning
{
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_gcdTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updatLabel];
        });
    });
    // 开始计时
    dispatch_resume(_gcdTimer);
}

- (void)updatLabel
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval start = now - 1;
    
    NSArray<JKNetCaptureModel *> *httpCaptureModelArray = [JKNetCaptureDataSource sharedDataSource].httpCaptureModelArray.copy;
    
    __block NSInteger totalNetFlow = 0;
    [httpCaptureModelArray enumerateObjectsUsingBlock:^(JKNetCaptureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.endTime >= start && obj.endTime <= now) {
            NSString *upFlow = obj.uploadFlow;
            NSString *downFlow = obj.downFlow;
            NSUInteger upFlowInt = [upFlow integerValue];
            NSUInteger downFlowInt = [downFlow integerValue];
            totalNetFlow += (upFlowInt + downFlowInt);
        }
    }];
    
    NSMutableAttributedString *text; UIColor *color;
    if (totalNetFlow == 0) {
        text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zdB FLOW",totalNetFlow]];
        color = [UIColor colorWithHue:0.27 * (1 - 0.2) saturation:1 brightness:0.9 alpha:1];
        [text setAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : _font} range:NSMakeRange(0, text.length - 5)];
        [text setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : _font} range:NSMakeRange(text.length - 4, 4)];
        [text setAttributes:@{NSFontAttributeName : _subFont} range:NSMakeRange(text.length - 4 - 1, 1)];
    } else {
        color = [UIColor colorWithHue:0.27 * 0.2 saturation:1 brightness:0.9 alpha:1];
        text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zdB",totalNetFlow]];
        [text setAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : _font} range:NSMakeRange(0, text.length)];
    }
    
    

    self.attributedText = text;
}


@end
