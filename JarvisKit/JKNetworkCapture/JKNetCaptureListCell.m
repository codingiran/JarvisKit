//
//  JKNetCaptureListCell.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/16.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKNetCaptureListCell.h"
#import "JKNetCaptureModel.h"

@interface JKNetCaptureListCell ()

/// 请求链接
@property(nonatomic, strong) UILabel *urlLabel;
/// 请求方式, 如: GET POST
@property(nonatomic, strong) UILabel *methodLabel;
/// 请求的状态码，如: 200 404
@property (nonatomic, strong) UILabel *statusLabel;
/// 请求开始时间
@property (nonatomic, strong) UILabel *startTimeLabel;
/// 请求耗时
@property (nonatomic, strong) UILabel *durantionLabel;
/// 请求消耗的流量
@property (nonatomic, strong) UILabel *flowLabel;


@end

@implementation JKNetCaptureListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.urlLabel = [UILabel new];
        self.urlLabel.textColor = JKThemeColor;
        self.urlLabel.font = JKNetCaptureListCellTextFont;
        self.urlLabel.numberOfLines = 0;
        self.urlLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.urlLabel];
        
        self.methodLabel = [UILabel new];
        self.methodLabel.textColor = [UIColor whiteColor];
        self.methodLabel.backgroundColor = JKColorMake(220, 100, 20);
        self.methodLabel.font = JKNetCaptureListCellTextFont;
        self.methodLabel.numberOfLines = 1;
        self.methodLabel.layer.cornerRadius = 3;
        self.methodLabel.layer.masksToBounds = YES;
        self.methodLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.methodLabel];
        
        self.statusLabel = [UILabel new];
        self.statusLabel.layer.borderWidth = 0.5;
        self.statusLabel.layer.cornerRadius = 3;
        self.statusLabel.layer.masksToBounds = YES;
        self.statusLabel.font = JKNetCaptureListCellTextFont;
        self.statusLabel.numberOfLines = 1;
        self.statusLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.statusLabel];
        
        self.startTimeLabel = [UILabel new];
        self.startTimeLabel.textColor = [UIColor darkTextColor];
        self.startTimeLabel.font = JKNetCaptureListCellTextFont;
        self.startTimeLabel.numberOfLines = 1;
        self.startTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.startTimeLabel];
        
        self.durantionLabel = [UILabel new];
        self.durantionLabel.textColor = [UIColor darkTextColor];
        self.durantionLabel.font = JKNetCaptureListCellTextFont;
        self.durantionLabel.numberOfLines = 1;
        self.durantionLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.durantionLabel];
        
        self.flowLabel = [UILabel new];
        self.flowLabel.textColor = [UIColor darkTextColor];
        self.flowLabel.font = JKNetCaptureListCellTextFont;
        self.flowLabel.numberOfLines = 1;
        self.flowLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.flowLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
     
    CGSize urlSize = [self.urlLabel sizeThatFits:CGSizeMake(JK_SCREEN_WIDTH - 10 - kLeftMargin - kRightMargin, MAXFLOAT)];
    self.urlLabel.frame = CGRectMake(kLeftMargin, kTopBottomMargin, urlSize.width, urlSize.height);
    
    [self.methodLabel sizeToFit];
    self.methodLabel.jk_left = self.urlLabel.jk_left;
    self.methodLabel.jk_top = self.urlLabel.jk_bottom + kLineMargin;
    
    [self.statusLabel sizeToFit];
    self.statusLabel.jk_left = self.methodLabel.jk_right + kBetweenMargin;
    self.statusLabel.jk_centerY = self.methodLabel.jk_centerY;
    
    [self.startTimeLabel sizeToFit];
    self.startTimeLabel.jk_left = self.methodLabel.jk_left;
    self.startTimeLabel.jk_top = self.methodLabel.jk_bottom + kLineMargin;
    
    [self.durantionLabel sizeToFit];
    self.durantionLabel.jk_left = self.startTimeLabel.jk_right + kBetweenMargin;
    self.durantionLabel.jk_centerY = self.startTimeLabel.jk_centerY;
    
    [self.flowLabel sizeToFit];
    self.flowLabel.jk_left = self.startTimeLabel.jk_left;
    self.flowLabel.jk_top = self.startTimeLabel.jk_bottom + kLineMargin;
}


#pragma mark - setter & getter
- (void)setNetCaptureModel:(JKNetCaptureModel *)netCaptureModel
{
    _netCaptureModel = netCaptureModel;
    
    self.urlLabel.text = netCaptureModel.url;
    if (netCaptureModel.mineType.length) {
        self.methodLabel.text = [NSString stringWithFormat:@" %@ > %@ ", netCaptureModel.method, netCaptureModel.mineType];
    } else {
        self.methodLabel.text = JKWhitespaceString(netCaptureModel.method);
    }
    
    self.statusLabel.text = JKWhitespaceString(netCaptureModel.statusCode);
    if ([netCaptureModel.statusCode isEqualToString:@"200"]) {
        self.statusLabel.textColor = JKColorMake(66, 147, 62);
        self.statusLabel.layer.borderColor = JKColorMake(66, 147, 62).CGColor;
    } else {
        self.statusLabel.textColor = [UIColor redColor];
        self.statusLabel.layer.borderColor = [UIColor redColor].CGColor;
    }
    
    self.startTimeLabel.text = [NSString stringWithFormat:@"开始: %@", [JKNetCaptureHelper jk_getDateFromTimeInterval:netCaptureModel.startTime]];
    self.durantionLabel.text = [NSString stringWithFormat:@"| 耗时: %@s", netCaptureModel.totalDuration];
    NSString *uploadFlow = [JKHelper jk_getFormatUnitFromByte:[netCaptureModel.uploadFlow floatValue]];
    NSString *downFlow = [JKHelper jk_getFormatUnitFromByte:[netCaptureModel.downFlow floatValue]];
    self.flowLabel.text = [NSString stringWithFormat:@"↑%@ | ↓%@", uploadFlow, downFlow];
}





@end
