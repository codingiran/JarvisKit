//
//  JKNetCaptureDetailViewController.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/18.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKNetCaptureDetailViewController.h"
#import "JKSegmentView.h"
#import "JKNetCaptureModel.h"
#import "JKMenuLabel.h"

static NSString * const kTableViewResuseIdentifier = @"JKNetCaptureDetailCell";

static CGFloat const kDetailCellLeftMargin    = 15.0f;
static CGFloat const kDetailCellTopMargin     = 15.0f;
static CGFloat const kDetailCellRightMargin   = 10.0f;

typedef NS_ENUM(NSUInteger, JKNetCaptureDetailType) {
    JKNetCaptureDetailTypeRequest,      // 请求
    JKNetCaptureDetailTypeResponse      // 响应
};

@interface JKNetCaptureDetailCell : UITableViewCell

@property(nonatomic, strong) JKMenuLabel *contentLabel;

@end

@interface JKNetCaptureDetailViewController ()<JKSegmentViewDelegate>

@property(nonatomic, strong) JKNetCaptureModel *netCaptureModel;

/// 数据源
@property(nonatomic, copy) NSArray<NSDictionary *> *requestDataSource;
@property(nonatomic, copy) NSArray<NSDictionary *> *responseDataSource;

@property(nonatomic, assign) JKNetCaptureDetailType netCaptureDetailType;

@end

@implementation JKNetCaptureDetailViewController

- (instancetype)initWithNetCaptureModel:(JKNetCaptureModel *)model
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.netCaptureModel = model;
        self.requestDataSource = [NSArray array];
        self.responseDataSource = [NSArray array];
        [self prepareDataSourceWithNetCaptureModel:self.netCaptureModel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    self.navigationTitle = @"网络抓包详情";
}

- (void)jk_initTableView
{
    [super jk_initTableView];
    [self.tableView registerClass:[JKNetCaptureDetailCell class] forCellReuseIdentifier:kTableViewResuseIdentifier];
    JKSegmentView *segmentView = [[JKSegmentView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.jk_width, 50)];
    segmentView.delegate = self;
    self.tableView.tableHeaderView = segmentView;
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.netCaptureDetailType == JKNetCaptureDetailTypeRequest) {
        return self.requestDataSource.count;
    }
    if (self.netCaptureDetailType == JKNetCaptureDetailTypeResponse) {
        return self.responseDataSource.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.netCaptureDetailType == JKNetCaptureDetailTypeRequest) {
        NSArray *array = self.requestDataSource[section][@"dataArray"];
        return array.count;
    }
    if (self.netCaptureDetailType == JKNetCaptureDetailTypeResponse) {
        NSArray *array = self.responseDataSource[section][@"dataArray"];
        return array.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKNetCaptureDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewResuseIdentifier];
    
    if (self.netCaptureDetailType == JKNetCaptureDetailTypeRequest) {
        NSArray<NSString *> *array = self.requestDataSource[indexPath.section][@"dataArray"];
        cell.contentLabel.text = array[indexPath.row];
    }
    if (self.netCaptureDetailType == JKNetCaptureDetailTypeResponse) {
        NSArray<NSString *> *array = self.responseDataSource[indexPath.section][@"dataArray"];
        cell.contentLabel.text = array[indexPath.row];
    }
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.netCaptureDetailType == JKNetCaptureDetailTypeRequest) {
        NSArray<NSString *> *array = self.requestDataSource[indexPath.section][@"dataArray"];
        NSString *contentText = array[indexPath.row];
        return [self calculateCellHeightOfCellTextLabelContent:contentText];
    }
    if (self.netCaptureDetailType == JKNetCaptureDetailTypeResponse) {
        NSArray<NSString *> *array = self.responseDataSource[indexPath.section][@"dataArray"];
        NSString *contentText = array[indexPath.row];
        return [self calculateCellHeightOfCellTextLabelContent:contentText];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.netCaptureDetailType == JKNetCaptureDetailTypeRequest) {
        NSString *sectionTitle = self.requestDataSource[section][@"sectionTitle"];
        return sectionTitle;
    }
    if (self.netCaptureDetailType == JKNetCaptureDetailTypeResponse) {
        NSString *sectionTitle = self.responseDataSource[section][@"sectionTitle"];
        return sectionTitle;
    }
    return @"";
}



#pragma mark - private method

/**
 将JKNetCaptureModel模型转为tableview使用的数据源
 @param model 从JKNetCaptureListViewController列表页面传来的模型
 */
- (void)prepareDataSourceWithNetCaptureModel:(JKNetCaptureModel *)model
{
    // 在子线程内准备数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 请求
        NSString *requestDataSize = [NSString stringWithFormat:@"数据大小: %@", [JKNetCaptureHelper jk_getFormatUnitFromByte:model.uploadFlow.floatValue]];
        NSString *method = [NSString stringWithFormat:@"请求方法: %@",model.method];
        NSString *linkUrl = model.url;
        NSDictionary<NSString *, NSString *> *allHTTPHeaderFields = model.request.allHTTPHeaderFields;
        NSMutableString *allHTTPHeaderString = [NSMutableString string];
        for (NSString *key in allHTTPHeaderFields) {
            NSString *value = allHTTPHeaderFields[key];
            [allHTTPHeaderString appendFormat:@"%@ : %@\r\n",key,value];
        }
        if (!allHTTPHeaderString.length) {
            allHTTPHeaderString = [@"NULL" mutableCopy];
        }
        NSString *requestBody = model.requestBody;
        if (!requestBody || !requestBody.length) {
            requestBody = @"NULL";
        }
        self.requestDataSource = @[@{
                                       @"sectionTitle" : @"请求信息",
                                       @"dataArray" : @[requestDataSize, method]
                                       },
                                   @{
                                       @"sectionTitle" : @"请求链接",
                                       @"dataArray" : @[linkUrl]
                                       },
                                   @{
                                       @"sectionTitle" : @"请求头",
                                       @"dataArray" : @[JKTrimWhitespaceString(allHTTPHeaderString)]
                                       },
                                   @{
                                       @"sectionTitle" : @"请求行",
                                       @"dataArray" : @[JKTrimWhitespaceString(requestBody)]
                                       }
                                   ];
        
        // 响应
        NSString *responseDataSize = [NSString stringWithFormat:@"数据大小: %@", [JKNetCaptureHelper jk_getFormatUnitFromByte:model.downFlow.floatValue]];
        NSString *mimeType = [NSString stringWithFormat:@"MIME-Type: %@", model.mineType];
        NSDictionary<NSString *, NSString *> *responseHeaderFields = [(NSHTTPURLResponse *)model.response allHeaderFields];
        NSMutableString *responseHeaderString = [NSMutableString string];
        for (NSString *key in responseHeaderFields) {
            NSString *value = responseHeaderFields[key];
            [responseHeaderString appendFormat:@"%@ : %@\r\n",key,value];
        }
        if (responseHeaderString.length == 0) {
            responseHeaderString = [@"NULL" mutableCopy];
        }
        NSString *responseBody = model.responseBody;
        if (!responseBody || requestBody.length == 0) {
            responseBody = @"NULL";
        }
        
        self.responseDataSource = @[
                                    @{
                                        @"sectionTitle":@"响应信息",
                                        @"dataArray":@[responseDataSize, mimeType]
                                        },
                                    @{
                                        @"sectionTitle":@"响应头",
                                        @"dataArray":@[JKTrimWhitespaceString(responseHeaderString)]
                                        },
                                    @{
                                        @"sectionTitle":@"响应行",
                                        @"dataArray":@[JKTrimWhitespaceString(responseBody)]
                                        }
                                    ];
        // 回到主线程刷新页面
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isViewLoaded) {
                [self.tableView reloadData];
            }
        });
    });
}


/**
 根据cell文字内容计算cell的高度
 @param string cell的文字内容
 @return 合适的cell高度
 */
- (CGFloat)calculateCellHeightOfCellTextLabelContent:(NSString *)string
{
    CGSize maxSize = CGSizeMake(JK_SafeArea_SCREEN_WIDTH - kDetailCellLeftMargin - kDetailCellRightMargin, MAXFLOAT);
    NSDictionary *textAttr = @{NSForegroundColorAttributeName : [UIColor darkTextColor], NSFontAttributeName : JKFontMake(14)};
    CGFloat suitableHeight = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttr context:nil].size.height;
    return suitableHeight + kDetailCellLeftMargin + kDetailCellTopMargin;
}


#pragma mark - JKSegmentViewDelegate
- (void)segmentDidSelecteIndex:(NSInteger)index
{
    if (index == 0) {
        self.netCaptureDetailType = JKNetCaptureDetailTypeRequest;
    }
    if (index == 1) {
        self.netCaptureDetailType = JKNetCaptureDetailTypeResponse;
    }
}

#pragma mark - setter & getter
- (void)setNetCaptureDetailType:(JKNetCaptureDetailType)netCaptureDetailType
{
    BOOL hasChange = netCaptureDetailType != self.netCaptureDetailType;
    if (!hasChange) return;
    _netCaptureDetailType = netCaptureDetailType;
    [self.tableView reloadData];
}

@end


@implementation JKNetCaptureDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentLabel = [JKMenuLabel new];
        self.contentLabel.canPerformMenuAction = YES;
        self.contentLabel.menuActionType = JKMenuActionTypeCopy | JKMenuActionTypeShare;
        self.contentLabel.textColor = [UIColor darkTextColor];
        self.contentLabel.font = JKFontMake(14);
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.menuActionCompletion = ^(JKMenuLabel * _Nonnull label, JKMenuActionType menuActionType) {
            if (menuActionType == JKMenuActionTypeShare) {
                NSString *textToShare = label.text;
                NSArray *activityItems = @[textToShare];
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                __weak UIViewController *visibleVc = [JKHelper jk_visibleViewController];
                [visibleVc presentViewController:activityVC animated:YES completion:nil];
            }
        };
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
        
    CGSize suitableSize = [self.contentLabel sizeThatFits:CGSizeMake(JK_SafeArea_SCREEN_WIDTH - kDetailCellLeftMargin - kDetailCellRightMargin, MAXFLOAT)];
    self.contentLabel.frame = CGRectMake(kDetailCellLeftMargin, kDetailCellTopMargin, suitableSize.width, suitableSize.height);
}

@end
