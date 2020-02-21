//
//  JKMenuLabel.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/9.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKMenuLabel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, JKMenuActionType) {
    JKMenuActionTypeCopy        = 1 << 0,// 复制
    JKMenuActionTypeShare       = 1 << 1,// 分享
    JKMenuActionTypeFavorite    = 1 << 2,// 收藏
};

@protocol JKMenuLabelActionDelegate <NSObject>

@optional;

/**
 默认菜单(复制、分享、收藏)完成选择代理回调

 @param label 菜单按钮
 @param menuActionType 默认支持的JKMenuActionType
 */
- (void)menuLabel:(JKMenuLabel *)label actionDidFinish:(JKMenuActionType)menuActionType;

@end

/**
 长摁弹出菜单的Label，样式参考微信朋友圈文字长摁效果
 
 使用系统的UIMenuController实现，使用时用`canPerformMenuAction`属性开启
 
 默认提供复制、分享、收藏三种菜单，如需要更多请使用`addMenuWithActionTitle:andActionCompletion:`方法添加
 */
@interface JKMenuLabel : UILabel

/**
 是否支持menu
 */
@property(nonatomic, assign) BOOL canPerformMenuAction;

/**
 需要支持的menuaction类型，默认提供三种类型: 复制、分享、收藏
 
 如需要更多请使用`addMenuWithActionTitle:andActionCompletion:`
 */
@property(nonatomic, assign) JKMenuActionType menuActionType;

/**
 按钮highlight状态的背景色
 
 默认为RGB(238.0, 239.0, 241.0)
 */
@property(nonatomic, strong) UIColor *highlightedBackgroundColor;

/**
 默认菜单action的完成回调
 
 与代理方法`menuLabel:actionDidFinish:`对应
 */
@property(nonatomic, copy) void (^menuActionCompletion)(JKMenuLabel *label, JKMenuActionType menuActionType);

/**
 默认菜单的代理
 
 @warning:更多菜单的选择回调直接通过`addMenuWithActionTitle:andActionCompletion`的block获得
 */
@property(nonatomic, weak) id<JKMenuLabelActionDelegate> delegate;

/**
 添加menu action
 @warning 如果JKMenuActionType提供的选项无法满足需求，可以使用这个方法新增

 @param actionTitle action的文字
 @param completion 点击完成回调
 */
- (void)addMenuWithActionTitle:(NSString *)actionTitle
           andActionCompletion:(void (^ __nullable)(JKMenuLabel *label, NSString *actionTitle))completion;

@end

NS_ASSUME_NONNULL_END
