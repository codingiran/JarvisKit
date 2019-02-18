//
//  JKCrashLogDetailViewController.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/15.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKViewController.h"
@class JKCrashLogModel;

NS_ASSUME_NONNULL_BEGIN

@interface JKCrashLogDetailViewController : JKViewController

- (instancetype)initWithCrashLogModel:(JKCrashLogModel *)model;

@end

NS_ASSUME_NONNULL_END
