//
//  JKUserDefaultsKeyView.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/4.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKUserDefaultsKeyView : UITableViewHeaderFooterView

@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property(nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@end

NS_ASSUME_NONNULL_END
