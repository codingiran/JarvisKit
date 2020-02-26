# JarvisKit
Elegant debug tool for iOS development

## Feature
### App Info

### Performance Check

### Document Browser

### NSUserDefaults Manager

### Network Capture

### Crash Collection

### System Font Browser

### UI Debugger

## Document tree
```
├── JarvisKit
│   ├── JKCore
│   │   ├── JKCommonDefines.h
│   │   ├── JKFloatWindow.h
│   │   ├── JKFloatWindow.m
│   │   ├── JKHelper.h
│   │   ├── JKHelper.m
│   │   ├── JKIronmanWindow.h
│   │   ├── JKIronmanWindow.m
│   │   ├── JKMacro.h
│   │   ├── JKMenuLabel.h
│   │   ├── JKMenuLabel.m
│   │   ├── JKMovableWindowLabel.h
│   │   ├── JKMovableWindowLabel.m
│   │   ├── JKNavigtionController.h
│   │   ├── JKNavigtionController.m
│   │   ├── JKOrderedDictionary.h
│   │   ├── JKOrderedDictionary.m
│   │   ├── JKSegmentView.h
│   │   ├── JKSegmentView.m
│   │   ├── JKSwitchAccessoryCell.h
│   │   ├── JKSwitchAccessoryCell.m
│   │   ├── JKTableViewController.h
│   │   ├── JKTableViewController.m
│   │   ├── JKViewController.h
│   │   ├── JKViewController.m
│   │   ├── JarvisKitManager.h
│   │   ├── JarvisKitManager.m
│   │   ├── JkPresentationWindow.h
│   │   ├── JkPresentationWindow.m
│   │   ├── NSString+JarvisKit.h
│   │   ├── NSString+JarvisKit.m
│   │   ├── UIColor+JarvisKit.h
│   │   ├── UIColor+JarvisKit.m
│   │   ├── UIImage+JarvisKit.h
│   │   ├── UIImage+JarvisKit.m
│   │   ├── UIView+JarvisKit.h
│   │   ├── UIView+JarvisKit.m
│   │   ├── UIViewController+JarvisKit.h
│   │   └── UIViewController+JarvisKit.m
│   ├── JKCrashLog
│   │   ├── JKCrashLogDetailViewController.h
│   │   ├── JKCrashLogDetailViewController.m
│   │   ├── JKCrashLogHelper.h
│   │   ├── JKCrashLogHelper.m
│   │   ├── JKCrashLogListCell.h
│   │   ├── JKCrashLogListCell.m
│   │   ├── JKCrashLogListViewController.h
│   │   ├── JKCrashLogListViewController.m
│   │   ├── JKCrashLogModel.h
│   │   ├── JKCrashLogModel.m
│   │   ├── JKCrashSignalExceptionHandler.h
│   │   ├── JKCrashSignalExceptionHandler.m
│   │   ├── JKCrashUncaughtExceptionHandler.h
│   │   └── JKCrashUncaughtExceptionHandler.m
│   ├── JKDeviceInfo
│   │   ├── JKDeviceInfoHelper.h
│   │   ├── JKDeviceInfoHelper.m
│   │   ├── JKDeviceInfoViewController.h
│   │   └── JKDeviceInfoViewController.m
│   ├── JKNetworkCapture
│   │   ├── JKNetCaptureDataSource.h
│   │   ├── JKNetCaptureDataSource.m
│   │   ├── JKNetCaptureDetailViewController.h
│   │   ├── JKNetCaptureDetailViewController.m
│   │   ├── JKNetCaptureHelper.h
│   │   ├── JKNetCaptureHelper.m
│   │   ├── JKNetCaptureListCell.h
│   │   ├── JKNetCaptureListCell.m
│   │   ├── JKNetCaptureListViewController.h
│   │   ├── JKNetCaptureListViewController.m
│   │   ├── JKNetCaptureModel.h
│   │   ├── JKNetCaptureModel.m
│   │   ├── JKURLProtocol.h
│   │   └── JKURLProtocol.m
│   ├── JKPerformance
│   │   ├── JKCPULabel.h
│   │   ├── JKCPULabel.m
│   │   ├── JKFPSLabel.h
│   │   ├── JKFPSLabel.m
│   │   ├── JKFlowLabel.h
│   │   ├── JKFlowLabel.m
│   │   ├── JKPerformanceHelper.h
│   │   ├── JKPerformanceHelper.m
│   │   ├── JKPerformanceManager.h
│   │   ├── JKPerformanceManager.m
│   │   ├── JKPerformanceSettingController.h
│   │   ├── JKPerformanceSettingController.m
│   │   ├── JKRAMLabel.h
│   │   └── JKRAMLabel.m
│   ├── JKSandboxBrowser
│   │   ├── JKSandboxCell.h
│   │   ├── JKSandboxCell.m
│   │   ├── JKSandboxFavPathListController.h
│   │   ├── JKSandboxFavPathListController.m
│   │   ├── JKSandboxFavPathModel.h
│   │   ├── JKSandboxFavPathModel.m
│   │   ├── JKSandboxFilePreviewViewController.h
│   │   ├── JKSandboxFilePreviewViewController.m
│   │   ├── JKSandboxHelper.h
│   │   ├── JKSandboxHelper.m
│   │   ├── JKSandboxModel.h
│   │   ├── JKSandboxModel.m
│   │   ├── JKSandboxViewController.h
│   │   └── JKSandboxViewController.m
│   ├── JKSystemFontViewer
│   │   ├── JKFontLineHeightViewController.h
│   │   ├── JKFontLineHeightViewController.m
│   │   ├── JKSystemFontViewController.h
│   │   └── JKSystemFontViewController.m
│   ├── JKUserDefaultsPanel
│   │   ├── JKUserDefaultsHelper.h
│   │   ├── JKUserDefaultsHelper.m
│   │   ├── JKUserDefaultsModel.h
│   │   ├── JKUserDefaultsModel.m
│   │   ├── JKUserDefaultsValueCell.h
│   │   ├── JKUserDefaultsValueCell.m
│   │   ├── JKUserDefaultsViewController.h
│   │   └── JKUserDefaultsViewController.m
│   └── UIElementToolBox
│       ├── C
│       ├── JKMagnifierLayer.h
│       ├── JKMagnifierLayer.m
│       ├── JKMagnifierView.h
│       ├── JKMagnifierView.m
│       ├── JKUIElementToolHelper.h
│       ├── JKUIElementToolHelper.m
│       ├── JKUIElementToolManager.h
│       ├── JKUIElementToolManager.m
│       ├── JKUIElementToolSettingController.h
│       ├── JKUIElementToolSettingController.m
│       └── V
├── JarvisKit.podspec
├── LICENSE
└── README.md
```