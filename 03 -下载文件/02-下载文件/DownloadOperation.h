//
//  DownloadOperation.h
//  02-下载文件
//
//  Created by apple on 15/4/28.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 假定，一个 DownloadOperation 对象负责一个文件的下载操作
 
 block
 1. C语言的
 2. 提前准备好的代码，在需要的时候执行
 3. 可以当作参数传递以及保存
 
 关于网络框架(AFN，SDWebImage...)回调的细节
 
 1. 进度回调，通常在异步执行
    1> 通常进度回调的频率非常高！如果界面上有很多文件，同时下载，又要更新 UI，可能会造成界面的卡顿
    2> 让进度回调，在异步执行，可以有选择的处理进度的显示，例如：只显示一个菊花！
    3> 有些时候，如果文件很小，调用方通常不关心下载进度！(SDWebImage)
    4> 异步回调，可以降低对主线程的压力
 
 2. 完成回调，通常在主线程执行
    1> 调用方不用考虑线程间通讯，直接更新UI即可
    2> 完成只有一次
 */
@interface DownloadOperation : NSOperation

/**
 下载需要的参数
 
 1. 下载文件的 URL
 2. 下载进度报告(block)
 3. 下载完成（下载的路径）或者失败（错误，失败原因）报告(block)
 */
+ (instancetype)downloadWithURL:(NSURL *)url progress:(void (^)(float progress))progress finished:(void (^)(NSString *filePath, NSError *error))finished;

// 下载
- (void)download;

// 暂停
- (void)pause;

@end
