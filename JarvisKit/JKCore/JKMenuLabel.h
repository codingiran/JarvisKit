//
//  JKMenuLabel.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/9.
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
- (void)menuLabel:(JKMenuLabel *)label actionDidFinish:(JKMenuActionType)menuActionType;

@end

@interface JKMenuLabel : UILabel

/// 是否支持menu
@property(nonatomic, assign) BOOL canPerformMenuAction;

/// 需要支持的menuaction类型
@property(nonatomic, assign) JKMenuActionType menuActionType;

/// highlight状态的背景色
@property(nonatomic, strong) UIColor *highlightedBackgroundColor;

/// action的完成回调
@property(nonatomic, copy) void (^menuActionCompletion)(JKMenuLabel *label, JKMenuActionType menuActionType);

@property(nonatomic, weak) id<JKMenuLabelActionDelegate> delegate;


/**
 添加menu action
 @warning 如果JKMenuActionType提供的选项无法满足需求，可以使用这个方法新增

 @param actionTitle action的文字
 @param completion 点击完成回调
 */
- (void)addMenuWithActionTitle:(NSString *)actionTitle andActionCompletion:(void (^ __nullable)(JKMenuLabel *label, NSString *actionTitle))completion;

@end

NS_ASSUME_NONNULL_END
