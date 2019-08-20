//
//  KSegmentControl.h
//  VT
//
//  Created by YTX-Kim on 2019/7/29.
//  Copyright © 2019 YTX-Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KControlParameters : NSObject

/**
 选中的标题字体颜色
 @{ NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:15], NSForegroundColorAttributeName: [UIColor blackColor] }
 */
@property (nonatomic, copy) NSDictionary *selectedTitleAttributes;

/**
 默认的标题字体颜色
 @{ NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:15], NSForegroundColorAttributeName: [UIColor blackColor] }
 */
@property (nonatomic, copy) NSDictionary *titleAttributes;

/**
 底部滑块的展示
 */
@property (nonatomic, assign) BOOL sliderDisplay;

/**
 底部滑块的颜色
 */
@property (nonatomic, strong) UIColor *sliderColor;

/**
 底部滑块的宽度
 */
@property (nonatomic, assign) CGFloat sliderWidth;

/**
 底部滑块的高度
 */
@property (nonatomic, assign) CGFloat sliderHeight;

/**
 分割线：默认显示
 */
@property (nonatomic, assign) BOOL separatorDisplay;

@end

@interface KSegmentControl : UIView

@property (nonatomic, copy) void (^ didSelectedBlock)(NSInteger index);

+ (instancetype)segmentControlWith:(KControlParameters *)parameters titles:(NSArray<NSString *> *)titles;

/**
 当前的index
 */
@property (nonatomic, assign) NSInteger selectedIndex;

@end
