//
//  SynchronousDownLoad.m
//  网络知识点回顾
//
//  Created by xl_bin on 15/5/10.
//  Copyright (c) 2015年 Sariel. All rights reserved.
//

#import "SynchronousDownLoad.h"

@implementation SynchronousDownLoad

/**
 HEAD 方法，通常用在文件下载之前，获取远程服务器上的文件信息！
 
 可以让用户在下载文件之前，就能够知道文件的准确大小！
 */
- (void)loadData {
    // 1. url
    NSURL *url = [NSURL URLWithString:@"http://192.168.21.110/demo.json"];
    
    // 2. request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:10.0];
    // HTTP 方法
    request.HTTPMethod = @"HEAD";
    
    // 3. 同步方法
    // 提示：凡是看到 ** 的参数，统一传递地址
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    /**
     expectedContentLength  文件长度
     suggestedFilename  建议保存的文件名
     */
    NSLog(@"%@ %lld %@ %@", data, response.expectedContentLength, response.suggestedFilename, response);
}

/**
 NULL & nil 有什么区别
 - NSNull 的目的，就是为了向数组/字典中插入空值 [NSNull null]
 
 - NULL 是 C 语言的，是空地址(数值)，本质上就是 0
 只是一个数字
 - nil  是 OC 的，是空对象，地址指向 NULL 的对象，在 C++/OC 语言中，可以给 地址指向 0 的对象发送消息，不会抱错！
 能够接收消息
 
 提示，在遇到 ** 参数的时候，应该传入 NULL，这样表示对对象和地址的理解是没有问题的！
 
 但是：在 OC 中，为了方便程序员的使用，传入 nil 依然能够正常执行！
 另外，在 Xcode 6 中，取消了 NULL 的智能提示，为了方便 swift 的智能提示！
 而 swift 中，没有 NULL 的概念，统一都是 nil，并且 swift 中，要使用指针，相当的蛋疼！
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    int userId = 10;
    NSString *userName = nil;
    
    [self userInfo:&userId name:&userName];
    
    NSLog(@"%d %@", userId, userName);
    
    NSMutableArray *arrayM = [NSMutableArray array];
    [arrayM addObject:[NSNull null]];
    
    NSLog(@"%@", arrayM);
    
    //    [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
}

/**
 ** 指针的指针，是一个非常古老的技术！
 
 暂时：可以记住发现参数是 **，统一传递地址！
 
 在 C 语言/C++中被广泛使用，目的：让一个函数能够返回多个数值！
 
 让以下方法，返回用户的代号&姓名
 */
- (void)userInfo:(int *)ID name:(NSString **)name {
    
    NSLog(@"==>%d", *ID);
    
    *ID = 100;
    *name = [NSString stringWithFormat:@"zhangsan - %d", 123];
    
    return;
}

@end
