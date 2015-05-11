//
//  ProgressButton.h
//  02-下载文件
//
//  Created by apple on 15/4/28.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

// IB_DESIGNABLE 表示当前视图的属性，可以在 Interface Builder 直接设计视图
IB_DESIGNABLE
@interface ProgressButton : UIButton

// 下载进度，数值 0.0~1.0
@property (nonatomic, assign) IBInspectable float progress;
// 线宽
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;
// 线条颜色
@property (nonatomic, strong) IBInspectable UIColor *lineColor;

@end
