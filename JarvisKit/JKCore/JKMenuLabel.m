//
//  JKMenuLabel.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/9.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKMenuLabel.h"
#import "JKHelper.h"
#import <objc/runtime.h>

@interface JKMenuLabel ()

@property(nonatomic, strong) UIColor *originalBackGroundColor;

@property(nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property(nonatomic, copy) void (^moreMenuCompletion)(void);

@property(nonatomic, strong) NSMutableArray<NSString *> *moreMenuTitles;
@property(nonatomic, strong) NSMutableArray *moreMenuBlocks;

@end

@implementation JKMenuLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.moreMenuTitles = [NSMutableArray array];
        self.moreMenuBlocks = [NSMutableArray array];
    }
    return self;
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

#pragma mark - public method
- (void)addMenuWithActionTitle:(NSString *)actionTitle andActionCompletion:(void (^ __nullable)(JKMenuLabel *label, NSString *actionTitle))completion
{
    https://stackoverflow.com/questions/33991067/collection-element-of-type-sel-is-not-an-objective-c-object
    [self.moreMenuTitles addObject:actionTitle];
    [self.moreMenuBlocks addObject:completion];
    
    SEL actionSEL = NSSelectorFromString(actionTitle);
    IMP actionIMP = imp_implementationWithBlock(completion);
    class_addMethod([self class], actionSEL, actionIMP, "i@:ii");
    
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
            self.highlightedBackgroundColor = JKColorMake(238.0, 239.0, 241.0);// 默认值高亮背景色
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
//    NSLog(@"%@", NSStringFromSelector(action));
    if ([self canBecomeFirstResponder]) {
        return action == @selector(copyString:) || action == @selector(shareString:) || action == @selector(favoriteString:);
        return YES;
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

- (void)moreMenuAction:(id)sender
{
    if (!self.canPerformMenuAction) return;
    
    UIMenuController *menuController = (UIMenuController *)sender;
    __block UIMenuItem *menuItem = nil;
    [menuController.menuItems enumerateObjectsUsingBlock:^(UIMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%@", NSStringFromSelector(obj.action));
        if ([NSStringFromSelector(obj.action) isEqualToString:@"moreMenuAction:"]) {
            menuItem = obj;
        }
    }];
    
    if (menuItem) {
        NSString *title = menuItem.title;
        NSInteger idx = [self.moreMenuTitles indexOfObject:title];
        void (^completion)(JKMenuLabel *label, NSString *actionTitle) = self.moreMenuBlocks[idx];
        completion(self, title);
        completion = nil;
    }
}


- (void)handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.canPerformMenuAction) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        
        BOOL shouldShowCopyMenu = (self.menuActionType & JKMenuActionTypeCopy) == JKMenuActionTypeCopy;
        BOOL shouldShowShareMunu = (self.menuActionType & JKMenuActionTypeShare) == JKMenuActionTypeShare;
        BOOL shouldShowFavoriteMunu = (self.menuActionType & JKMenuActionTypeFavorite) == JKMenuActionTypeFavorite;
        
        NSAssert(shouldShowCopyMenu || shouldShowShareMunu || shouldShowFavoriteMunu, @"JKError: 如果设置了canPerformMenuAction，那至少从『复制』『分享』『收藏』中选择一个");
        
        NSMutableArray<UIMenuItem *> *menuItems = [NSMutableArray arrayWithCapacity:2];
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
        
        if (self.moreMenuTitles.count) {
            [self.moreMenuTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIMenuItem *moreMenuItem = [[UIMenuItem alloc] initWithTitle:obj action:@selector(moreMenuAction:)];
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

@end

