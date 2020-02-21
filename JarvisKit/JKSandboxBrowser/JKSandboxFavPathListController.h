//
//  JKSandboxFavPathListController.h
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/20.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKSandboxFavPathListController : JKTableViewController

@property(nonatomic, copy, nullable) void (^selectFavoritePathCompletion)(JKSandboxFavPathListController *favPathListController, NSString *selectedPath);

@end

NS_ASSUME_NONNULL_END
