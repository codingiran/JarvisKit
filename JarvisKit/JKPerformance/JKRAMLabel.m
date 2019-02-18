//
//  JKRAMLabel.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/25.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKRAMLabel.h"
#import "JKPerformanceHelper.h"

@interface JKRAMLabel ()

/// 计时器
@property (nonatomic, strong) dispatch_source_t gcdTimer;

@end

@implementation JKRAMLabel
{
    UIFont *_font;
    UIFont *_subFont;
}

+ (instancetype)ramLabel
{
    JKRAMLabel *label = [[JKRAMLabel alloc] initWithFrame:JKRAMLabelFrame];
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
    CGFloat ramUsage = [JKPerformanceHelper useMemoryForApp];
    
    /// 通常在总内存的50%-70%系统会杀掉app，因此将预警线设定在40%
    /// https://stackoverflow.com/questions/5887248/ios-app-maximum-memory-budget/5887783#5887783
    CGFloat warningLine = [JKPerformanceHelper totalMemoryForDevice] * 0.4;
    
    CGFloat progress = ramUsage / warningLine;
    UIColor *color = [UIColor colorWithHue:0.27 * (1.0 - progress) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d RAM",(int)roundf(ramUsage)]];
    
    [text setAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : _font} range:NSMakeRange(0, text.length - 3)];
    [text setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : _font} range:NSMakeRange(text.length - 3, 3)];
    [text setAttributes:@{NSFontAttributeName : _subFont} range:NSMakeRange(text.length - 4, 1)];
    
    self.attributedText = text;
}


@end
