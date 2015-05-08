//
//  Video.m
//  03-XML解析
//
//  Created by 刘凡 on 15/2/5.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "Video.h"

// 如果服务器变更，只要修改这里即可
#define BASE_URL [NSURL URLWithString:@"http://192.168.21.110/"]

@implementation Video

+ (instancetype)videoWithDict:(NSDictionary *)dict {
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
}

// 重写了属性的 setter 方法，在设置数值的同时，就计算出 timeString
// 效率会比用懒加载的效率高！
// 一旦重写了 setter 方法！设置数值的工作由我们接管
// copy属性重写 setter 方法，必须 copy，否则属性里的 copy 就白写了
- (void)setLength:(NSNumber *)length {
    _length = length.copy;
    
    // 计算时间字符串
    int len = self.length.intValue;
    
    _timeString = [NSString stringWithFormat:@"%02d:%02d:%02d", len / 3600, (len % 3600) / 60, len % 60];
}

//- (NSString *)timeString {
//    if (_timeString == nil) {
//        int len = self.length.intValue;
//        
//        _timeString = [NSString stringWithFormat:@"%02d:%02d:%02d", len / 3600, (len % 3600) / 60, len % 60];
//    }
//    return _timeString;
//}

// 可以用 setter 方法调整
- (NSURL *)fullImageURL {
    if (_fullImageURL == nil) {
        _fullImageURL = [NSURL URLWithString:self.imageURL relativeToURL:BASE_URL];
    }
    return _fullImageURL;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %p> { videoId : %@, name : %@ %p, length : %@ %p, videoURL : %@ %p, imageURL : %@, desc : %@, teacher : %@}", [self class], self, self.videoId, self.name, self.name, self.length, self.length, self.videoURL, self.videoURL, self.imageURL, self.desc, self.teacher];
}

@end
