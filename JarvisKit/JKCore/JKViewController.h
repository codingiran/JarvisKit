//
//  JKViewController.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/8.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKViewController : UIViewController

/**
 导航栏第一个控制器是否需要关闭按钮『x』，默认为YES
 
 @warning 只有一个导航栏的第一个控制器设置这个属性才有效，即：self.navigationController.viewController[0]，之后push出来的控制器默认为系统的返回item
 */
@property(nonatomic, assign) BOOL firstControllerNeedNavigationCloseItem;

/**
 导航栏背景色，默认为主题色
 */
@property(nonatomic, strong) UIColor *navigationBarBackgroundColor;

/**
 == self.navigationController.navigationBar.tintColor
 */
@property(nonatomic, strong) UIColor *navigationBarTintColor;

/**
 导航栏标题 == navigationTitleLabel.text
 
 @warning 导航栏应该放在jk_setupNavigationItems内进行设置
 */
@property(nonatomic, copy) NSString *navigationTitle;

/**
 导航栏标题的富文本属性
 */
@property(nonatomic, copy) NSDictionary *navigationTitleAttributes;

/**
 `navigationTitleLabel`的点击回调
 */
@property(nonatomic, copy) void (^tapOnTitleLabelComletion)(UILabel *titleLabel, UIGestureRecognizer *tap);

/**
 与`firstControllerNeedNavigationCloseItem`属性对应的完成回调
 
 @warning 注意事项与firstControllerNeedNavigationCloseItem属性相同
 */
@property(nonatomic, copy, readonly, nullable) void (^dismissCompletion)(void);


/**
 show方法

 @param showCompletion 出现完成回调
 @param dismissCompletion 消失完成回调
 */
- (void)showCompletion:(void (^ __nullable)(void))showCompletion andDimissCompletion:(void (^ __nullable)(void))dismissCompletion;


/**
 导航栏关闭按钮的事件

 @warning 与firstControllerNeedNavigationCloseItem属性对应
 */
- (void)navigationDismss:(UIBarButtonItem *)sender NS_REQUIRES_SUPER;

@end


@interface JKViewController (JK_SubclassingHooks)

/**
 负责初始化和设置controller里面的view，也就是self.view的subView。目的在于分类代码，所以与view初始化的相关代码都写在这里。

 @warning jk_initSubviews只负责subviews的初始化，布局相关的代码应该写在 viewDidLayoutSubviews:
 */
- (void)jk_initSubviews NS_REQUIRES_SUPER;

/**
 负责设置和更新navigationItem，包括title、leftBarButtonItem、rightBarButtonItem。viewWillAppear 里面会自动调用，业务也可以在需要的时候自行调用
 */
- (void)jk_setupNavigationItems NS_REQUIRES_SUPER;

/**
 负责设置和更新toolbarItem。在viewWillAppear里面自动调用（因为toolbar是navigationController的，是每个界面公用的，所以必须在每个界面的viewWillAppear时更新，不能放在viewDidLoad里）
 */
- (void)jk_setupToolbarItems NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
