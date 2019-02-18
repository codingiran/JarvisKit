//
//  UIViewController+JarvisKit.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/8.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (JarvisKit)

/**
 获取当前controller里的最高层可见viewController（可见的意思是还会判断self.view.window是否存在）
 
 @see 如果要获取当前App里的可见viewController，请使用 [JKDHelper visibleViewController]
 @return 当前controller里的最高层可见viewController
 */
- (nullable UIViewController *)jk_visibleViewControllerIfExist;

/**
 是否应该响应一些UI相关的通知，例如 UIKeyboardNotification、UIMenuControllerNotification等，因为有可能当前界面已经被切走了（push到其他界面），但仍可能收到通知，所以在响应通知之前都应该做一下这个判断
 */
- (BOOL)jk_isViewLoadedAndVisible;

/**
 获取和自身处于同一个UINavigationController里的上一个UIViewController
 */
@property(nullable, nonatomic, weak, readonly) UIViewController *jk_previousViewController;

/**
 当前 viewController 是否是被以 present 的方式显示的，是则返回 YES，否则返回 NO
 
 @warning 利用这个属性，可以方便地给 navigationController 的第一个界面的左上角添加关闭按钮。
 */
- (BOOL)jk_isPresented;

/**
 NavigationBar 在 self.view 坐标系里的 MaxY
 
 @warning 建议在 viewDidLayoutSubviews、viewWillAppear: 里使用，确保拿到正确的Frame
 @warning 如果不存在 UINavigationBar或被隐藏，则返回 0
 */
@property(nonatomic, assign, readonly) CGFloat jk_navigationBarMaxYInSelfViewCoordinator;

/**
 NavigationController的自带Toolbar 在 self.view 坐标系里的高度
 
 @warning 建议在 viewDidLayoutSubviews、viewWillAppear: 里使用，确保拿到正确的Frame
 @warning 如果不存在 UIToolbar或被隐藏，则返回 0
 */
@property(nonatomic, assign, readonly) CGFloat jk_toolbarHeightInSelfViewCoordinator;

/**
 TabBar 在 self.view 坐标系里的高度
 
 @warning 建议在 viewDidLayoutSubviews、viewWillAppear: 里使用，确保拿到正确的Frame
 @warning 如果不存在 UITabBar或被隐藏，则返回 0
 */
@property(nonatomic, assign, readonly) CGFloat jk_tabBarHeightInSelfViewCoordinator;

@end

NS_ASSUME_NONNULL_END
