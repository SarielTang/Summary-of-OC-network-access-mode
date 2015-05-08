//
//  Plist.m
//  网络知识点回顾
//
//  Created by Sariel's Mac on 15-5-6.
//  Copyright (c) 2015年 Sariel. All rights reserved.
//

#import "Plist.h"

@implementation Plist

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self loadData];
}

- (void)loadData {
    NSURL *url = [NSURL URLWithString:@"http://192.168.21.110/videos.plist"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        // PList 的反序列化
        // NSPropertyListSerialization 属性列表
        /**
         1. 二进制数据
         2. 选项
         NS_OPTIONS
         
         NSPropertyListImmutable = 0,                       不可变
         NSPropertyListMutableContainers = 1 << 0,          容器可变
         NSPropertyListMutableContainersAndLeaves = 1 << 1  容器和叶子可变
         
         通常后续直接做字典转模型，不需要关心是否可变
         3. 格式，传入 NULL
         4. 错误，传入 NULL
         */
        id result = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:NULL];
        NSLog(@"%@", result);
    }];
}


@end
