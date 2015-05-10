//
//  DownloadOperation.m
//  02-下载文件
//
//  Created by apple on 15/4/28.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "DownloadOperation.h"

// 但是：NSURLConnectionDownloadDelegate不能用
// 是为了 Newsstand(电子杂志) Kit’s 创建的 NSURLConnection 服务的
// 国外很多，国内极少！ISBN 苹果要求，电子出版物必须要有独立的书号！
// *** 使用这个代理方法，只能跟踪下载进度，但是无法获得下载完成的文件
@interface DownloadOperation() <NSURLConnectionDataDelegate>
// 文件的总长度
@property (nonatomic, assign) long long expectedContentLength;
// 文件已经下载的长度
@property (nonatomic, assign) long long fileSize;
// 目标文件名
@property (nonatomic, copy) NSString *filePath;
// 文件"流"
/**
 写入流
 - (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len;
 打开流，写入之前，一定要打开
 - (void)open;
 写入完成之后，一定要关闭
 - (void)close;
 */
@property (nonatomic, strong) NSOutputStream *fileStream;

#pragma mark - 记录下载相关属性
// 下载的 URL
@property (nonatomic, strong) NSURL *url;
// 下载进度，提示：参数只需要类型即可
@property (nonatomic, copy) void (^progressBlock)(float);
@property (nonatomic, copy) void (^finishedBlock)(NSString *, NSError *);

// 下载连接
@property (nonatomic, strong) NSURLConnection *conn;
@end

@implementation DownloadOperation

void demo(int num) {
    
}

#define kTimeOut 30.0

/**
 如果当前方法不执行 block，则需要使用属性记录
 */
+ (instancetype)downloadWithURL:(NSURL *)url progress:(void (^)(float))progress finished:(void (^)(NSString *, NSError *))finished {
   
    NSAssert(finished, @"必须传递 finisehd 回调代码");
    
    DownloadOperation *d = [[self alloc] init];
    
    // 记录属性
    d.url = url;
    d.progressBlock = progress;
    d.finishedBlock = finished;

    return d;
}

// 自定义操作，重写了main方法，在当操作被添加到队列的时候，会自动被执行
- (void)main {
    // 自定义操作千万不要忘记自动释放池
    @autoreleasepool {
        // 执行下载
        [self download];
    }
}

/**
 异步方法存在的问题
 
 1. 没有进度跟进，用户体验不好
 2. 会存在内存峰值！
 
 异步方法：iOS 5.0 推出的
 在之前或者做复杂的网络操作，需要通过"代理"来实现！“黑暗年代”
 */
- (void)download {
    
    // 1. 获取服务器文件信息
    [self remoteFileInfo:self.url];
    
    NSLog(@"%lld %@ %@", self.expectedContentLength, self.filePath, [NSThread currentThread]);
    
    // 2. 检查本地文件大小
    self.fileSize = [self localFileInfo];
    
    // 2.1 判断文件是否下载完成
    if (self.fileSize == self.expectedContentLength) {
        
        // 直接调用完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            // 直接告诉调用方，完成百分百
            if (self.progressBlock) {
                self.progressBlock(1.0);
            }
            
            self.finishedBlock(self.filePath, nil);
        });
        
        return;
    }

    // 3. 下载文件
    // 3.1. request，提示：断点续传一定不能使用缓存
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:1 timeoutInterval:kTimeOut];

    // 3.2 设置断点续传的请求头
    NSString *rangeStr = [NSString stringWithFormat:@"bytes=%lld-", self.fileSize];
    [request setValue:rangeStr forHTTPHeaderField:@"Range"];
    
    // 4. 异步连接
    // 创建网络连接并且开始加载数据，数据的加载事件，通过代理监听
    self.conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    // 开启运行循环 － 会进入死循环状态，在网络连接断开后，运行循环自动停止！
    [[NSRunLoop currentRunLoop] run];
    
    NSLog(@"come here");
}

/**
 暂停当前下载
 */
- (void)pause {
    // After this method is called, the connection makes no further delegate method calls. If you want to reattempt the connection, you should create a new connection object.
    // 一旦取消了连接，代理方法将不会再被调用
    // 如果视图再次连接，需要创建新的连接对象！
    [self.conn cancel];
}

// 建议：不要在主方法中，写太多的碎代码
- (long long)localFileInfo {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 1. 判断本地文件是否存在
    long long fileSize = 0;
    
    if ([manager fileExistsAtPath:self.filePath]) {
        // 检查本地文件的大小 － fileSize
        NSDictionary *attr = [manager attributesOfItemAtPath:self.filePath error:NULL];
//        NSLog(@"%lld", [attr[NSFileSize] longLongValue]);
        // 针对文件属性的分类方法
        fileSize = attr.fileSize;
    }
    
    // 判断是否比服务器大
    if (fileSize > self.expectedContentLength) {
        // 删除文件
        [manager removeItemAtPath:self.filePath error:NULL];
        
        // 将文件大小设置为 0
        fileSize = 0;
    }
    
    NSLog(@"本地文件大小 %lld", fileSize);
    
    return fileSize;
}

/**
 *  检查远程服务器文件信息
 */
- (void)remoteFileInfo:(NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:kTimeOut];
    request.HTTPMethod = @"HEAD";
    
    // 发送网络连接，使用同步方法
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    
    // 1. 服务器文件大小
    self.expectedContentLength = response.expectedContentLength;
    // 2. 记录保存文件的路径(临时文件夹中)
    self.filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
}

#pragma mark - 代理方法
// 1. 接收到服务器的响应 - 给的一个回执，可以做准备工作
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"%@", response);
    
    // 实例化文件输出流（追加）
    self.fileStream = [[NSOutputStream alloc] initToFileAtPath:self.filePath append:YES];
    // 打开流
    [self.fileStream open];
}

// 2. 接收到服务器返回的二进制数据，会执行很多次
/**
 tu 可以自动适配无符号整数
 zd 可以自动适配有符号整数
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    NSLog(@"每次获取的数据长度 %tu", data.length);
    
    self.fileSize += data.length;
    float progress = (float)self.fileSize / self.expectedContentLength;
    
//    NSLog(@"%f %@", progress, [NSThread currentThread]);
    
    // 将 data 的所有字节直接写入磁盘，建议使用流的方式操作文件，比 NSFileHandle 要简单一些！
    [self.fileStream write:data.bytes maxLength:data.length];
    
    // 进度回调
    if (self.progressBlock) {
        // 执行block
        self.progressBlock(progress);
    }
}

// 3. 接收完成－只有 connection，没有数据，服务器通知客户端传输完毕，代理方法结束后，连接自动断开！
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"OK");
    
    // 完成之后，关闭流
    [self.fileStream close];
    
    // 完成回调
    dispatch_async(dispatch_get_main_queue(), ^{
        self.finishedBlock(self.filePath, nil);
    });
}

// 4. 接收错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    
    // 完成之后，关闭流
    [self.fileStream close];
    
    // 完成回调
    dispatch_async(dispatch_get_main_queue(), ^{
        self.finishedBlock(nil, error);
    });
}

@end
