# YSHistogram

`pod 'YSHistogram'`


-------

```
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
```
-------


![]()