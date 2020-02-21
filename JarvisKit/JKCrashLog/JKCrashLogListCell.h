//
//  JKCrashLogListCell.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/15.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCrashLogModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKCrashLogListCell : UITableViewCell

@property(nonatomic, strong) JKCrashLogModel *crashLogModel;

@end

NS_ASSUME_NONNULL_END
