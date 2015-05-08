//
//  BasicRequestWithURLConnection.m
//  网络知识点回顾
//
//  Created by Sariel's Mac on 15-5-6.
//  Copyright (c) 2015年 Sariel. All rights reserved.
//

#import "BasicRequestWithURLConnection.h"

@implementation BasicRequestWithURLConnection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self basicLoadDataMethod];
    [self commenLoadDataMethod];
}

#pragma mark - URLConnection的基本网络访问请求。


#pragma mark 网络访问基本介绍
- (void)basicLoadDataMethod {
    
    // 1. URL（确定要访问的网络资源页面，图片....路径）
    // m 是 mobile 的缩写
    NSURL *url = [NSURL URLWithString:@"http://m.baidu.com"];
    
    // 2. request 请求，向服务器索要数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 建立网络连接，将请求(异步)发送给服务器
    // 多线程的目的就是将耗时操作放在后台，所有的网络请求都是耗时的
    // 几乎所有的网络请求，都应该是异步的
    /**
     1. 请求 － sendAsynchronousRequest 本身就是异步发送的
     2. 队列 － 调度 completionHandler 的队列
     
     关于队列的选择：
     1> 拿到服务器返回的二进制数据是否需要做耗时操作！
     举个栗子：下载一个压缩文件，通常需要先"解压缩"！就可以将"解压缩"工作放在后台
     
     2> 如果拿到的数据直接更新UI，没有任何耗时操作，可以直接用主队列
     
     3. completionHandler － 网络连接执行完毕的回调block，block提前准备好的代码，在需要的时候执行！
     接收到服务器的响应数据后，要执行的代码块
     */
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // 服务器响应已经结束！
        
        // *** 在网络上传输的数据，都是二进制的！
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"%@", data);
        
        // 将二进制数据写入磁盘
        [data writeToFile:@"/Users/apple/Desktop/123" atomically:YES];
        
#warning 面试题0
        // 将二进制数据转换成字符串
        // 提问1: NSString 和 字符串有什么区别？
        // NSString 是 OC 的类，能够存储字符串，并且提供了一系列的字符串访问方法
        //
        // 提问2: 在当前的演练中，NSData 和 NSString 中保存的内容有什么区别？
        // 没有区别！
        // 所有的数据都是以二进制的形式保存在内存中的
        // NSString 提供了字符串的展现形式，以及字符串的操作方法
        // NSData 通常用于网络传输，以及写入文件
        
        /**
         字符编码：NSUTF8StringEncoding
         提示：如果没有特殊指定，在开发中，统一使用 NSUTF8 编码格式！
         
         * UTF8 是 UNICODE 的编码格式，使用 1-4 个字节表示一个字符，中文会使用3个字节
         2 ^ 32 = 4 * 1024 * 1024 * 1024 = 4G ＝ 42亿
         涵盖世界上所有的字符！
         
         * GB2312 字符编码，是国内使用的非常古老的编码方案，有一些老的网站还在使用
         涵盖了常用汉字 6700＋
         中文的所有汉字，85000+
         */
        NSString *xml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", xml);
    }];
    
    NSLog(@"come here");
}

#pragma mark 网络访问常用方式介绍(缓存策略，服务器的响应Response的类型)
- (void)commenLoadDataMethod{
    NSURL *url = [NSURL URLWithString:@"http://192.168.21.110/redir.php"];
    
    // 是同步的，默认超时时长也是 60s
    //    NSData *data = [NSData dataWithContentsOfURL:url];
    //    UIImage *image = [UIImage imageWithData:data];
    
    // 网络访问都是耗时的，需要异步执行
    /**
     参数
     1. url
     2. 缓存策略
     
     NSURLRequestUseProtocolCachePolicy = 0,        // 默认的缓存策略，使用协议的缓存策略
     
     NSURLRequestReload(加载)Ignoring(忽略)LocalCacheData = 1, 对实时性要求高的
     // 忽略本地缓存数据，每次都从服务器上加载
     // 应用场景：股票，彩票
     //         新闻，天气
     
     // 做"离线"开发时使用，可以先判断当前联网状态，然后设置选项！
     // 提示：在实际开发中，不建议使用以下两个选项！
     // 在开发商业应用时，应该把用户拉到网络上来！
     // 广告后面有一套完善的计费系统，展现率，点击率，转换率...
     NSURLRequestReturnCacheDataElseLoad = 2,       // 如果有缓存，返回缓存，否则加载
     NSURLRequestReturnCacheDataDontLoad = 3,       // 如果有缓存，返回缓存，否则不加载
     
     3. 超时时长，默认是 60s，建议改成 15-30s，不要再短了！
     SDWebImage      默认超时时长 15s，最大并发数 6
     AFNetworking    默认超时时长 60s
     */
    // 提示：很多网上的代码，选项部分都会写成 0，目的就是让代码短一点！
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15.0];
    
    /**
     网络连接是异步的
     
     参数
     
     1. request
     2. queue
     3. completionHandler准备好的块代码，在网络访问结束后执行
     
     1> NSURLResponse 服务器的响应，真实类型 NSHTTPURLResponse
     通常只有在开发 "下载" 功能的时候，才会使用
     
     - URL           响应的 URL，有的时候，访问一个 URL 地址，服务器可能会出现重定向，会定位到新的地址！
     - MIMEType(Content-Type)    服务器告诉客户端，可以用什么软件打开二进制数据！
     网络之所以丰富多采，是因为有丰富的客户端软件！
     栗子：windows上提示安装 Flash 插件
     
     - expectedContentLength 预期的内容长度，要下载的文件长度
     - suggestedFilename     "建议"的文件名，方便用户直接保存，很多时候，用户并不关心要保存成什么名字！
     
     - textEncodingName      文本的编码名称 @"UTF8"，大多数都是 UTF8
     
     - statusCode    状态码，在做下载操作的时候，需要判断一下 404
     - allHeaderFields   所有的响应头字典
     
     2> NSData 服务器返回的实体数据，程序员最关心的内容
     
     3> connectionError 连接错误，在商业软件中，所有的网络操作，都必须处理错误！
     */
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // 提示：千万不要给用户详细的错误信息！
        // 有的时候，服务器访问正常，但是会没有数据！
        // 以下的 if 是比较标准的错误 处理代码！
        if (connectionError != nil || data == nil) {
            NSLog(@"网络不给力哦");
            return;
        }
        
        NSLog(@"%@", response);
        
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}

#pragma mark 天气预报（解释了JSON的序列化和反序列化以及参数）
- (void)loadDataWithWeather {
    NSURL *url = [NSURL URLWithString:@"http://www.weather.com.cn/data/sk/101010100.html"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    [request setValue:@"iPhone" forHTTPHeaderField:@"User-Agent"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", result);
        
        // 苹果提供了一个 JSON 根 Foundation 转换的类 NSJSONSerialization
        /**
         Serialization 序列化 － 网络上传输的所有数据都是二进制的
         
         - 序列化    将OC中的对象(数组/字典)发送给服务器之前，转换成二进制数据的过程
         - 反序列化  获得服务器返回的二进制数据后，转换成 OC 对象(数组/字典)的过程，便于后续的字典转模型
         数据解析
         */
        /**
         参数
         
         1. 二进制数据
         2. 选项
         NSJSONReadingMutableContainers = (1UL << 0),   容器可变
         NSJSONReadingMutableLeaves = (1UL << 1),       叶子可变，字符串的会使用 NSMutableString
         NSJSONReadingAllowFragments(片段，碎片) = (1UL << 2)  允许根节点不是数组或者字典，极少见
         
         按位枚举，如果传入 0，执行效率最高，表示不做任何附加操作！
         
         3. 错误，通常传入 NULL 就行，传入nil也可以，不会报错
         */
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@ %@", json, [json class]);
        
        NSLog(@"%@ 的天气 %@ 风向 %@ 风力 %@", json[@"weatherinfo"][@"city"],
              json[@"weatherinfo"][@"temp"],
              json[@"weatherinfo"][@"WD"],
              json[@"weatherinfo"][@"WS"]);
    }];
}


@end
