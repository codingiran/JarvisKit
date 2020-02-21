//
//  JKFontLineHeightViewController.m
//  WekidsEducation
//
//  Created by CodingIran on 2019/1/9.
//  Copyright © 2019 wekids. All rights reserved.
//

#import "JKFontLineHeightViewController.h"
#import "JKHelper.h"

@interface JKFontLineHeightViewController ()

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UILabel *fontSizeLabel;

@property(nonatomic, strong) UILabel *fontLineHeightLabel;

@property(nonatomic, strong) UISlider *slider;

@property(nonatomic, strong) JKMenuLabel *sampleLabel;

@end

@implementation JKFontLineHeightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // init subviews
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    self.scrollView.alwaysBounceVertical = YES;
    
    self.fontSizeLabel = [UILabel new];
    self.fontSizeLabel.font = [UIFont fontWithName:self.font.fontName size:18];
    self.fontSizeLabel.textColor = [UIColor darkTextColor];
    [self.scrollView addSubview:self.fontSizeLabel];
    
    self.fontLineHeightLabel = [UILabel new];
    self.fontLineHeightLabel.font = [UIFont fontWithName:self.font.fontName size:18];
    self.fontLineHeightLabel.textColor = [UIColor darkTextColor];
    [self.scrollView addSubview:self.fontLineHeightLabel];
    
    self.slider = [[UISlider alloc] init];
    self.slider.minimumValue = 8;
    self.slider.maximumValue = 50;
    self.slider.value = 16;
    self.slider.minimumTrackTintColor = [UIColor colorWithPatternImage:JKImageMake(@"jarvis_navi_bkg")];
    self.slider.maximumTrackTintColor = [UIColor grayColor];
    self.slider.thumbTintColor = self.slider.minimumTrackTintColor;
    self.slider.tintColor = self.slider.minimumTrackTintColor;
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.slider];
    
    self.sampleLabel = [JKMenuLabel new];
    self.sampleLabel.font = [UIFont fontWithName:self.font.fontName size:16];
    self.sampleLabel.textColor = [UIColor lightTextColor];
    self.sampleLabel.backgroundColor = [UIColor colorWithPatternImage:JKImageMake(@"jarvis_navi_bkg")];
    self.sampleLabel.text = self.displayText;
    [self.scrollView addSubview:self.sampleLabel];
    
    [self.view addSubview:self.scrollView];
    
    [self updateLabelsBaseOnSliderForce];
}

- (void)jk_setupNavigationItems
{
    [super jk_setupNavigationItems];
    self.navigationTitle = self.font.fontName;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
    
    CGRect frame = [self.navigationController.navigationBar convertRect:self.navigationController.navigationBar.frame toView:self.navigationController.view];
    self.scrollView.contentSize = CGSizeMake(self.view.jk_width, self.scrollView.jk_height - CGRectGetMaxY(frame));
    
    [self.fontSizeLabel sizeToFit];
    self.fontSizeLabel.frame = CGRectMake(20, 25, self.fontSizeLabel.jk_width, self.fontSizeLabel.jk_height);
    
    [self.fontLineHeightLabel sizeToFit];
    self.fontLineHeightLabel.frame = CGRectMake(self.fontSizeLabel.jk_left, self.fontSizeLabel.jk_bottom + 5, self.fontLineHeightLabel.jk_width, self.fontLineHeightLabel.jk_height);
    
    [self.slider sizeToFit];
    self.slider.frame = CGRectMake(self.fontSizeLabel.jk_left, self.fontLineHeightLabel.jk_bottom + 10, self.view.jk_width - 2 * self.fontSizeLabel.jk_left, self.slider.jk_height);
    
    [self.sampleLabel sizeToFit];
    self.sampleLabel.frame = CGRectMake(self.fontSizeLabel.jk_left, self.slider.jk_bottom + 30, self.view.jk_width - 2 * self.fontSizeLabel.jk_left, self.sampleLabel.jk_height);
}

- (void)updateLabelsBaseOnSliderForce
{
    NSInteger fontSize = (NSInteger)self.slider.value;
    
    self.sampleLabel.font = [UIFont fontWithName:self.font.fontName size:fontSize];
    [self.sampleLabel sizeToFit];
    self.sampleLabel.jk_width = self.view.jk_width - 2 * self.fontSizeLabel.jk_left;
    
    NSInteger lineHeight = (NSInteger)CGRectGetHeight(self.sampleLabel.frame);
    
    self.fontSizeLabel.text = [NSString stringWithFormat:@"字号：%zd", fontSize];
    [self.fontSizeLabel sizeToFit];
    self.fontLineHeightLabel.text = [NSString stringWithFormat:@"行高：%zd", lineHeight];
    [self.fontLineHeightLabel sizeToFit];
}

#pragma mark - touch event
- (void)sliderValueChanged:(UISlider *)slider
{
    [self updateLabelsBaseOnSliderForce];
}


@end
