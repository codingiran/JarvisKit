//
//  JKTableViewController.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/11.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 遵循协议可以直接获取到搜索的文字
@protocol JKTableViewSearchResultUpdating <NSObject>

@required;
- (void)searchResultsForTableView:(UITableView *)tableView updatingResult:(NSString *)resultString;

@end

@interface JKTableViewController : JKViewController<UITableViewDelegate, UITableViewDataSource>

/**
 使用方法与系统的UITableViewConroller类似
 */
@property(nonatomic, strong, readonly) UITableView *tableView;
@property(nonatomic, assign, readonly) UITableViewStyle tableViewStyle;

/**
 如果设置为YES，提供SearchController支持，默认为NO
 */
@property(nonatomic, assign) BOOL shouldShowSearchBar;
@property(nonatomic, strong, readonly, nullable) UISearchController *searchController;// 只有开启了shouldShowSearchBar才有值，否则为nil
@property(nonatomic, assign) BOOL isSearchActive;// 搜索是否启动
@property(nonatomic, assign) BOOL searchBarHasText;// 搜索框内是否有文字

/// 初始化方法
- (instancetype)initWithStyle:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;

@end

@interface JKTableViewController (JK_SubclassingHooks)

/**
 初始化tableView，在initSubViews的时候被自动调用。
 一般情况下，有关tableView的设置属性的代码都应该写在这里。
 */
- (void)jk_initTableView NS_REQUIRES_SUPER;

/**
 布局 tableView 的方法独立抽取出来，方便子类在需要自定义 tableView.frame 时能重写并且屏蔽掉 super 的代码。如果不独立一个方法而是放在 viewDidLayoutSubviews 里，子类就很难屏蔽 super 里对 tableView.frame 的修改。
 默认的实现是撑满 self.view，如果要自定义，可以写在这里而不调用 super，或者干脆重写这个方法但留空
 */
- (void)jk_layoutTableView;

@end


NS_ASSUME_NONNULL_END
