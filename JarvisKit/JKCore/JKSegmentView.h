//
//  JKSegmentView.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/18.
//  Copyright © 2019 wekids. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JKSegmentViewDelegate <NSObject>

@required;
- (void)segmentDidSelecteIndex:(NSInteger)index;

@end

@interface JKSegmentView : UIView

/// block回调，调用时注意做weakSelf保护
@property(nonatomic, copy) void (^segmentSelectedIndex)(NSInteger idx);

@property(nonatomic, weak) id<JKSegmentViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
