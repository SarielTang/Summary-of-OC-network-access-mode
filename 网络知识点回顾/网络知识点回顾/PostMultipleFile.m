//
//  PostMultipleFile.m
//  网络知识点回顾
//
//  Created by xl_bin on 15/5/7.
//  Copyright (c) 2015年 Sariel. All rights reserved.
//

#import "PostMultipleFile.h"

@implementation PostMultipleFile

/**
 *  上传文件
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"001.png" ofType:nil];
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"demo.jpg" ofType:nil];
    NSData *data2 = [NSData dataWithContentsOfFile:path2];
    
    // 思考一个问题：如何传递参数？
    //    NSArray *dataList = @[data1, data2];
    //    NSArray *fileNames = @[@"001.png", @"abc.jpg"];
    //    NSDictionary *dataDict = @{@"zzz.png": data1, @"zzz.jpg": data2};
    NSDictionary *dataDict = @{@"123456.png": data1};
    
    // 参数字典
    // status 的名字需要咨询后台开发人员
    NSDictionary *params = @{@"status": @"hello"};
    
    // 上传多个文件的时候，需要有一个[]
    [self postUpload:@"userfile[]" dataDict:dataDict params:params];
}

#define boundary @"itheima-upload"

- (void)postUpload:(NSString *)fieldName dataDict:(NSDictionary *)dataDict params:(NSDictionary *)params {
    // 1. url － 负责上传文件的脚本 PHP
    // 默认2M
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/post/upload-m.php"];
    
    // 2. 请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 设置请求头，告诉服务器本次请求是上传文件
    // content-type 中的 boundary 必须和后面拼接的 boundary 保持一致
    NSString *type = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    
    // 设置数据体
    request.HTTPBody = [self formData:fieldName dataDict:dataDict params:params];
    
    // 3. 连接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]);
    }];
}

/**
 =================
 --boundary\r\n
 Content-Disposition: form-data; name="userfile[]"; filename="111.txt"\r\n
 Content-Type: application/octet-stream\r\n\r\n
 
 二进制数据
 \r\n
 =================
 --boundary\r\n
 Content-Disposition: form-data; name="userfile[]"; filename="222.txt"\r\n
 Content-Type: application/octet-stream\r\n\r\n
 
 二进制数据
 \r\n
 =================
 --boundary\r\n
 Content-Disposition: form-data; name="status"\r\n\r\n
 
 hello world
 \r\n
 =================
 --boundary--
 
 */
- (NSData *)formData:(NSString *)fieldName dataDict:(NSDictionary *)dataDict params:(NSDictionary *)params {
    
    NSMutableData *dataM = [NSMutableData data];
    
    // 1. 处理多个上传文件的数据 － 遍历字典
    [dataDict enumerateKeysAndObjectsUsingBlock:^(NSString *fileName, NSData *data, BOOL *stop) {
        
        NSMutableString *strM = [NSMutableString string];
        
        [strM appendFormat:@"--%@\r\n", boundary];
        [strM appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, fileName];
        [strM appendString:@"Content-Type: application/octet-stream\r\n\r\n"];
        
        [dataM appendData:[strM dataUsingEncoding:NSUTF8StringEncoding]];
        // 拼接要上传文件的二进制数据
        [dataM appendData:data];
        
        // 拼接一个回车
        [dataM appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 2. 拼接参数
    /**
     --boundary\r\n
     Content-Disposition: form-data; name="status"\r\n\r\n
     
     hello world
     \r\n
     */
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        NSMutableString *strM = [NSMutableString string];
        
        [strM appendFormat:@"--%@\r\n", boundary];
        [strM appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
        [strM appendString:value];
        [strM appendString:@"\r\n"];
        
        // 拼接到二进制数据中
        [dataM appendData:[strM dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    NSString *tail = [NSString stringWithFormat:@"--%@--\r\n", boundary];
    [dataM appendData:[tail dataUsingEncoding:NSUTF8StringEncoding]];
    
    return dataM.copy;
}


@end
