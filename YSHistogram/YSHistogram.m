//
//  YSHistogram.m
//  YSHistogramView
//
//  Created by Aaron on 2020/4/17.
//  Copyright © 2020 Aaron. All rights reserved.
//

#import "YSHistogram.h"

@interface YSHistogram ()

@property (nonatomic, strong) UILabel * axis_X;
@property (nonatomic, strong) UILabel * axis_Y;

@property (nonatomic, strong) UIButton * btn_CashBaseView;

@property (nonatomic, strong) UIView * view_Value;
@property (nonatomic, strong) UILabel * label_ValueRange; ///范围
@property (nonatomic, strong) UILabel * label_count; ///数量
@property (nonatomic, strong) NSMutableArray * array_RangeList; ///范围的数组

@property (nonatomic, assign) CGFloat Intercal_Y_Height;

@property (nonatomic, strong) NSArray * array_Count_List; ///柱状图所包含的数据量

@property (nonatomic, assign) int selectedLine; ///当前选中的柱状图的index

@end

@implementation YSHistogram

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        [self createValueView];
    }
    return self;
}

- (void)createValueView {
    _view_Value = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
    _view_Value.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.5];
    _view_Value.layer.cornerRadius = 10;
    _view_Value.layer.masksToBounds = YES;
    _view_Value.hidden = YES;
    [self addSubview:_view_Value];
    
    _label_ValueRange = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_view_Value.frame), CGRectGetHeight(_view_Value.frame)/2.0)];
    _label_ValueRange.textColor = [UIColor whiteColor];
    _label_ValueRange.font = [UIFont systemFontOfSize:12];
    [_view_Value addSubview:_label_ValueRange];
    
    UIView * subView = [[UIView alloc] initWithFrame:CGRectMake(10, 25+5, 8, 8)];
    subView.backgroundColor = [UIColor whiteColor];
    subView.layer.cornerRadius = 8/2.0;
    subView.layer.masksToBounds = YES;
    [_view_Value addSubview:subView];
    
    _label_count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subView.frame)+5, CGRectGetMidY(subView.frame)-15/2, CGRectGetWidth(_view_Value.frame)-CGRectGetMaxX(subView.frame)-5, 15)];
    _label_count.textColor = [UIColor whiteColor];
    _label_count.font = [UIFont systemFontOfSize:12];
    [_view_Value addSubview:_label_count];
}

- (void)setUI {
    self.backgroundColor = [UIColor clearColor];
    
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 50)];
    _labelTitle.text = @"Temperature Distribution";
    _labelTitle.textColor = [UIColor blackColor];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_labelTitle];
    
    [self createLineForX_Y];
}

- (void)createLineForX_Y {
    /*Y轴*/
    _axis_Y = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_labelTitle.frame), 1, CGRectGetHeight(self.frame)-50-50)];
    _axis_Y.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_axis_Y];
    
    UILabel * label_Y_Zero = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_axis_Y.frame)-15, 25, 20)];
    label_Y_Zero.textAlignment = NSTextAlignmentRight;
    label_Y_Zero.font = [UIFont systemFontOfSize:13];
    label_Y_Zero.text = @"0";
    [self addSubview:label_Y_Zero];
    
    /*X轴*/
    _axis_X = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_axis_Y.frame), CGRectGetMaxY(_axis_Y.frame), CGRectGetWidth(self.frame)-CGRectGetMaxX(_axis_Y.frame)-20, 1)];
    _axis_X.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_axis_X];
    
    /*Y轴 分割线*/
    CGFloat x_YAxis = CGRectGetMaxX(_axis_Y.frame);
    CGFloat width_YAxis = CGRectGetWidth(_axis_X.frame)-1;
    CGFloat height_YAxis = 1.0;
    
    CGFloat Y_Height = (CGRectGetHeight(_axis_Y.frame) / 5.5); ///Y轴分割线的间隔
    _Intercal_Y_Height = Y_Height;
    
    CGFloat y_YAxis = (Y_Height / 2.0) + CGRectGetMinY(_axis_Y.frame);
    
    
    
    for (int i = 0; i < 5; i++) {
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(x_YAxis, y_YAxis, width_YAxis, height_YAxis)];
        line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.3];
        [self addSubview:line];
        y_YAxis = CGRectGetMinY(line.frame) + Y_Height;
        
        UILabel * lable_YAxis = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)-10, CGRectGetMinX(line.frame)-6, 20)];
        lable_YAxis.textAlignment = NSTextAlignmentRight;
        lable_YAxis.font = [UIFont systemFontOfSize:13];
        lable_YAxis.text = [NSString stringWithFormat:@"%d", i];
        ///FIXME: - “Y轴 坐标” 的Tag 从300开始
        lable_YAxis.tag = 300 + i;
        [self addSubview:lable_YAxis];
    }
    
    /*X轴 柱状图*/
    
    CGFloat x_XAxis = CGRectGetMaxX(_axis_Y.frame);
    CGFloat y_XAxis = CGRectGetMinY(_axis_Y.frame);
    CGFloat width_XAxis = (CGRectGetWidth(_axis_X.frame) - 1) / 9;
    CGFloat height_XAxis = CGRectGetHeight(_axis_Y.frame);
    for (int i = 0; i < 9; i++) {
        /*1.选中框*/
        UIButton * view_Base = [[UIButton alloc] initWithFrame:CGRectMake(x_XAxis, y_XAxis, width_XAxis, height_XAxis)];
        view_Base.backgroundColor = [UIColor clearColor];
        [view_Base setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [view_Base setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self addSubview:view_Base];
        x_XAxis = CGRectGetMaxX(view_Base.frame);
        [view_Base addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
        
        /*2.柱状图*/
        CGFloat height = i*20;
        UIView * view_sub = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(view_Base.frame)-10, CGRectGetMinY(_axis_X.frame)-height, 20, height)];
        view_sub.backgroundColor = [UIColor blueColor];
        view_sub.userInteractionEnabled = NO;
        ///FIXME: - “柱状图” 的Tag 从200开始
        view_sub.tag = 200+i;
        [self addSubview:view_sub];
        
        /*范围*/
        UILabel * label_XAxis = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(view_Base.frame), CGRectGetMaxY(_axis_X.frame), width_XAxis, CGRectGetHeight(self.frame)-CGRectGetMaxY(_axis_X.frame))];
        label_XAxis.numberOfLines = 0;
        label_XAxis.font = [UIFont systemFontOfSize:10];
        ///FIXME: - “X轴先发 范围控件” 的Tag 从100开始
        label_XAxis.tag = 100+i;
        [self addSubview:label_XAxis];
        
        NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        //行间距
        paraStyle.lineSpacing = 10.0;
        //使用
        //文本段落样式
        textDict[NSParagraphStyleAttributeName] = paraStyle;
        label_XAxis.attributedText = [[NSAttributedString alloc] initWithString:@"00:00\n00:00" attributes:textDict];
        label_XAxis.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)selectedAction:(UIButton *)sender {
    _view_Value.hidden = NO;
    
    [_btn_CashBaseView setSelected:NO];
    _btn_CashBaseView.backgroundColor = [UIColor clearColor];
    
    [sender setSelected:YES];
    sender.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.3];
    _btn_CashBaseView = sender;
    /*Tag 200+ */
    int index = [sender.titleLabel.text intValue];
    _selectedLine = index;
    UIView * subView = (UIView *)[self viewWithTag:200+index];
    
    CGFloat width = CGRectGetWidth(_view_Value.frame);
    CGFloat height = CGRectGetHeight(_view_Value.frame);
    CGFloat x = CGRectGetMidX(subView.frame)-width/2;
    CGFloat y = CGRectGetMinY(subView.frame)+20;
    
    
    CGFloat oring_AxisX_y = CGRectGetMinY(_axis_X.frame);
    if (oring_AxisX_y < y+height) {
        y = oring_AxisX_y-height-10;
    }
    
    _view_Value.frame = CGRectMake(x, y, width, height);
    
    [self upLoadValueView];
}

/*更新数据显示框的内容*/
- (void)upLoadValueView {
    /*范围*/
    NSString * str_ValueRange = _array_RangeList[_selectedLine];
    NSArray * array = [str_ValueRange componentsSeparatedByString:@"\n"];
    _label_ValueRange.text = [NSString stringWithFormat:@"%@~%@", array.firstObject, array.lastObject];
    
    /*数量*/
    _label_count.text = [NSString stringWithFormat:@"%u", [_array_Count_List[_selectedLine] unsignedIntValue]];
}

- (void)upLoadWithDataList:(NSMutableArray *)dataList WithMaxValue:(CGFloat)maxValue WithMinValue:(CGFloat)minValue {
    /*1-X轴 坐标*/
    CGFloat interval_XAxis = (maxValue - minValue) / 9.0;
    _array_RangeList = [NSMutableArray array];
    ///富文本
    NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paraStyle.lineSpacing = 10.0;
    //文本段落样式
    textDict[NSParagraphStyleAttributeName] = paraStyle;
    for (int i = 0; i < 9; i++) {
        CGFloat fistNum = minValue + i*interval_XAxis;
        CGFloat lastNum = minValue + (i+1)*interval_XAxis;
        NSString * str = [NSString stringWithFormat:@"%.2f\n%.2f", fistNum, lastNum];
        [_array_RangeList addObject:str];
        
        UILabel * label_XAxis = (UILabel *)[self viewWithTag:100+i];
        label_XAxis.attributedText = [[NSAttributedString alloc] initWithString:str attributes:textDict];
        label_XAxis.textAlignment = NSTextAlignmentCenter;
    }
    
    /*2-柱状图数据分组*/
    NSMutableArray * arry_0 = [NSMutableArray array];
    NSMutableArray * arry_1 = [NSMutableArray array];
    NSMutableArray * arry_2 = [NSMutableArray array];
    NSMutableArray * arry_3 = [NSMutableArray array];
    NSMutableArray * arry_4 = [NSMutableArray array];
    NSMutableArray * arry_5 = [NSMutableArray array];
    NSMutableArray * arry_6 = [NSMutableArray array];
    NSMutableArray * arry_7 = [NSMutableArray array];
    NSMutableArray * arry_8 = [NSMutableArray array];
    
    for (NSMutableDictionary * dic in dataList) {
        CGFloat value = [dic[@"value"] floatValue];
        if ((value >= minValue + interval_XAxis*0) && (value < minValue + interval_XAxis*1)) {
            [arry_0 addObject:dic];
        } else if ((value >= minValue + interval_XAxis*1) && (value < minValue + interval_XAxis*2)) {
            [arry_1 addObject:dic];
        } else if ((value >= minValue + interval_XAxis*2) && (value < minValue + interval_XAxis*3)) {
            [arry_2 addObject:dic];
        } else if ((value >= minValue + interval_XAxis*3) && (value < minValue + interval_XAxis*4)) {
            [arry_3 addObject:dic];
        } else if ((value >= minValue + interval_XAxis*4) && (value < minValue + interval_XAxis*5)) {
            [arry_4 addObject:dic];
        } else if ((value >= minValue + interval_XAxis*5) && (value < minValue + interval_XAxis*6)) {
            [arry_5 addObject:dic];
        } else if ((value >= minValue + interval_XAxis*6) && (value < minValue + interval_XAxis*7)) {
            [arry_6 addObject:dic];
        } else if ((value >= minValue + interval_XAxis*7) && (value < minValue + interval_XAxis*8)) {
            [arry_7 addObject:dic];
        } else if ((value >= minValue + interval_XAxis*8) && (value <= minValue + interval_XAxis*9)) {
            [arry_8 addObject:dic];
        }
    }
    
    /*3-Y轴 坐标*/
    _array_Count_List = @[@(arry_0.count),
                                   @(arry_1.count),
                                   @(arry_2.count),
                                   @(arry_3.count),
                                   @(arry_4.count),
                                   @(arry_5.count),
                                   @(arry_6.count),
                                   @(arry_7.count),
                                   @(arry_8.count)];
    NSUInteger interval_YAxis = [self getIntercalForYAxisWithArray:_array_Count_List];
    for (int i = 4; i >=0; i--) {
        UILabel * lable_YAxis = (UILabel *)[self viewWithTag:300+i];
        lable_YAxis.text = [NSString stringWithFormat:@"%lu", interval_YAxis*(5-i)];
    }
    
    /*4-根据Y轴坐标 刷新柱状图 CGRectMake(CGRectGetMidX(view_Base.frame)-10, CGRectGetMinY(_axis_X.frame)-height, 20, height)*/
    NSUInteger Max_Num_Y = interval_YAxis*5; ///Y轴 最大的坐标
    NSUInteger All_Height = _Intercal_Y_Height*5; ///Y轴 最大的坐标 对应的高度
    
    for (int i = 0; i < 9; i++) {
        NSUInteger num = [_array_Count_List[i] unsignedIntValue];
        CGFloat percentage = num*1.0 / Max_Num_Y*1.0; ///比例
        CGFloat height = All_Height*1.0 * percentage; ///柱状图高度
        UIView * view_sub = (UIView *)[self viewWithTag:200+i];
        CGFloat x = view_sub.frame.origin.x;
        CGFloat width = view_sub.frame.size.width;
        view_sub.frame = CGRectMake(x, CGRectGetMinY(_axis_X.frame)-height, width, height);
    }
    
    [self upLoadValueView];
}

/*获取Y轴 坐标的间隔
{1, 5, 10, 25, 30,40, 50,60,80, 100, 150, 200, 250, 500, 1000, 2000, 3000, 4000, 5000,6000,10000,20000,50000};
 */
- (NSUInteger)getIntercalForYAxisWithArray:(NSArray *)array {
    NSUInteger max =[[array valueForKeyPath:@"@max.floatValue"] unsignedIntValue];
    
    NSArray * list = @[[NSNumber numberWithUnsignedInt:1],
                       [NSNumber numberWithUnsignedInt:5],
                       [NSNumber numberWithUnsignedInt:10],
                       [NSNumber numberWithUnsignedInt:25],
                       [NSNumber numberWithUnsignedInt:30],
                       [NSNumber numberWithUnsignedInt:40],
                       [NSNumber numberWithUnsignedInt:50],
                       [NSNumber numberWithUnsignedInt:60],
                       [NSNumber numberWithUnsignedInt:80],
                       [NSNumber numberWithUnsignedInt:100],
                       [NSNumber numberWithUnsignedInt:150],
                       [NSNumber numberWithUnsignedInt:200],
                       [NSNumber numberWithUnsignedInt:250],
                       [NSNumber numberWithUnsignedInt:500],
                       [NSNumber numberWithUnsignedInt:1000],
                       [NSNumber numberWithUnsignedInt:2000],
                       [NSNumber numberWithUnsignedInt:3000],
                       [NSNumber numberWithUnsignedInt:4000],
                       [NSNumber numberWithUnsignedInt:5000],
                       [NSNumber numberWithUnsignedInt:6000],
                       [NSNumber numberWithUnsignedInt:10000],
                       [NSNumber numberWithUnsignedInt:20000],
                       [NSNumber numberWithUnsignedInt:50000]];
    NSUInteger interval_YAxis = 100;
    for (NSNumber * num in list) {
        NSUInteger interval = [num unsignedIntValue];
        if (interval*5 >= max) {
            interval_YAxis = interval;
            break;
        }
    }
    return interval_YAxis;
}

- (void)closeValueView {
    _view_Value.hidden = YES;
    [_btn_CashBaseView setSelected:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
