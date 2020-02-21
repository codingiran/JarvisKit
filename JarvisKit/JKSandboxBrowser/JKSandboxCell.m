//
//  JKSandboxCell.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/1.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKSandboxCell.h"
#import "JKSandboxModel.h"
#import "JKSandboxHelper.h"

@interface JKSandboxCell ()

@property(nonatomic, strong) UIImageView *typeIcon;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UILabel *size;

@end

@implementation JKSandboxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.typeIcon = [[UIImageView alloc] init];
        self.typeIcon.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.typeIcon];
        self.name = [UILabel new];
        self.name.numberOfLines = 0;
        self.name.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.name];
        self.size = [UILabel new];
        self.size.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.size];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.typeIcon.frame = CGRectMake(12, (self.contentView.frame.size.height - 40) * 0.5, 40, 40);
    [self.size sizeToFit];
    self.size.frame = CGRectMake(self.contentView.frame.size.width - 10 - self.size.frame.size.width, (self.contentView.frame.size.height - self.size.frame.size.height) * 0.5, self.size.frame.size.width, self.size.frame.size.height);
    self.name.frame = CGRectMake(CGRectGetMaxX(self.typeIcon.frame) + 5, 15, self.contentView.frame.size.width - CGRectGetMaxX(self.typeIcon.frame) - 5 - 10 - self.size.frame.size.width - 5/* name和size的间距 */, self.sandboxModel.cellHeight - 15 - 15);
}


#pragma mark - setter & getter
- (void)setSandboxModel:(JKSandboxModel *)sandboxModel
{
    _sandboxModel = sandboxModel;
    NSDictionary *attrDict = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16]};
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:sandboxModel.name attributes:attrDict];
    [self.name setAttributedText:attrStr];
    self.typeIcon.image = JKImageMake(sandboxModel.fileTypeImageName);
    attrDict = @{NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:14]};
    attrStr = [[NSAttributedString alloc] initWithString:sandboxModel.subSizeStr attributes:attrDict];
    [self.size setAttributedText:attrStr];
    // 文件夹不显示文件大小
    self.size.hidden = sandboxModel.type != JKSandboxTypeFile;
    
    if (sandboxModel.type == JKSandboxTypeDirectory) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self layoutIfNeeded];
}


@end
