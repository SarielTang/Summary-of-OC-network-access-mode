//
//  DownloadManager.h
//  02-下载文件
//
//  Created by apple on 15/4/28.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 下载管理器，负责管理所有的下载操作，可以控制最大并发的操作数！
 
 通常，为了方便其他程序的调用，管理工具会设计成单例
 
 开发步骤：
 1. 实现单例
 2. 接管下载操作，当前实现的功能！
 */
@interface DownloadManager : NSObject

+ (instancetype)sharedManager;

// 下载的主方法
- (void)downloadWithURL:(NSURL *)url progress:(void (^)(float progress))progress finished:(void (^)(NSString *filePath, NSError *error))finished;

// 暂停指定 URL 的下载操作
- (void)pauseWithURL:(NSURL *)url;

@end
