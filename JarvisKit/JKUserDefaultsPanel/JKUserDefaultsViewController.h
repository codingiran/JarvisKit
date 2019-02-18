//
//  JKUserDefaultsViewController.h
//  WekidsEducation
//
//  Created by 邱一郎 on 2019/1/4.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MARK: 当使用`NSUserDefaults`进行本地化保存时，实际上是先将需要保存的『键值对』赋予全局单例，然后`NSUserDefaults`在『适当的时机』将值写入沙盒内的Plist文件内...
 * ...想要完整的NSUserDefaults数据必须从沙盒的Plist文件中取到`NSDictionary`，由于『适当时机』的问题，沙盒内Plist文件的增删改与`NSUserDefaults`单例的增删改并不是同步进行的！...
 * ...因此`WEUserDefaultsViewController`一旦从沙盒内获取到`NSDictionary`后就需要维护一份副本，之后所有的增删改查的对象都是此副本而不是沙盒内的Plist文件
 * @warning 另外需要注意的是`NSUserDefaults`的`synchronize`方法已经被废弃，也就是这个强制同步的方法已经无效了，具体@see `NSUserDefaults.h`
 */
@interface JKUserDefaultsViewController : JKTableViewController


@end

NS_ASSUME_NONNULL_END
