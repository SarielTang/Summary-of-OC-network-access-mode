//
//  ViewController.m
//  03-POST JSON
//
//  Created by apple on 15/4/26.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()
@property (nonatomic, strong) Person *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 实例化 person
    self.person = [Person personWithDict:@{@"name": @"zhangsan", @"age": @19}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self postPerson];
}

- (void)postPerson {
    
    // KVC － 大招
    // 以下演示知道就行，严重不建议在程序开发中使用！
    // 字典转模型
    // 模型转字典 - 参数是属性名称的数组
    
    // 在运行的时候，间接设置对象的属性，不管对象属性是否在 .h 中公开
    // 违背面向对象设计的“开闭原则”
    [self.person setValue:@"Manager" forKey:@"title"];
    [self.person setValue:@"1.6" forKey:@"height"];
    
    id obj = [self.person dictionaryWithValuesForKeys:@[@"name", @"age", @"title", @"_height"]];
    
    // 判断对象是否能够正常的被序列化 - 可以防止程序崩溃！
    if (![NSJSONSerialization isValidJSONObject:obj]) {
        NSLog(@"格式不正确");
        return;
    }
    
    // 序列化 - 字典/数组
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:NULL];
    
    [self postJSON:data];
}

// Invalid top-level type in JSON write
// 顶级节点必须是字典或者数组
- (void)postDemo {
    NSString *str = @"hello";
    
    // 判断对象是否能够正常的被序列化 - 可以防止程序崩溃！
    if (![NSJSONSerialization isValidJSONObject:str]) {
        NSLog(@"格式不正确");
        return;
    }
    
    // 序列化
    NSData *data = [NSJSONSerialization dataWithJSONObject:str options:0 error:NULL];
    
    [self postJSON:data];
}

- (void)postDict {
    
    NSDictionary *dict1 = @{@"username": @"xiao hua", @"age": @19};
    NSDictionary *dict2 = @{@"username": @"lao huahua", @"age": @199};
    
    NSArray *array = @[dict1, dict2];
    
    // 序列化：将程序中的字典/数组发送给服务器之前，转换成二进制数据
    // 反序列化：将服务器返回的二进制数据转换成 字典/数组
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:NULL];
    
    [self postJSON:data];
}

/**
 *  JSON 本质上就是一个字符串，只是格式特殊
 */
- (void)postJSONString {
    
    NSString *str = @"{\"username\": \"xiao fang\", \"age\": \"18\"}";
    
    [self postJSON:[str dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)postJSON:(NSData *)data {
    // 1. url
    NSURL *url = [NSURL URLWithString:@"http://192.168.21.110/post/postjson.php"];
    
    // 2. request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 告诉服务器发送的数据是 JSON 格式的 - 这句话最好写上，有些服务器会做类型检测
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    // 设置数据体
    request.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // 服务器返回的内容是纯文本
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}

@end
