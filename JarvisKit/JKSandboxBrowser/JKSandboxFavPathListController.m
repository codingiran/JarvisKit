//
//  JKSandboxFavPathListController.m
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/20.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKSandboxFavPathListController.h"
#import "JKSandboxHelper.h"
#import "JKSandboxFavPathModel.h"

static NSString * const kTableViewCellIdentifier = @"UITableViewCell";

@interface JKSandboxFavPathListController ()

@property(nonatomic, copy) NSArray<JKSandboxFavPathModel *> *paths;

@end

@implementation JKSandboxFavPathListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.paths = [JKSandboxHelper getAllFavoritePaths] ? : @[];
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    self.navigationTitle = @"收藏路径";
    self.navigationTitleAttributes = @{NSForegroundColorAttributeName : [UIColor darkTextColor], NSFontAttributeName : JKFontBoldMake(17)};
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableViewCellIdentifier];
    }
    JKSandboxFavPathModel *model = self.paths[indexPath.row];
    cell.textLabel.text = model.favoriteName;
    cell.textLabel.font = JKFontMake(15);
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.text = model.favoritePath;
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        JKSandboxFavPathModel *model = self.paths[indexPath.row];
        NSString *selectedPath = [JKSandboxHelper getAbsolutePathFromRelativePath:model.favoritePath];
        NSAssert(!!selectedPath, @"JKError: 路径为空");
        if (self.selectFavoritePathCompletion) {
            self.selectFavoritePathCompletion(self, selectedPath);
            self.selectFavoritePathCompletion = nil;
        }
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([JKSandboxHelper removeFavoritePath:indexPath.row]) {
            NSMutableArray *multablePaths = self.paths.mutableCopy;
            [multablePaths removeObjectAtIndex:indexPath.row];
            self.paths = multablePaths.copy;
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

@end
