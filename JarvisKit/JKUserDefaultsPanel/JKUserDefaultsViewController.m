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
#import "JKUserDefaultsKeyView.h"
#import "JKUserDefaultsModel.h"

typedef NS_ENUM(NSUInteger, JKUserDefaultsShowType) {
    JKUserDefaultsShowTypeList,      // 列表模式
    JKUserDefaultsShowTypeText       // 文本模式
};

static NSString * const kReuseTableViewCellIdentifier = @"JKUserDefaultsValueCell";
static NSString * const kReuseTableViewHeaderViewIdentifier = @"JKUserDefaultsKeyView";
static NSTimeInterval const kTransitionAnimationDuration = 0.45f;

@interface JKUserDefaultsViewController ()


/// 文本展示容器
@property(nonatomic, strong) UITextView *textView;

/// 当前控制器模型
@property(nonatomic, strong) JKUserDefaultsModel *currentUserDefaultsModel;

/// 当前列表模型数组
@property(nonatomic, copy) NSArray<JKUserDefaultsModel *> *userDefaultsLists;

/// tableview展示列表 or 文本形式的字典
@property(nonatomic, assign) JKUserDefaultsShowType userDefaultsShowType;

@end

@implementation JKUserDefaultsViewController

- (void)jk_initTableView
{
    [super jk_initTableView];
    [self.tableView registerClass:[JKUserDefaultsValueCell class] forCellReuseIdentifier:kReuseTableViewCellIdentifier];
    [self.tableView registerClass:[JKUserDefaultsKeyView class] forHeaderFooterViewReuseIdentifier:kReuseTableViewHeaderViewIdentifier];
    self.tableView.estimatedRowHeight = 0;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 只有字典的根节点才有关闭和添加按钮
    if (self.currentUserDefaultsModel.isRoot) {
        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:JKImageMake(@"jarvis_navi_close") style:UIBarButtonItemStylePlain target:self action:@selector(navigationDismss:)];
        self.navigationItem.leftBarButtonItems = @[closeItem];
        
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:JKImageMake(@"jarvis_navi_add") style:UIBarButtonItemStylePlain target:self action:@selector(navigationAdd:)];
        self.navigationItem.rightBarButtonItems = @[addItem];
    }
    
    // 将字典转为tableview数据源
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        NSDictionary *userDefaultsDic = (NSDictionary *)self.currentUserDefaultsModel.value;
        NSMutableArray<JKUserDefaultsModel *> *list = [NSMutableArray arrayWithCapacity:userDefaultsDic.allKeys.count];
        [userDefaultsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            JKUserDefaultsModel *model = [[JKUserDefaultsModel alloc] initWithKey:key andValue:obj];
            [list addObject:model];
        }];
        // 使用UILocalizedIndexedCollation对key属性进行排序
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        self.userDefaultsLists = [collation sortedArrayFromArray:list.copy collationStringSelector:@selector(key)];
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
                // 创建新的数据
                newModel = [[JKUserDefaultsModel alloc] initWithKey:tf0.text andValue:tf1.text];
            }
            if (type == JKUserDefaultsValueTypeNumber) {
                [[NSUserDefaults standardUserDefaults] setValue:[JKUserDefaultsHelper numberFromString:tf1.text] forKey:tf0.text];
                // 创建新的数据
                newModel = [[JKUserDefaultsModel alloc] initWithKey:tf0.text andValue:[JKUserDefaultsHelper numberFromString:tf1.text]];
            }
            if (type == JKUserDefaultsValueTypeBool) {
                [[NSUserDefaults standardUserDefaults] setBool:[JKUserDefaultsHelper booleanFromString:tf1.text] forKey:tf0.text];
                // 创建新的数据
                newModel = [[JKUserDefaultsModel alloc] initWithKey:tf0.text andValue:[JKUserDefaultsHelper numberFromString:tf1.text]];
                newModel.valueType = JKUserDefaultsValueTypeBool;
            }
            
            // 添加数据源
            NSMutableArray<JKUserDefaultsModel *> *userDefaultsLists = weakSelf.userDefaultsLists.mutableCopy;
            [userDefaultsLists addObject:newModel];
            // 使用UILocalizedIndexedCollation对key属性重新排序
            UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
            weakSelf.userDefaultsLists = [collation sortedArrayFromArray:userDefaultsLists.copy collationStringSelector:@selector(key)];
            
            // 维护副本
            [weakSelf updateUserDefaultsTranscript];
            
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
    NSMutableDictionary *userDefaltsDict = [NSMutableDictionary dictionaryWithCapacity:self.userDefaultsLists.count];
    [self.userDefaultsLists enumerateObjectsUsingBlock:^(JKUserDefaultsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(obj.value && obj.key, @"Error: 将一个为nil的value写入字典");
        [userDefaltsDict setValue:obj.value forKey:obj.key];
    }];
    self.currentUserDefaultsModel.value = userDefaltsDict.copy;
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeArray) {
        return 1;
    }
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        return self.userDefaultsLists.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeArray) {
        return self.userDefaultsLists.count;
    }
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeArray) {
        JKUserDefaultsValueCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseTableViewCellIdentifier];
        cell.userDefaultsModel = self.userDefaultsLists[indexPath.row];
        return cell;
    }
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        JKUserDefaultsValueCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseTableViewCellIdentifier];
        cell.userDefaultsModel = self.userDefaultsLists[indexPath.section];
        return cell;
    }
    return nil;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeArray) {
        JKUserDefaultsModel *model = self.userDefaultsLists[indexPath.row];
        return model.cellHeight;
    }
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        JKUserDefaultsModel *model = self.userDefaultsLists[indexPath.section];
        return model.cellHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        JKUserDefaultsKeyView *keyView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kReuseTableViewHeaderViewIdentifier];
        JKUserDefaultsModel *model = self.userDefaultsLists[section];
        keyView.titleLabel.text = [NSString stringWithFormat:@"Key%zd: %@", section, model.key];
        keyView.titleLabel.text = [NSString stringWithFormat:@"%@", model.key];
        keyView.contentEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 15);
        return keyView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        return 44;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.currentUserDefaultsModel.isRoot;
}

//    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"NSDate"];
//    NSString *s = @"1234的";
//    [[NSUserDefaults standardUserDefaults] setObject:s forKey:@"NSStringjj"];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BOOL"];
//    [[NSUserDefaults standardUserDefaults] setDouble:1.0 forKey:@"Double"];
//    NSURL *url = [NSURL URLWithString:@"https://www.bilibili.com/"];
//    [[NSUserDefaults standardUserDefaults] setURL:url forKey:@"NSURL"];

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 指头根节点才可以增删改
    if (!self.currentUserDefaultsModel.isRoot) return nil;
    JKUserDefaultsModel *model = self.userDefaultsLists[indexPath.section];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 删除NSUserDefaults的数据
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:model.key];
        // 刷新数据源
        NSMutableArray<JKUserDefaultsModel *> *userDefaultsLists = self.userDefaultsLists.mutableCopy;
        [userDefaultsLists removeObjectAtIndex:indexPath.section];
        self.userDefaultsLists = userDefaultsLists.copy;
        // 刷新维护的NSUserDefaults字典副本（存在self.currentUserDefaultsModel.value中）
        [self updateUserDefaultsTranscript];
        // 刷新tableview
        [self.tableView beginUpdates];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
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
    JKUserDefaultsModel *model = nil;
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeArray) {
        model = self.userDefaultsLists[indexPath.section];
    }
    if (self.currentUserDefaultsModel.valueType == JKUserDefaultsValueTypeDictionary) {
        model = self.userDefaultsLists[indexPath.section];
    }
    if (!model || !model.selectable) return;
    
    JKUserDefaultsViewController *userDefaultsViewController = [[JKUserDefaultsViewController alloc] init];
    userDefaultsViewController.currentUserDefaultsModel = model;
    [self.navigationController pushViewController:userDefaultsViewController animated:YES];
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

- (JKUserDefaultsModel *)currentUserDefaultsModel
{
    if (!_currentUserDefaultsModel) {
        _currentUserDefaultsModel = [[JKUserDefaultsModel alloc] initWithKey:@"NSUserDefaults" andValue:[JKUserDefaultsHelper achieveUserDefaultsFromSandboxPlist]];
        _currentUserDefaultsModel.isRoot = YES;
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
