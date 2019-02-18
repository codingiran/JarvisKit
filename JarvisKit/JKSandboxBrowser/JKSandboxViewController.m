//
//  JKSandboxViewController.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/1.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKSandboxViewController.h"
#import "JKSandboxFilePreviewViewController.h"
#import "JKSandboxFavPathListController.h"
#import "JKSandboxCell.h"
#import "JKSandboxModel.h"
#import "JKSandboxHelper.h"
#import "JKSandboxFavPathModel.h"
@import MobileCoreServices;

static NSString * const kReuseIdentifier = @"SandboxTableViewCell";

@interface JKSandboxViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, JKMenuLabelActionDelegate>

@property(nonatomic, strong) NSArray<JKSandboxModel *> *dataArray;

@property(nonatomic, strong) JKSandboxModel *currentSandboxModel;

@property(nonatomic, copy) NSString *rootPath;

@property(nonatomic, strong) UIImagePickerController *imagePicker;

@property(nonatomic, strong) JKMenuLabel *fullPathLabel;

@end

@implementation JKSandboxViewController

#pragma mark - initilize
- (instancetype)init
{
    if (self = [super init]) {
        // 根目录
        self.rootPath = NSHomeDirectory();
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 10.0, *)) {
        // refresh
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        self.tableView.refreshControl = refreshControl;
    }
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    
    // 设置titleLabel的点击事件
    __weak __typeof(self)weakSelf = self;
    self.tapOnTitleLabelComletion = ^(UILabel * _Nonnull titleLabel, UIGestureRecognizer * _Nonnull tap) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.navigationController setToolbarHidden:!strongSelf.navigationController.toolbarHidden animated:YES];
    };
    [self loadPath:self.currentSandboxModel.path];
    
    // 编辑
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItems = @[editItem];
}

- (void)jk_setupToolbarItems
{
    [super jk_setupToolbarItems];
    UIBarButtonItem *favPathItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(showFavPathList:)];
    UIBarButtonItem *showFullPathItem = [[UIBarButtonItem alloc] initWithCustomView:self.fullPathLabel];
    self.toolbarItems = @[favPathItem, showFullPathItem];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)jk_initTableView
{
    [super jk_initTableView];
    [self.tableView registerClass:[JKSandboxCell class] forCellReuseIdentifier:kReuseIdentifier];
}

#pragma mark - private method
- (void)loadPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *targetPath = filePath;
    
    // 当前目录信息
    JKSandboxModel *model = [JKSandboxModel new];
    if (!targetPath.length || [targetPath isEqualToString:self.rootPath]) {
        // 根目录
        targetPath = self.rootPath;
        model.name = @"根目录";
        model.type = JKSandboxTypeRoot;
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithImage:JKImageMake(@"jarvis_navi_close") style:UIBarButtonItemStylePlain target:self action:@selector(navigationDismss:)];
        // 此处1个也要用数组，否则返回根目录时会出问题，leftBarButtonItems和leftBarButtonItem是互斥的...
        self.navigationItem.leftBarButtonItems = @[close];
        self.navigationTitle = @"沙盒浏览器";
        self.fullPathLabel.text = targetPath;
    } else {
        model.name = @"子目录";
        model.type = JKSandboxTypeSub;
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithImage:JKImageMake(@"jarvis_navi_close") style:UIBarButtonItemStylePlain target:self action:@selector(navigationDismss:)];
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:JKImageMake(@"jarvis_navi_back") style:UIBarButtonItemStylePlain target:self action:@selector(navigationBack:)];
        self.navigationItem.leftBarButtonItems = @[back, close];
        self.navigationTitle = [fileManager displayNameAtPath:targetPath];
        self.fullPathLabel.text = targetPath;
    }
    model.path = filePath;
    self.currentSandboxModel = model;
    
    // 当前目录下文件信息
    NSMutableArray<JKSandboxModel *> *files = [NSMutableArray array];
    NSError *error = nil;
    NSArray *paths = [fileManager contentsOfDirectoryAtPath:targetPath error:&error];
    for (NSString *path in paths) {
        NSString *fullPath = [targetPath stringByAppendingPathComponent:path];
        BOOL isDir = [JKSandboxHelper isDirectoryWithPath:fullPath];
        JKSandboxModel *model = [JKSandboxModel new];
        model.path = fullPath;
        if (isDir) {
            model.type = JKSandboxTypeDirectory;
        } else {
            model.type = JKSandboxTypeFile;
        }
        
        model.name = path;
        [files addObject:model];
    }
    
    self.dataArray = [files copy];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - touch event
- (void)navigationDismss:(UIBarButtonItem *)sender
{
    [super navigationDismss:sender];
}

/// 刷新当前目录的文件列表
- (void)refresh:(UIRefreshControl *)refreshControl
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadPath:self.currentSandboxModel.path];
        [refreshControl endRefreshing];
    });
}

/// 编辑
- (void)editAction:(UIBarButtonItem *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *createFolder = [UIAlertAction actionWithTitle:@"创建文件夹" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"创建文件夹" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"输入文件夹名称";
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
        UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = alert.textFields.firstObject;
            NSString *newFolderName = textField.text.length ? textField.text : @"未命名文件夹";
            NSString *newPath = [self.currentSandboxModel.path stringByAppendingPathComponent:newFolderName];
            BOOL createSuccess = [JKSandboxHelper creatDirectoryWithPath:newPath];
            if (!createSuccess) {
                // 创建失败，通常是因为没有权限:例如真机下在根目录创建文件系统是不允许的
                UIAlertController *alertWarning = [UIAlertController alertControllerWithTitle:@"创建失败" message:@"没有权限在当前目录下创建文件夹" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alertWarning dismissViewControllerAnimated:YES completion:NULL];
                }];
                [alertWarning addAction:okAction];
                [self presentViewController:alertWarning animated:YES completion:NULL];
            } else {
                // 创建成功，刷新数据
                [self loadPath:self.currentSandboxModel.path];
            }
        }];
        [alert addAction:cancelAction];
        [alert addAction:submitAction];
        
        [self presentViewController:alert animated:YES completion:NULL];
    }];
    UIAlertAction *addPhoto = [UIAlertAction actionWithTitle:@"从相册添加文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([JKSandboxHelper isPhotoLibraryAvailable]) {
            [self presentViewController:self.imagePicker animated:YES completion:NULL];
        } else {
            UIAlertController *photoLibraryAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有相册访问权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [photoLibraryAlert dismissViewControllerAnimated:YES completion:NULL];
            }];
            [photoLibraryAlert addAction:okAction];
            [self presentViewController:photoLibraryAlert animated:YES completion:NULL];
        }
    }];
    
    UIAlertAction *batchModify = [UIAlertAction actionWithTitle:@"批量操作" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!self.tableView.isEditing) {
            [self.tableView setEditing:YES animated:YES];
            
            // 编辑--->取消
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
            
            self.navigationItem.rightBarButtonItems = @[cancelItem];
        }
    }];
    UIAlertAction *refreshData = [UIAlertAction actionWithTitle:@"刷新数据" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (@available(iOS 10.0, *)) {
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - self.tableView.refreshControl.frame.size.height) animated:NO];
            [self.tableView.refreshControl beginRefreshing];
            [self.tableView.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
        } else {
            [self loadPath:self.currentSandboxModel.path];
        }
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:createFolder];
    [alertController addAction:addPhoto];
    
    // 这边对于权限的判断不是很靠谱：如果一个文件夹没有写入权限，自然没有删除其中文件的权限
    BOOL isWritable = [JKSandboxHelper isWritableFileAtPath:self.currentSandboxModel.path];
    if (isWritable) {
        [alertController addAction:batchModify];
    }
    
    [alertController addAction:refreshData];

    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)cancelAction:(UIBarButtonItem *)sender
{
    if (!self.tableView.isEditing) return;
    [self.tableView setEditing:NO animated:YES];
    
    // 取消---->编辑
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItems = @[editItem];
}

/// 返回按钮(并没有真正返回，只是加载上一级目录的文件)
- (void)navigationBack:(UIBarButtonItem *)sender
{
    if (self.currentSandboxModel.type == JKSandboxTypeRoot) return;
    [self loadPath:[self.currentSandboxModel.path stringByDeletingLastPathComponent]];
}

/// 显示收藏列表
- (void)showFavPathList:(UIBarButtonItem *)sender
{
    JKSandboxFavPathListController *sandboxFavPathListController = [[JKSandboxFavPathListController alloc] initWithStyle:UITableViewStylePlain];
    sandboxFavPathListController.firstControllerNeedNavigationCloseItem = NO;
    sandboxFavPathListController.navigationBarTintColor = [UIColor darkTextColor];
    sandboxFavPathListController.navigationBarBackgroundColor = [UIColor whiteColor];
    JKNavigtionController *navigationController = [[JKNavigtionController alloc] initWithRootViewController:sandboxFavPathListController];
    navigationController.modalPresentationStyle = UIModalPresentationPopover;
    navigationController.preferredContentSize = CGSizeMake(self.view.jk_width * 0.9, self.view.jk_width * 0.7);
    __weak __typeof(self)weakSelf = self;
    sandboxFavPathListController.selectFavoritePathCompletion = ^(JKSandboxFavPathListController * _Nonnull favPathListController, NSString * _Nonnull selectedPath) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf loadPath:selectedPath];
    };
    
    UIPopoverPresentationController *popoverController = navigationController.popoverPresentationController;
    popoverController.backgroundColor = [UIColor whiteColor];
    popoverController.delegate = self;
    if ([sender respondsToSelector:@selector(view)]) {
        UIView *itemView = [sender valueForKey:@"view"];
        popoverController.sourceView = itemView;
        popoverController.sourceRect = itemView.bounds;
        popoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKSandboxCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    cell.sandboxModel = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKSandboxModel *model = self.dataArray[indexPath.row];
    CGFloat cellHeight = model.cellHeight;
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKSandboxModel *model = self.dataArray[indexPath.row];
    if (model.type == JKSandboxTypeDirectory) {
        [self loadPath:model.path];
    } else {
        [self handleSanboxFileWithSandboxModel:model];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // MARK: 模拟器的Documents,Library,tmp是可被删除的，但真机无法被删除
    JKSandboxModel *model = self.dataArray[indexPath.row];
    BOOL isDeletable = [JKSandboxHelper isDeletableFileAtPath:model.path];
    return isDeletable;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 删除
        JKSandboxModel *model = self.dataArray[indexPath.row];
        if (![JKSandboxHelper isDeletableFileAtPath:model.path]) return;
        [JKSandboxHelper removeFileOfPath:model.path];
        // 删除数据源
        NSMutableArray<JKSandboxModel *> *dataArray = [self.dataArray mutableCopy];
        [dataArray removeObjectAtIndex:indexPath.row];
        self.dataArray = dataArray.copy;
        // 删除cell
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    __weak __typeof(self)weakSelf = self;
    UITableViewRowAction *renameAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"重命名" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JKSandboxModel *model = strongSelf.dataArray[indexPath.row];
        UIAlertController *textFieldAlert = [UIAlertController alertControllerWithTitle:@"重命名" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [textFieldAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"输入新的名称";
            textField.text = [[model.path lastPathComponent] stringByDeletingPathExtension];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
        UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = textFieldAlert.textFields.firstObject;
            NSString *newName = textField.text.length ? textField.text : @"重命名";
            BOOL renameSuccess = [JKSandboxHelper renameFileOrDirectoryAtPath:model.path withNewName:newName];
            if (renameSuccess) {
                [strongSelf loadPath:strongSelf.currentSandboxModel.path];
            } else {
                UIAlertController *alertWarning = [UIAlertController alertControllerWithTitle:@"重命名失败" message:@"没有重命名的权限" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alertWarning dismissViewControllerAnimated:YES completion:NULL];
                }];
                [alertWarning addAction:okAction];
                [strongSelf presentViewController:alertWarning animated:YES completion:NULL];
            }
        }];
        [textFieldAlert addAction:cancelAction];
        [textFieldAlert addAction:submitAction];
        
        [self presentViewController:textFieldAlert animated:YES completion:NULL];
    }];
    
    return @[deleteAction, renameAction];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除
        JKSandboxModel *model = self.dataArray[indexPath.row];
        if (![JKSandboxHelper isDeletableFileAtPath:model.path]) return;
        [JKSandboxHelper removeFileOfPath:model.path];
        // 删除数据源
        NSMutableArray<JKSandboxModel *> *dataArray = [self.dataArray mutableCopy];
        [dataArray removeObjectAtIndex:indexPath.row];
        self.dataArray = dataArray.copy;
        // 删除cell
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)handleSanboxFileWithSandboxModel:(JKSandboxModel *)model
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请选择操作方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *previewAction = [UIAlertAction actionWithTitle:@"本地预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf previewFileWithSandboxModel:model];
    }];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf shareFileWithPath:model.path];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    [alertVc addAction:previewAction];
    [alertVc addAction:shareAction];
    [alertVc addAction:cancelAction];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)previewFileWithSandboxModel:(JKSandboxModel *)model
{
    JKSandboxFilePreviewViewController *sandboxFilePreviewVc = [[JKSandboxFilePreviewViewController alloc] initWithSandboxModel:model];
    JKNavigtionController *navigationVC = [[JKNavigtionController alloc] initWithRootViewController:sandboxFilePreviewVc];
    [self presentViewController:navigationVC animated:YES completion:NULL];
}

- (void)shareFileWithPath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    NSArray *objectsToShare = @[url];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            if (image) {
                // 创建时间戳
                NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval time = [date timeIntervalSince1970] * 10;
                NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
                NSString *imagePath = [self.currentSandboxModel.path stringByAppendingPathComponent:[NSString stringWithFormat:@"MyPhoto_%@.png", timeString]];
                NSData *imageData = UIImagePNGRepresentation(image);
                if (!image || !imageData.length) {
                    imageData = UIImageJPEGRepresentation(image, 0.9);
                }
                BOOL createSuccess = [JKSandboxHelper saveFile:imagePath withData:imageData];
                if (!createSuccess) {
                    // 创建失败，通常是因为没有权限:例如真机下在根目录创建文件系统是不允许的
                    UIAlertController *alertWarning = [UIAlertController alertControllerWithTitle:@"创建失败" message:@"没有权限在当前目录下创建文件" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [alertWarning dismissViewControllerAnimated:YES completion:NULL];
                    }];
                    [alertWarning addAction:okAction];
                    [self presentViewController:alertWarning animated:YES completion:NULL];
                } else {
                    // 创建成功，刷新数据
                    [self loadPath:self.currentSandboxModel.path];
                }
            }
        }
    }];
}

#pragma mark - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

#pragma mark - JKMenuLabelActionDelegate
- (void)menuLabel:(JKMenuLabel *)label actionDidFinish:(JKMenuActionType)menuActionType
{
    if (menuActionType == JKMenuActionTypeFavorite) {
        if (label.text.length) {
            // 弹出输入收藏名称
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"收藏标识" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.keyboardType = UIKeyboardTypeDefault;
                textField.placeholder = @"输入标识";
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
            UIAlertAction *submit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *textField = alertController.textFields.firstObject;
                NSString *defaultName = [NSString stringWithFormat:@"收藏-%@", label.text.lastPathComponent];
                NSString *favPathName = textField.text.length ? textField.text : defaultName;
                JKSandboxFavPathModel *model = [[JKSandboxFavPathModel alloc] init];
                model.favoritePath = [JKSandboxHelper getRelativePathFromAbsolutePath:label.text];
                model.favoriteName = favPathName;
                [JKSandboxHelper addFavoritePath:model];
            }];
            
            [alertController addAction:cancel];
            [alertController addAction:submit];
            
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
            
            
        }
    }
}

#pragma mark - setter & getter

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (JKSandboxModel *)currentSandboxModel
{
    if (!_currentSandboxModel) {
        _currentSandboxModel = [JKSandboxModel new];
        _currentSandboxModel.path = self.rootPath;
    }
    return _currentSandboxModel;
}

- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.navigationBar.tintColor = [UIColor whiteColor];
        [_imagePicker.navigationBar setBackgroundImage:JKImageMake(@"jarvis_navi_bkg") forBarMetrics:UIBarMetricsDefault];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}


- (JKMenuLabel *)fullPathLabel
{
    if (!_fullPathLabel) {
        _fullPathLabel = [JKMenuLabel new];
        _fullPathLabel.numberOfLines = 0;
        _fullPathLabel.textColor = [UIColor darkTextColor];
        _fullPathLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width * 0.85, 60);
        _fullPathLabel.adjustsFontSizeToFitWidth = YES;
        _fullPathLabel.canPerformMenuAction = YES;
        _fullPathLabel.menuActionType = JKMenuActionTypeCopy | JKMenuActionTypeFavorite;
        _fullPathLabel.delegate = self;
        
//        [_fullPathLabel addMenuWithActionTitle:@"转发" andActionCompletion:^(JKMenuLabel * _Nonnull label, NSString * _Nonnull actionTitle) {
//            NSLog(@"%@-----%@", label.description, actionTitle);
//        }];
//
//        [_fullPathLabel addMenuWithActionTitle:@"下载" andActionCompletion:^(JKMenuLabel * _Nonnull label, NSString * _Nonnull actionTitle) {
//            NSLog(@"%@-----%@", label.description, actionTitle);
//        }];
    }
    return _fullPathLabel;
}

@end
