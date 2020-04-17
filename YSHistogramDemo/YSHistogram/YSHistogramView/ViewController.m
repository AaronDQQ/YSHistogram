//
//  ViewController.m
//  YSHistogramView
//
//  Created by Aaron on 2020/4/3.
//  Copyright © 2020 Aaron. All rights reserved.
//

#import "ViewController.h"

#import "YSHistogram.h"

@interface ViewController ()

@property (nonatomic, strong) YSHistogram * history_chart;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _history_chart = [[YSHistogram alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 363)];
    [self.view addSubview:_history_chart];
    
    NSMutableArray * array = [NSMutableArray array];
    for (CGFloat i = 0.0; i < 1000; i++) {
        [array addObject:@{@"value":[NSNumber numberWithFloat:i]}];
    }
    
    [_history_chart upLoadWithDataList:array WithMaxValue:999.0 WithMinValue:0.0];
    _history_chart.labelTitle.text = @"132456";
}


@end
