//
//  DownloadManager.m
//  02-下载文件
//
//  Created by apple on 15/4/28.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "DownloadManager.h"
#import "DownloadOperation.h"

@interface DownloadManager()
@property (nonatomic, strong) NSMutableDictionary *downloadCache;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@end

@implementation DownloadManager

+ (instancetype)sharedManager {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)downloadWithURL:(NSURL *)url progress:(void (^)(float))progress finished:(void (^)(NSString *, NSError *))finished {
    
    // 1. 判断下载是否正在进行
    if (self.downloadCache[url] != nil) {
        NSLog(@"正在玩命下载中....");
        return;
    }
    
    // 2. 实例化下载操作，block 可以当作参数被传递
    DownloadOperation *down = [DownloadOperation downloadWithURL:url progress:progress finished:^(NSString *filePath, NSError *error) {
        
        // 删除下载操作
        [self.downloadCache removeObjectForKey:url];
        
        // 完成的回调
        finished(filePath, error);
    }];
    
    // 3. 将下载操作添加到缓冲池
    [self.downloadCache setObject:down forKey:url];
    
    // 4. 将操作添加到队列
    [self.downloadQueue addOperation:down];
}

- (void)pauseWithURL:(NSURL *)url {
    // 1. 从下载操作缓冲区，查找下载操作
    DownloadOperation *down = self.downloadCache[url];
    
    // 2. 如果没有找到，直接返回
    if (down == nil) {
        NSLog(@"%@", self.downloadQueue.operations);
        NSLog(@"没有要暂停的操作");
        return;
    }
    
    // 3. 暂停操作，操作队列会认为操作已经完成，会自动将操作从操作队列中删除
    [down pause];
    
    // 4. 将下载操作，从缓冲区中删除
    [self.downloadCache removeObjectForKey:url];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)downloadCache {
    if (_downloadCache == nil) {
        _downloadCache = [[NSMutableDictionary alloc] init];
    }
    return _downloadCache;
}

- (NSOperationQueue *)downloadQueue {
    if (_downloadQueue == nil) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        // 控制同时下载的操作数量
        _downloadQueue.maxConcurrentOperationCount = 3;
    }
    return _downloadQueue;
}

@end
