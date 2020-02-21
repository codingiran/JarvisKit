//
//  UIViewController+JarvisKit.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/8.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "UIViewController+JarvisKit.h"
#import "JKHelper.h"

@implementation UIViewController (JarvisKit)

- (UIViewController *)jk_visibleViewControllerIfExist
{
    if (self.presentedViewController) {
        return [self.presentedViewController jk_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).visibleViewController jk_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController jk_visibleViewControllerIfExist];
    }
    
    if ([self jk_isViewLoadedAndVisible]) {
        return self;
    } else {
        return nil;
    }
}

- (BOOL)jk_isViewLoadedAndVisible
{
    return self.isViewLoaded && self.view.window;
}


- (UIViewController *)jk_previousViewController
{
    if (self.navigationController.viewControllers && self.navigationController.viewControllers.count > 1 && self.navigationController.topViewController == self) {
        NSUInteger count = self.navigationController.viewControllers.count;
        return (UIViewController *)[self.navigationController.viewControllers objectAtIndex:count - 2];
    }
    return nil;
}

- (BOOL)jk_isPresented
{
    UIViewController *viewController = self;
    if (self.navigationController) {
        if (self.navigationController.viewControllers.firstObject != self) {
            return NO;
        }
        viewController = self.navigationController;
    }
    BOOL result = viewController.presentingViewController.presentedViewController == viewController;
    return result;
}

- (CGFloat)jk_navigationBarMaxYInSelfViewCoordinator
{
    if (!self.isViewLoaded) {
        return 0;
    }
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    if (!self.navigationController.navigationBar || self.navigationController.navigationBarHidden) {
        return 0;
    }
    
    CGRect navigationBarFrameInView = [self.view convertRect:navigationBar.frame fromView:navigationBar.superview];
    CGRect navigationBarFrame = CGRectIntersection(self.view.bounds, navigationBarFrameInView);
    
    // 两个 rect 如果不存在交集，CGRectIntersection 计算结果可能为非法的 rect
    if (!JKCGRectIsValidated(navigationBarFrame)) {
        return 0;
    }
    
    CGFloat result = CGRectGetMaxY(navigationBarFrame);
    return result;
}

- (CGFloat)jk_toolbarHeightInSelfViewCoordinator
{
    if (!self.isViewLoaded) {
        return 0;
    }
    if (!self.navigationController.toolbar || self.navigationController.toolbarHidden) {
        return 0;
    }
    CGRect toolbarFrame = CGRectIntersection(self.view.bounds, [self.view convertRect:self.navigationController.toolbar.frame fromView:self.navigationController.toolbar.superview]);
    
    // 两个 rect 如果不存在交集，CGRectIntersection 计算结果可能为非法的 rect
    if (!JKCGRectIsValidated(toolbarFrame)) {
        return 0;
    }
    
    CGFloat result = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(toolbarFrame);
    return result;
}

- (CGFloat)jk_tabBarHeightInSelfViewCoordinator
{
    if (!self.isViewLoaded) {
        return 0;
    }
    if (!self.tabBarController.tabBar || self.tabBarController.tabBar.hidden) {
        return 0;
    }
    CGRect tabBarFrame = CGRectIntersection(self.view.bounds, [self.view convertRect:self.tabBarController.tabBar.frame fromView:self.tabBarController.tabBar.superview]);
    
    // 两个 rect 如果不存在交集，CGRectIntersection 计算结果可能为非法的 rect
    if (!JKCGRectIsValidated(tabBarFrame)) {
        return 0;
    }
    
    CGFloat result = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(tabBarFrame);
    return result;
}

@end
