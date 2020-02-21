//
//  JKMenuLabel.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/9.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKMenuLabel.h"
#import <objc/runtime.h>
#import "NSString+JarvisKit.h"

@interface JKMenuLabel ()

/// hightlight之前的背景色
@property(nonatomic, strong) UIColor *originalBackGroundColor;

@property(nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property(nonatomic, strong) NSMutableArray *moreMenuActionTitles;

/// 添加锁，确保`addMenuWithActionTitle:andActionCompletion`线程安全
@property(nonatomic, strong) dispatch_semaphore_t addMenuActionLock;

@end

@implementation JKMenuLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.addMenuActionLock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public method
- (void)addMenuWithActionTitle:(NSString *)actionTitle andActionCompletion:(void (^ __nullable)(JKMenuLabel *label, NSString *actionTitle))completion
{
    if (!actionTitle || !actionTitle.length) return;
    
    // 用信号量确保这个方法线程安全
    dispatch_semaphore_wait(_addMenuActionLock, DISPATCH_TIME_FOREVER);
    
    // 动态添加方法
    SEL actionSEL = NSSelectorFromString(actionTitle);// 将 actionTitle 作为方法名以保证唯一性
    IMP actionIMP = imp_implementationWithBlock(^(id selfObject) {
        if (completion) {
            completion(selfObject, actionTitle.copy);
        }
    });
    BOOL addedSuccessfully = class_addMethod([self class], actionSEL, actionIMP, "v@:");
    if (!addedSuccessfully) {
        // 如果添加失败说明本来就有这个方法，需要用新的方法替换旧的
        class_replaceMethod([self class], actionSEL, actionIMP, "v@:");
    }
    
    if (!self.moreMenuActionTitles) {
        self.moreMenuActionTitles = [NSMutableArray array];
    }
    [self.moreMenuActionTitles addObject:actionTitle];
    
    dispatch_semaphore_signal(_addMenuActionLock);
}

#pragma mark - 长按复制功能

- (void)setCanPerformMenuAction:(BOOL)canPerformMenuAction
{
    _canPerformMenuAction = canPerformMenuAction;
    if (_canPerformMenuAction && !self.longPress) {
        self.userInteractionEnabled = YES;
        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
        [self addGestureRecognizer:self.longPress];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuWillHideNotification:) name:UIMenuControllerWillHideMenuNotification object:nil];
        
        if (!self.highlightedBackgroundColor) {
            // 默认值高亮背景色
            self.highlightedBackgroundColor = [UIColor colorWithRed:238.0 / 255.0 green:239.0 / 255.0 blue:241.0 / 255.0 alpha:1.0];

        }
    } else if (!_canPerformMenuAction && self.longPress) {
        [self removeGestureRecognizer:self.longPress];
        self.longPress = nil;
        self.userInteractionEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return self.canPerformMenuAction;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([self canBecomeFirstResponder]) {
        return action == @selector(copyString:) || action == @selector(shareString:) || action == @selector(favoriteString:) || [self.moreMenuActionTitles containsObject:NSStringFromSelector(action)];
    }
    return NO;
}

- (void)copyString:(id)sender
{
    BOOL shouldShowCopyMenu = (self.menuActionType & JKMenuActionTypeCopy) == JKMenuActionTypeCopy;
    if (self.canPerformMenuAction && shouldShowCopyMenu) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *stringToCopy = self.text;
        if (stringToCopy) {
            pasteboard.string = stringToCopy;
            if (self.menuActionCompletion) {
                self.menuActionCompletion(self, JKMenuActionTypeCopy);
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(menuLabel:actionDidFinish:)]) {
                [self.delegate menuLabel:self actionDidFinish:JKMenuActionTypeCopy];
            }
        }
    }
}

- (void)shareString:(id)sender
{
    BOOL shouldShowShareMunu = (self.menuActionType & JKMenuActionTypeShare) == JKMenuActionTypeShare;
    if (self.canPerformMenuAction && shouldShowShareMunu) {
        if (self.menuActionCompletion) {
            self.menuActionCompletion(self, JKMenuActionTypeShare);
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(menuLabel:actionDidFinish:)]) {
            [self.delegate menuLabel:self actionDidFinish:JKMenuActionTypeShare];
        }
    }
}

- (void)favoriteString:(id)sender
{
    BOOL shouldShowFavoriteMunu = (self.menuActionType & JKMenuActionTypeFavorite) == JKMenuActionTypeFavorite;
    if (self.canPerformMenuAction && shouldShowFavoriteMunu) {
        if (self.menuActionCompletion) {
            self.menuActionCompletion(self, JKMenuActionTypeFavorite);
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(menuLabel:actionDidFinish:)]) {
            [self.delegate menuLabel:self actionDidFinish:JKMenuActionTypeFavorite];
        }
    }
}

- (void)handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.canPerformMenuAction) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        
        // 默认菜单
        BOOL shouldShowCopyMenu = (self.menuActionType & JKMenuActionTypeCopy) == JKMenuActionTypeCopy;
        BOOL shouldShowShareMunu = (self.menuActionType & JKMenuActionTypeShare) == JKMenuActionTypeShare;
        BOOL shouldShowFavoriteMunu = (self.menuActionType & JKMenuActionTypeFavorite) == JKMenuActionTypeFavorite;
        
        NSMutableArray<UIMenuItem *> *menuItems = [NSMutableArray arrayWithCapacity:3 + self.moreMenuActionTitles.count];
        if (shouldShowCopyMenu) {
            UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyString:)];
            [menuItems addObject:copyMenuItem];
        }
        if (shouldShowShareMunu) {
            UIMenuItem *shareMenuItem = [[UIMenuItem alloc] initWithTitle:@"分享" action:@selector(shareString:)];
            [menuItems addObject:shareMenuItem];
        }
        if (shouldShowFavoriteMunu) {
            UIMenuItem *favoriteMenuItem = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(favoriteString:)];
            [menuItems addObject:favoriteMenuItem];
        }
        
        // 更多菜单
        if (self.moreMenuActionTitles.count) {
            [self.moreMenuActionTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIMenuItem *moreMenuItem = [[UIMenuItem alloc] initWithTitle:obj action:NSSelectorFromString(obj)];
                [menuItems addObject:moreMenuItem];
            }];
        }
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [[UIMenuController sharedMenuController] setMenuItems:menuItems.copy];
        [menuController setTargetRect:self.frame inView:self.superview];
        [menuController setMenuVisible:YES animated:YES];
        
        [self setHighlighted:YES];
    } else if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
        [self setHighlighted:NO];
    }
}

- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    if (!self.canPerformMenuAction) {
        return;
    }
    
    [self setHighlighted:NO];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor
{
    _highlightedBackgroundColor = highlightedBackgroundColor;
    if (highlightedBackgroundColor) {
        self.originalBackGroundColor = self.backgroundColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (self.highlightedBackgroundColor) {
        self.backgroundColor = highlighted ? self.highlightedBackgroundColor : self.originalBackGroundColor;
    }
}

@end

