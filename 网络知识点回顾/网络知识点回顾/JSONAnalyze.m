//
//  JSONAnalyze.m
//  网络知识点回顾
//
//  Created by Sariel's Mac on 15-5-6.
//  Copyright (c) 2015年 Sariel. All rights reserved.
//

#import "JSONAnalyze.h"
//#import "JSONKit.h"

@implementation JSONAnalyze

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self appleJSON];
}

/**
 第三方框架使用起来非常容易，很多同学工作后，公司项目中会使用第三方框架，大家都用的很快乐！
 
 如果工作中，碰到还在使用第三方框架解析json，换掉！
 
 0. 备份
 1. 删除 JSONKit.h .m
 2. 哪里出错，改哪里
 */
- (void)appleJSON {
    NSURL *url = [NSURL URLWithString:@"http://192.168.21.110/demo.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // 反序列化
        CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
        
        NSLog(@"start");
        for (int i = 0; i < 100000; i++) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        }
        
        NSLog(@"%f", CFAbsoluteTimeGetCurrent() - start);
    }];
}

- (void)jsonKit {
    NSURL *url = [NSURL URLWithString:@"http://192.168.21.110/demo.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // 反序列化
        CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
        
        for (int i = 0; i < 100000; i++) {
//            id result = [[JSONDecoder decoder] objectWithData:data];
        }
        
        NSLog(@"%f", CFAbsoluteTimeGetCurrent() - start);
    }];
}


@end
