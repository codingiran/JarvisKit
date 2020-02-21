//
//  JKFPSLabel.m
//  WekidsEducation
//
//  Created by CodingIran on 2018/12/25.
//  Copyright © 2018 wekids. All rights reserved.
//

#import "JKFPSLabel.h"
#import "JKHelper.h"

@implementation JKFPSLabel
{
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
    NSTimeInterval _llll;
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
        
        __weak typeof(self) weakSelf = self;
        _link = [CADisplayLink displayLinkWithTarget:weakSelf selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

#pragma mark - public method

+ (instancetype)fpsLabel
{
    JKFPSLabel *label = [[JKFPSLabel alloc] initWithFrame:JKPFSLabelFrame];
    return label;
}

- (void)dealloc
{
    [_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return JKPerformanceLabelSize;
}

- (void)tick:(CADisplayLink *)link
{
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    
    [text setAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : _font} range:NSMakeRange(0, text.length - 3)];
    [text setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : _font} range:NSMakeRange(text.length - 3, 3)];
    [text setAttributes:@{NSFontAttributeName : _subFont} range:NSMakeRange(text.length - 4, 1)];
    
    self.attributedText = text;
    
}

@end

