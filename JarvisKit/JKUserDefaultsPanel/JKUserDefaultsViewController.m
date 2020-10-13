//
//  JKUserDefaultsViewController.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/4.
//  Copyright © 2019 wekids. All rights reserved.
//


#import "JKUserDefaultsViewController.h"
#import "JKUserDefaultsValueCell.h"
#import "JKUserDefaultsHelper.h"
#import "JKUserDefaultsModel.h"

typedef NS_ENUM(NSUInteger, JKUserDefaultsShowType) {
    JKUserDefaultsShowTypeList,      // 列表模式
    JKUserDefaultsShowTypeText       // 文本模式
};

static NSString * const kReuseTableViewCellIdentifier = @"JKUserDefaultsValueCell";
static NSTimeInterval const kTransitionAnimationDuration = 0.45f;

@interface JKUserDefaultsViewController ()


/// 文本展示容器
@property(nonatomic, strong) UITextView *textView;

/// 当前控制器模型
@property(nonatomic, strong) JKUserDefaultsModel *currentUserDefaultsModel;

/// 当前列表模型数组
@property(nonatomic, copy) NSArray<NSString *> *sectionIndexList;
@property(nonatomic, copy) NSArray *userDefaultsLists;

/// tableview展示列表 or 文本形式的字典
@property(nonatomic, assign) JKUserDefaultsShowType userDefaultsShowType;

@end

@implementation JKUserDefaultsViewController

- (void)jk_initTableView
{
    [super jk_initTableView];
    
    [self.tableView setSectionIndexBackgroundColor:UIColor.clearColor];
    [self.tableView setSectionIndexColor:JKThemeColor];
    [self.tableView registerClass:[JKUserDefaultsValueCell class] forCellReuseIdentifier:kReuseTableViewCellIdentifier];
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    
    // 添加分段选择列表或文本模式
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[JKImageMake(@"jarvis_segment_list"), JKImageMake(@"jarvis_segment_text")]];
    // 默认为列表模式
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    
    // 只有字典的根节点才有关闭和添加按钮
    if (self.currentUserDefaultsModel.isRoot) {
        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:JKImageMake(@"jarvis_navi_close") style:UIBarButtonItemStylePlain target:self action:@selector(navigationDismss:)];
        self.navigationItem.leftBarButtonItems = @[closeItem];
        
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:JKImageMake(@"jarvis_navi_add") style:UIBarButtonItemStylePlain target:self action:@selector(navigationAdd:)];
        self.navigationItem.rightBarButtonItems = @[addItem];
    }
}

- (NSArray<NSArray *> *)makeSectionListWith:(NSDictionary *)userDefaultsDic
{
    // 字典转模型列表
    NSMutableArray<JKUserDefaultsModel *> *list = [NSMutableArray arrayWithCapacity:userDefaultsDic.allKeys.count];
    [userDefaultsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 生成模型
        JKUserDefaultsModel *model = [[JKUserDefaultsModel alloc] initWithKey:key andValue:obj];
        [list addObject:model];
        
    }];
    
    // 模型列表排序
    NSArray<JKUserDefaultsModel *> *sortedList = [list sortedArrayUsingComparator:^NSComparisonResult(JKUserDefaultsModel * _Nonnull obj1, JKUserDefaultsModel * _Nonnull obj2) {
        return [obj1.key.uppercaseString compare:obj2.key.uppercaseString];
    }];
    
    // 生成 section 需要的列表
    NSMutableArray<NSString *> *sectionIndexList = [[NSMutableArray alloc] initWithCapacity:27];
    unichar lastChar = '^_^';
    NSMutableArray<NSMutableArray<JKUserDefaultsModel *> *> *resultList = [NSMutableArray arrayWithCapacity:27];
    NSMutableArray<JKUserDefaultsModel *> *otherModelList = [NSMutableArray array];
    NSMutableArray<JKUserDefaultsModel *> *alphaModelList = nil;
    for (JKUserDefaultsModel *model in sortedList) {
        // 索引
        unichar c = [model.key characterAtIndex:0];
        NSString *cStr = [NSString stringWithFormat:@"%c", c].uppercaseString;
        c = [cStr characterAtIndex:0];
        if (!isalpha(c)) {
            [otherModelList addObject:model];
        } else if (c != lastChar) {
            if (alphaModelList && alphaModelList.count) {
                [resultList addObject:alphaModelList];
                NSString *lastCStr = [NSString stringWithFormat:@"%c", lastChar];
                [sectionIndexList addObject:lastCStr];
            }
            alphaModelList = [NSMutableArray array];
            [alphaModelList addObject:model];
            lastChar = c;
        } else {
            [alphaModelList addObject:model];
        }
    }
    if (otherModelList.count) {
        [resultList addObject:otherModelList];
        [sectionIndexList addObject:@"#"];
    }
    self.sectionIndexList = sectionIndexList.copy;
    
    return resultList.copy;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 将字典转为tableview数据源
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        NSDictionary *userDefaultsDic = (NSDictionary *)self.currentUserDefaultsModel.value;
        self.userDefaultsLists = [self makeSectionListWith:userDefaultsDic];
    }
    
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeArray) {
        NSArray *userDefaultsArray = (NSArray *)self.currentUserDefaultsModel.value;
        NSMutableArray<JKUserDefaultsModel *> *list = [NSMutableArray arrayWithCapacity:userDefaultsArray.count];
        [userDefaultsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JKUserDefaultsModel *model = [[JKUserDefaultsModel alloc] init];
            model.value = obj;
            [list addObject:model];
        }];
        self.userDefaultsLists = list.copy;
    }
    
    self.tableView.separatorStyle = (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) ? UITableViewCellSeparatorStyleNone : UITableViewCellSeparatorStyleSingleLine;
    [self.tableView reloadData];
}

#pragma mark - touch event

- (void)segmentSelected:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            self.userDefaultsShowType = JKUserDefaultsShowTypeList;
        }
            break;
        case 1:
        {
            self.userDefaultsShowType = JKUserDefaultsShowTypeText;
        }
            break;
            
        default:
            break;
    }
}

/// 给NSUserDefaults添加新项
- (void)navigationAdd:(UIBarButtonItem *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"写入NSUserDeaults" message:@"仅支持如下几种类型的Key" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(self)weakSelf = self;
    UIAlertAction *stringAction = [UIAlertAction actionWithTitle:@"NSString" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf addUserDefaultsWithType:JKUserDefaultsValueTypeString];
    }];
    UIAlertAction *numberAction = [UIAlertAction actionWithTitle:@"NSNumber" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf addUserDefaultsWithType:JKUserDefaultsValueTypeNumber];
    }];
    UIAlertAction *boolAction = [UIAlertAction actionWithTitle:@"BOOL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf addUserDefaultsWithType:JKUserDefaultsValueTypeBool];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    [alertController addAction:stringAction];
    [alertController addAction:numberAction];
    [alertController addAction:boolAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)addUserDefaultsWithType:(JKUserDefaultsValueType)type
{
    UIAlertController *addAlertController = [UIAlertController alertControllerWithTitle:@"新增" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [addAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.placeholder = @"输入key";
    }];
    [addAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        if (type == JKUserDefaultsValueTypeString) {
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.placeholder = @"输入字符串";
        }
        if (type == JKUserDefaultsValueTypeNumber) {
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            textField.placeholder = @"输入integer、float或double";
        }
        if (type == JKUserDefaultsValueTypeBool) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder = @"输入1或0";
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(addAlertController)weakAddAlertController = addAlertController;
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf0 = weakAddAlertController.textFields[0];
        UITextField *tf1 = weakAddAlertController.textFields[1];
        if (tf0.text.length) {
            // 添加userdefaults数据
            JKUserDefaultsModel *newModel = [JKUserDefaultsModel new];
            if (type == JKUserDefaultsValueTypeString) {
                [[NSUserDefaults standardUserDefaults] setValue:tf1.text forKey:tf0.text];
            }
            if (type == JKUserDefaultsValueTypeNumber) {
                [[NSUserDefaults standardUserDefaults] setValue:[JKUserDefaultsHelper numberFromString:tf1.text] forKey:tf0.text];
            }
            if (type == JKUserDefaultsValueTypeBool) {
                [[NSUserDefaults standardUserDefaults] setBool:[JKUserDefaultsHelper booleanFromString:tf1.text] forKey:tf0.text];
            }
            
            weakSelf.currentUserDefaultsModel = [self realodCurrentUserDefaultsModel];
            NSDictionary *userDefaultsDic = (NSDictionary *)weakSelf.currentUserDefaultsModel.value;
            weakSelf.userDefaultsLists = [weakSelf makeSectionListWith:userDefaultsDic];
            
            // 刷新列表
            [weakSelf.tableView reloadData];
            
            // 如果是文本模式还需要刷新文本
            if (weakSelf.userDefaultsShowType == JKUserDefaultsShowTypeText) {
                weakSelf.textView.text = [weakSelf.currentUserDefaultsModel.value description];
            }
        }
    }];
    [addAlertController addAction:cancel];
    [addAlertController addAction:submit];
    [self presentViewController:addAlertController animated:YES completion:NULL];
}

- (void)doubleTap:(UITapGestureRecognizer *)doubleTap
{
    NSString *textToShare = self.textView.text;
    NSArray *activityItems = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - private methods

/// 刷新副本
- (void)updateUserDefaultsTranscript
{
    if (!self.currentUserDefaultsModel.isRoot) return;
    // 将模型转为字典模型
    NSMutableDictionary *userDefaltsDict = [NSMutableDictionary dictionary];
    [self.userDefaultsLists enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSArray.class]) {
            NSArray<JKUserDefaultsModel *> *data = (NSArray<JKUserDefaultsModel *> *)obj;
            for (JKUserDefaultsModel *model in data) {
                NSAssert(model.value && model.key, @"Error: 将一个为nil的value写入字典");
                [userDefaltsDict setValue:model.value forKey:model.key];
            }
        } else {
            if ([obj isKindOfClass:JKUserDefaultsModel.class]) {
                JKUserDefaultsModel *model = (JKUserDefaultsModel *)obj;
                NSAssert(model.value && model.key, @"Error: 将一个为nil的value写入字典");
                [userDefaltsDict setValue:model.value forKey:model.key];
            }
        }
    }];
    self.currentUserDefaultsModel.value = userDefaltsDict.copy;
}

#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        return self.userDefaultsLists.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        NSArray<JKUserDefaultsModel *> *sectionData = self.userDefaultsLists[section];
        return sectionData.count;
    }
    return self.userDefaultsLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKUserDefaultsValueCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseTableViewCellIdentifier];
    cell.needShowKey = self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary;
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        NSArray<JKUserDefaultsModel *> *sectionData = self.userDefaultsLists[indexPath.section];
        cell.userDefaultsModel = sectionData[indexPath.row];
    } else {
        cell.userDefaultsModel = self.userDefaultsLists[indexPath.row];
    }
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionIndexList;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        return self.sectionIndexList[section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.currentUserDefaultsModel.isRoot;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 指头根节点才可以增删改
    if (!self.currentUserDefaultsModel.isRoot) return nil;
    JKUserDefaultsModel *model = (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) ? self.userDefaultsLists[indexPath.section][indexPath.row] : self.userDefaultsLists[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 删除NSUserDefaults的数据
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:model.key];
        // 刷新数据源
        self.currentUserDefaultsModel = [self realodCurrentUserDefaultsModel];
        self.userDefaultsLists = [self makeSectionListWith:(NSDictionary *)self.currentUserDefaultsModel.value];
        
        // 刷新tableview
        if (@available(iOS 11.0, *)) {
            [self.tableView performBatchUpdates:^{
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } completion:NULL];
        } else {
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }];
    
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(JKUserDefaultsModel *)weakModel = model;
    UITableViewRowAction *modifyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改值" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf handleModifyWithModel:weakModel atIndexPath:indexPath];
    }];
    
    if (model.editable) {
        return @[deleteAction, modifyAction];
    } else {
        return @[deleteAction];
    }
}

- (void)handleModifyWithModel:(JKUserDefaultsModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    if (model.valueType == JKUserDefaultsValueTypeBool) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改值" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSNumber *number = [NSNumber numberWithBool:YES];
            model.value = number;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:model.key];
            [self updateUserDefaultsTranscript];// 更新副本
            [self.tableView beginUpdates];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSNumber *number = [NSNumber numberWithBool:NO];
            model.value = number;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:model.key];
            [self updateUserDefaultsTranscript];// 更新副本
            [self.tableView beginUpdates];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
        [alertController addAction:yesAction];
        [alertController addAction:noAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
    if (model.valueType == JKUserDefaultsValueTypeNumber) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改值" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            NSNumber *number = (NSNumber *)model.value;
            textField.text = [NSString stringWithFormat:@"%@", number.description];
        }];
        __weak __typeof(alertController)weakAlertController = alertController;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
        UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = weakAlertController.textFields.firstObject;
            NSNumber *number = (NSNumber *)model.value;
            if (textField.text.length && ![textField.text isEqualToString:number.description]) {
                NSNumber *newNunber = [JKUserDefaultsHelper numberFromString:textField.text];
                model.value = newNunber;
                [[NSUserDefaults standardUserDefaults] setValue:newNunber forKey:model.key];
                [self updateUserDefaultsTranscript];// 更新副本
                [self.tableView beginUpdates];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:submitAction];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
    if (model.valueType == JKUserDefaultsValueTypeString) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改值" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeDefault;
            NSString *textValue = (NSString *)model.value;
            textField.text = textValue;
        }];
        __weak __typeof(alertController)weakAlertController = alertController;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
        UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = weakAlertController.textFields.firstObject;
            NSString *textValue = (NSString *)model.value;
            if (textField.text.length && ![textField.text isEqualToString:textValue]) {
                model.value = textField.text;
                [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:model.key];
                [self updateUserDefaultsTranscript];// 更新副本
                [self.tableView beginUpdates];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:submitAction];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        JKUserDefaultsModel *model = self.userDefaultsLists[indexPath.section][indexPath.row];
        if (!model.selectable) return;
        
        JKUserDefaultsViewController *userDefaultsViewController = [[JKUserDefaultsViewController alloc] init];
        userDefaultsViewController.currentUserDefaultsModel = model;
        [self.navigationController pushViewController:userDefaultsViewController animated:YES];
    }
}

#pragma mark - setter & getter

- (void)setUserDefaultsShowType:(JKUserDefaultsShowType)userDefaultsShowType
{
    _userDefaultsShowType = userDefaultsShowType;
    
    if (userDefaultsShowType == JKUserDefaultsShowTypeList) {
        if (![self.textView isDescendantOfView:self.view]) return;
        [self.view.layer removeAllAnimations];
        CATransition *transition = [CATransition animation];
        transition.duration = kTransitionAnimationDuration;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"cube";
        transition.subtype = kCATransitionFromLeft;
        [self.view.layer addAnimation:transition forKey:@"CubeAnimationFromLeft"];
        [self.textView removeFromSuperview];
    }
    
    if (userDefaultsShowType == JKUserDefaultsShowTypeText) {
        NSString *text = [self.currentUserDefaultsModel.value description];
        if (text && text.length) {
            [self.view.layer removeAllAnimations];
            self.textView.text = text;
            CATransition *transition = [CATransition animation];
            transition.duration = kTransitionAnimationDuration;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"cube";
            transition.subtype = kCATransitionFromRight;
            [self.view.layer addAnimation:transition forKey:@"CubeAnimationFromRight"];
            if (![self.textView isDescendantOfView:self.view]) {
                [self.view addSubview:self.textView];
            }
        }
    }
}

- (JKUserDefaultsModel *)realodCurrentUserDefaultsModel
{
    JKUserDefaultsModel *currentUserDefaultsModel = [[JKUserDefaultsModel alloc] initWithKey:@"NSUserDefaults" andValue:[JKUserDefaultsHelper achieveUserDefaultsFromSandboxPlist]];
    currentUserDefaultsModel.isRoot = YES;
    return currentUserDefaultsModel;
}

- (JKUserDefaultsModel *)currentUserDefaultsModel
{
    if (!_currentUserDefaultsModel) {
        _currentUserDefaultsModel = [self realodCurrentUserDefaultsModel];
    }
    return _currentUserDefaultsModel;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        _textView.alwaysBounceVertical = YES;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = NO;
        _textView.dataDetectorTypes = UIDataDetectorTypeLink;
        _textView.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [_textView addGestureRecognizer:doubleTap];
    }
    return _textView;
}

@end
