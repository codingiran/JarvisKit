//
//  WEUserDefaultsValueCell.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/4.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKUserDefaultsModel;

NS_ASSUME_NONNULL_BEGIN

@interface JKUserDefaultsValueCell : UITableViewCell

@property(nonatomic, strong) JKUserDefaultsModel *userDefaultsModel;

@end

NS_ASSUME_NONNULL_END
