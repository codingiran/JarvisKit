//
//  JKNetCaptureDetailViewController.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/18.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKTableViewController.h"
@class JKNetCaptureModel;

NS_ASSUME_NONNULL_BEGIN

@interface JKNetCaptureDetailViewController : JKTableViewController

/**
 初始化方法

 @param model 从JKNetCaptureListViewController传来点击的模型
 @return 实例对象
 */
- (instancetype)initWithNetCaptureModel:(JKNetCaptureModel *)model;

@end

NS_ASSUME_NONNULL_END
