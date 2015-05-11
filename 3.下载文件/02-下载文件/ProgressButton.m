//
//  ProgressButton.m
//  02-下载文件
//
//  Created by apple on 15/4/28.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "ProgressButton.h"

@implementation ProgressButton

- (void)setProgress:(float)progress {
    _progress = progress;
    
    // 设置按钮标题
    [self setTitle:[NSString stringWithFormat:@"%.02f%%", 100 * progress] forState:UIControlStateNormal];
    
    // 自动调用 drawRect，永远不要直接调用 drawRect 方法
    [self setNeedsDisplay];
}

// 提问：rect参数是什么？self.bounds
- (void)drawRect:(CGRect)rect {

    NSLog(@"rect %@", NSStringFromCGRect(rect));
    
    // 画圆弧 － 使用 贝塞尔路径
    /**
     参数：
     1. 圆心
     2. 半径
     3. 起始角度
     4. 结束角度
     5. 是否顺时针
     
     self.center 的 x,y 是相对父视图的坐标
     */
    CGSize s = rect.size;
    CGPoint center = CGPointMake(s.width * 0.5, s.height * 0.5);
    CGFloat r = (MIN(s.width, s.height) - self.lineWidth) * 0.5;
    CGFloat start = -M_PI_2;
    CGFloat end = 2 * M_PI * self.progress + start;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:r startAngle:start endAngle:end clockwise:YES];
    
    // 设置绘图属性
    path.lineWidth = self.lineWidth;
    path.lineCapStyle = kCGLineCapRound;
    
    // 设置颜色
    [self.lineColor setStroke];
    
    // 绘制路径边线
    [path stroke];
}

@end
