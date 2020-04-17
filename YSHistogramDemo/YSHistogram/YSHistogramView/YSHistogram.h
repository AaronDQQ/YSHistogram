//
//  YSHistogram.h
//  YSHistogramView
//
//  Created by Aaron on 2020/4/17.
//  Copyright © 2020 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSHistogram : UIView

/**
 标题
 */
@property (nonatomic, strong) UILabel * labelTitle;

/**
 dataList: 数据源 @[@{@"value": double}]
 maxValue：最大值
 minValue：最小值
 
 总共分9份
 */
- (void)upLoadWithDataList:(NSMutableArray *)dataList WithMaxValue:(CGFloat)maxValue WithMinValue:(CGFloat)minValue;

/**
 关闭柱状图详细信息显示栏
 */
- (void)closeValueView;


@end

NS_ASSUME_NONNULL_END
