//
//  JKIronmanWindow.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/12.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKIronmanWindow.h"
#import "JKHelper.h"

/// https://stackoverflow.com/questions/31406820/uialertcontrollersupportedinterfaceorientations-was-invoked-recursively
@interface UIAlertController (supportedInterfaceOrientations)

@end

@interface JKIronmanWindow ()

@property(nonatomic, strong) UIButton *ironmanBtn;
@property(nonatomic, weak) UIAlertController *alertController;
@property(nonatomic, strong) JKOrderedDictionary *toolsList;

@end

@implementation JKIronmanWindow

- (JKOrderedDictionary *)toolsList
{
    if (!_toolsList) {
        _toolsList = [[JKOrderedDictionary alloc] initWithKeysAndObjects:
                      @"JKDeviceInfoViewController", @"App与设备信息",
                      @"JKPerformanceSettingController", @"性能检测工具",
                      @"JKSandboxViewController", @"沙盒文件浏览器",
                      @"JKUserDefaultsViewController", @"NSUserDefaults管理器",
                      @"JKNetCaptureListViewController", @"网络抓包工具",
                      @"JKCrashLogListViewController", @"奔溃日志收集",
                      @"JKSystemFontViewController", @"系统字体浏览器",
                      @"JKUIElementToolSettingController", @"UI调试工具",
                      nil
                      ];
    }
    return _toolsList;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat ratio = (frame.size.width / 414.0f);
        CGFloat width = ratio * 35;
        CGFloat height = width * (60.0 / 35.0);
        self.frame = CGRectMake(20 * ratio, frame.size.height * 0.8, width, height);
        
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = JKIronmanWindowLevel;
        if (!self.rootViewController) {
            self.rootViewController = [[UIViewController alloc] init];
        }
        
        // init subviews
        self.ironmanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.ironmanBtn.frame = self.bounds;
        [self.ironmanBtn addTarget:self action:@selector(punchIronman:) forControlEvents:UIControlEventTouchUpInside];
        [self.ironmanBtn setImage:JKImageMake(@"jarvis_ironman_normal") forState:UIControlStateNormal];
        [self.ironmanBtn setImage:JKImageMake(@"jarvis_ironman_highlight") forState:UIControlStateHighlighted];
        
        [self.rootViewController.view addSubview:self.ironmanBtn];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

#pragma mark - touch event
- (void)punchIronman:(UIButton *)sender
{
    if ([JKHelper jk_visibleViewController] == self.alertController) {
        [self.alertController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        // 创建alertcontroller
        UIAlertController *toolAlertController = [UIAlertController alertControllerWithTitle:@"选择Debug工具" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
        [toolAlertController addAction:cancelAction];
        __weak __typeof(self)weakSelf = self;
        [self.toolsList.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *className = (NSString *)obj;
            if (className && className.length) {
                NSString *actionTitle = [self.toolsList objectForKey:obj];
                UIAlertAction *toolAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (![NSStringFromClass([[JKHelper jk_visibleViewController] class]) isEqualToString:className]) {// 如果已经打开了就不需要再次打开
                        Class class = NSClassFromString(className);
                        __kindof JKViewController *toolVc = [[class alloc] init];
                        NSAssert(!!toolVc, @"JkError: 初始化工具controller失败");
                        [toolVc showCompletion:^{
                            if (!weakSelf.hidden) {
                                weakSelf.userInteractionEnabled = NO;
                                [UIView animateWithDuration:0.15 animations:^{
                                    weakSelf.alpha = 0;
                                } completion:^(BOOL finished) {
                                    weakSelf.hidden = YES;
                                    weakSelf.userInteractionEnabled = YES;
                                }];
                            }
                        } andDimissCompletion:^{
                            if (weakSelf.hidden) {
                                weakSelf.hidden = NO;
                                weakSelf.userInteractionEnabled = NO;
                                [UIView animateWithDuration:0.15 animations:^{
                                    weakSelf.alpha = 1;
                                } completion:^(BOOL finished) {
                                    weakSelf.userInteractionEnabled = YES;
                                }];
                            }
                        }];
                    }
                }];
                [toolAlertController addAction:toolAction];
            }
        }];
        self.alertController = toolAlertController;
        [[JKHelper jk_visibleViewController] presentViewController:self.alertController animated:YES completion:NULL];
    }
}

- (void)pan:(UIPanGestureRecognizer *)tap
{
    // 移动
    CGPoint transP = [tap translationInView:self];
    UIView *tapView = tap.view;
    CGAffineTransform transform = tapView.transform;
//    transform = CGAffineTransformRotate(transform, 0.3);
    transform = CGAffineTransformTranslate(transform, transP.x, transP.y);
    tapView.transform = transform;
    
    // 复位
    [tap setTranslation:CGPointZero inView:self];
    
    if (tap.state == UIGestureRecognizerStateBegan) {
        [self.ironmanBtn setImage:JKImageMake(@"jarvis_ironman_fly") forState:UIControlStateNormal];
    } else if (tap.state == UIGestureRecognizerStateEnded || tap.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.2 animations:^{
            tapView.jk_left = (tapView.jk_left - JK_SCREEN_WIDTH / 2) > 0 ? (JK_SCREEN_WIDTH - self.jk_width - 20) : 20;
            tapView.jk_top = tapView.jk_top > 80 ? tapView.jk_top : 80;
        } completion:^(BOOL finished) {
            [self.ironmanBtn setImage:JKImageMake(@"jarvis_ironman_normal") forState:UIControlStateNormal];
        }];
    }
}

#pragma mark - private method
- (void)becomeKeyWindow
{
    // 把keywindow交还
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    if (appWindow != self) {
        [appWindow makeKeyWindow];
    }
}

@end


@implementation UIAlertController (supportedInterfaceOrientations)

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
