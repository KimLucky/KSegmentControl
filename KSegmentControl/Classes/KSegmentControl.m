//
//  KSegmentControl.m
//  VT
//
//  Created by YTX-Kim on 2019/7/29.
//  Copyright © 2019 YTX-Kim. All rights reserved.
//

#import "KSegmentControl.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

#define SEGMENT_TAG               200200200
#define kSegmentControlWidth      [UIScreen mainScreen].bounds.size.width

#define DefaultAttributed         @{ NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:15], NSForegroundColorAttributeName: [UIColor blackColor] }
#define DefaultSelectedAttributed @{ NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:15], NSForegroundColorAttributeName: [UIColor redColor] }
#define DefaultSliderWidth        20
#define DefaultSliderHeight       2

@implementation KControlParameters
@end

@interface KSegmentControl ()

@property (nonatomic, strong) KControlParameters *parameters;
@property (nonatomic, copy) NSArray<NSString *> *titles;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, strong) UIView *separatorView;

@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) NSMutableArray *masonryArray;

@end

@implementation KSegmentControl

+ (instancetype)segmentControlWith:(KControlParameters *)parameters titles:(NSArray<NSString *> *)titles {
    KSegmentControl *control = [[KSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kSegmentControlWidth, 40)];
    control.parameters = parameters;
    control.titles = [titles copy];
    [control setupConfig];
    return control;
}

- (void)setupConfig {
    [self addSubview:self.contentView];
    [self setupUI];
    
    if (self.parameters.separatorDisplay) {
        [self addSubview:self.separatorView];
    }
    
    if (self.parameters.sliderDisplay) {
        [self addSubview:self.sliderView];
    }
    [self sliderScrollWithAnimation:NO];
}

#pragma mark - action
- (void)segmentChanged:(UIButton *)button {
    self.selectedIndex = button.tag - SEGMENT_TAG;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.masonryArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.masonryArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.contentView);
    }];
    
    if (self.parameters.separatorDisplay) {
        [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(1));
        }];
    }
    
    if (self.parameters.sliderDisplay) {
//        CGFloat iW = (self.parameters.controlWidth?:kSegmentControlWidth) / self.titles.count;
        CGFloat iW = (self.bounds.size.width) / self.titles.count;
        CGFloat p = iW * (self.selectedIndex + 0.5) - (self.parameters.sliderWidth ? : DefaultSliderWidth)/2;
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(p);
            make.bottom.equalTo(self);
            make.width.equalTo(@(self.parameters.sliderWidth ? : DefaultSliderWidth));
            make.height.equalTo(@(self.parameters.sliderHeight ? : DefaultSliderHeight));
        }];
    }
}

#pragma mark - set
- (void)setupUI {
    while (self.contentView.subviews.count)
        [self.contentView.subviews.lastObject removeFromSuperview];

    for (int i = 0; i < self.titles.count; i++) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.titles[i] attributes:self.parameters.titleAttributes ? : DefaultAttributed];
        NSAttributedString *selectedAttributedString = [[NSAttributedString alloc] initWithString:self.titles[i] attributes:self.parameters.selectedTitleAttributes ? : DefaultSelectedAttributed];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setAttributedTitle:attributedString forState:UIControlStateNormal];
        [button setAttributedTitle:selectedAttributedString forState:UIControlStateSelected];
        [button addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        button.tag = SEGMENT_TAG + i;

        if (i == 0) {
            _selectedIndex = 0;
            _selectedButton = button;
            _selectedButton.selected = YES;
        }
        [self.masonryArray addObject:button];
    }
}

- (void)setSelectedButton:(UIButton *)selectedButton {
    _selectedButton.selected = NO;
    selectedButton.selected = YES;

    _selectedButton = selectedButton;

    [self sliderScrollWithAnimation:YES];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    _selectedIndex = selectedIndex;
    UIButton *selectedButton = (UIButton *)[self.contentView viewWithTag:SEGMENT_TAG + selectedIndex];
    self.selectedButton = selectedButton;

    if (self.didSelectedBlock) {
        self.didSelectedBlock(selectedIndex);
    }
}

- (void)sliderScrollWithAnimation:(BOOL)animation {
    if (self.parameters.sliderDisplay) {
        CGFloat duration = animation ? 0.2 : 0;
        [UIView animateWithDuration:duration animations:^{
            CGFloat iW = (self.bounds.size.width) / self.titles.count;
//            CGFloat iW = (self.parameters.controlWidth?:kSegmentControlWidth) / self.titles.count;
            CGFloat p = iW * (self.selectedIndex + 0.5);
            self.sliderView.center = CGPointMake(p, self.sliderView.center.y);
        }];
    }
}

#pragma mark - get
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.parameters.sliderWidth ? : DefaultSliderWidth, self.parameters.sliderHeight ? : DefaultSliderHeight)];
        _sliderView.backgroundColor = self.parameters.sliderColor ? : [UIColor redColor];
    }
    return _sliderView;
}

- (NSMutableArray *)masonryArray {
    if (!_masonryArray) {
        _masonryArray = [NSMutableArray array];
    }
    return _masonryArray;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = [UIColor lightGrayColor];
    }
    return _separatorView;
}

@end
