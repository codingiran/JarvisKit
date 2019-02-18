//
//  JKViewController.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/8.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKViewController.h"
#import "JkPresentationWindow.h"
#import "JKHelper.h"

#define NavigationTitleDefaultColor        [UIColor whiteColor]
#define NavigationTitleDefaultFont         [UIFont systemFontOfSize:19 weight:UIFontWeightBold]
#define NavigationTitleDefaultAttributes   @{NSForegroundColorAttributeName : NavigationTitleDefaultColor, NSFontAttributeName : NavigationTitleDefaultFont}

@interface JKViewController ()

/**
 设置为self.navigationItem.titleView
 */
@property(nonatomic, strong) UILabel *navigationTitleLabel;

/**
 与`firstControllerNeedNavigationCloseItem`属性对应的完成回调
 
 @warning 注意事项与firstControllerNeedNavigationCloseItem属性相同
 */
@property(nonatomic, copy, nullable) void (^dismissCompletion)(void);

/**
 容纳控制器的window
 */
@property(nonatomic, strong) JkPresentationWindow *containerWindow;

/**
 记录上一个的keywindow
 */
@property(nonatomic, weak) UIWindow *previousKeyWindow;

/**
 主App可能修改了状态栏的颜色
 */
@property(nonatomic, strong) UIColor *previousStatuesBarColor;

@end

@implementation JKViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.firstControllerNeedNavigationCloseItem = YES;
        self.navigationTitle = @"";
        self.navigationTitleAttributes = NavigationTitleDefaultAttributes;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.firstControllerNeedNavigationCloseItem && self.jk_isPresented) {
        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:JKImageMake(@"jarvis_navi_close") style:UIBarButtonItemStylePlain target:self action:@selector(navigationDismss:)];
        self.navigationItem.leftBarButtonItems = @[closeItem];
    }
    
    [self jk_initSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 防止主 App中 使用 runtime 修改，在此覆盖
    [self.navigationController.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = self.navigationBarBackgroundColor ? : JKThemeColor;
    // 导航栏主题色和背景
    self.navigationController.navigationBar.tintColor = self.navigationBarTintColor ? : [UIColor whiteColor];
    
    [self jk_setupNavigationItems];
    [self jk_setupToolbarItems];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    if (self.containerWindow) {
        self.containerWindow = nil;
    }
}

#pragma mark - touch event
- (void)navigationDismss:(UIBarButtonItem *)sender
{
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            // 消失回调
            if (self.dismissCompletion) {
                self.dismissCompletion();
                self.dismissCompletion = nil;
            }
            
            [JKHelper jk_setStatusBarColorWith:self.previousStatuesBarColor];
            self.previousStatuesBarColor = nil;
            
            [self.previousKeyWindow makeKeyAndVisible];
            self.containerWindow.hidden = YES;
        }];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            // 消失回调
            if (self.dismissCompletion) {
                self.dismissCompletion();
                self.dismissCompletion = nil;
            }
            
            [JKHelper jk_setStatusBarColorWith:self.previousStatuesBarColor];
            self.previousStatuesBarColor = nil;
            
            [self.previousKeyWindow makeKeyAndVisible];
            self.containerWindow.hidden = YES;
        }];
    }
}

- (void)tapOnTitleView:(UITapGestureRecognizer *)tap
{
    if (self.tapOnTitleLabelComletion) {
        self.tapOnTitleLabelComletion(self.navigationTitleLabel, tap);
    }
}

#pragma mark - public method

- (void)showCompletion:(void (^ __nullable)(void))showCompletion andDimissCompletion:(void (^ __nullable)(void))dismissCompletion
{
    self.dismissCompletion = dismissCompletion;
    
    // 记录上一个keywindow
    self.previousKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 记录上一个状态栏颜色
    self.previousStatuesBarColor = [JKHelper jk_getStatusBarColor];
    [JKHelper jk_setStatusBarColorWith:[UIColor clearColor]];
    
    if (!self.containerWindow) {
        self.containerWindow = [[JkPresentationWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.containerWindow makeKeyAndVisible];
    }
    
    JKNavigtionController *navigationController = [[JKNavigtionController alloc] initWithRootViewController:self];
    
    // 在下一个runloop 执行present
    // https://stackoverflow.com/questions/8563473/unbalanced-calls-to-begin-end-appearance-transitions-for-uitabbarcontroller
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.containerWindow.rootViewController presentViewController:navigationController animated:YES completion:showCompletion];
    });
}

#pragma mark - setter & getter
- (void)setNavigationTitle:(NSString *)navigationTitle
{
    BOOL hasChanged = ![navigationTitle isEqualToString:_navigationTitle];
    if (!hasChanged) return;
    
    _navigationTitle = navigationTitle;
    
    if (self.isViewLoaded) {
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:navigationTitle attributes:NavigationTitleDefaultAttributes];
        [self.navigationTitleLabel setAttributedText:attStr];
        [self.navigationTitleLabel sizeToFit];
    }
    
}

- (void)setNavigationTitleAttributes:(NSDictionary *)navigationTitleAttributes
{
    _navigationTitleAttributes = navigationTitleAttributes;
    
    if (self.isViewLoaded) {
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:self.navigationTitle attributes:navigationTitleAttributes];
        [self.navigationTitleLabel setAttributedText:attStr];
        [self.navigationTitleLabel sizeToFit];
    }
}


@end

@implementation JKViewController (JK_SubclassingHooks)

- (void)jk_initSubviews
{
    // 子类重写
}

- (void)jk_setupNavigationItems
{
    // 添加titleView
    if (!self.navigationTitleLabel) {
        self.navigationTitleLabel = [UILabel new];
        self.navigationTitleLabel.text = self.navigationTitle;
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.navigationTitle ? : @"" attributes:self.navigationTitleAttributes ? : NavigationTitleDefaultAttributes];
        [self.navigationTitleLabel setAttributedText:attrStr];
        [self.navigationTitleLabel sizeToFit];
        self.navigationTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationTitleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTitleView:)];
        [self.navigationTitleLabel addGestureRecognizer:tap];
        self.navigationItem.titleView = self.navigationTitleLabel;
    }
    
    // 子类重写
}

- (void)jk_setupToolbarItems
{
    // 子类重写
}

@end
