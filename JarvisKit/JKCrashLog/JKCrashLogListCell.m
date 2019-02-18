//
//  JKCrashLogListCell.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/15.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKCrashLogListCell.h"

@interface JKCrashLogListCell ()

@property(nonatomic, strong) UILabel *timeLabel;

@end

@implementation JKCrashLogListCell

#pragma mark - setter & getter

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.timeLabel sizeToFit];
    self.timeLabel.jk_centerY = self.textLabel.jk_centerY;
    self.timeLabel.jk_right = self.contentView.jk_right;
}

- (void)setCrashLogModel:(JKCrashLogModel *)crashLogModel
{
    _crashLogModel = crashLogModel;
    
    // 创建图片图片附件
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    if (crashLogModel.crashExceptionType == JKCrashExceptionTypeUncaughtException) {
        attach.image = JKImageMake(@"jarvis_crashlog_uncaught");
    } else if (crashLogModel.crashExceptionType == JKCrashExceptionTypeUnixSignal) {
        attach.image = JKImageMake(@"jarvis_crashlog_signal");
    }
    attach.bounds = CGRectMake(0, -1, 30, 15);
    NSMutableAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach].mutableCopy;

    NSAttributedString *attrstr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", crashLogModel.crashName] attributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor], NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    [attachString appendAttributedString:attrstr];
    [self.textLabel setAttributedText:attachString];
    
    self.detailTextLabel.text = crashLogModel.crashBrief;
    self.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    self.timeLabel.text = crashLogModel.crashTimeString;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = JKFontMake(14);
        _timeLabel.textColor = JKColorMake(130, 130, 130);
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

@end
