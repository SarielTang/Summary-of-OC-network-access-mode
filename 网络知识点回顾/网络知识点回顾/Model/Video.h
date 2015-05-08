//
//  Video.h
//  03-XML解析
//
//  Created by 刘凡 on 15/2/5.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

/// 如果使用 strong, 设置数值的时候，只是引用计数+1，并不会建立新的副本
/// 最终都引用的解析过程中拼接的 elementString
///  视频代号
@property (nonatomic, copy) NSNumber *videoId;
///  视频名称
@property (nonatomic, copy) NSString *name;
///  视频长度
@property (nonatomic, copy) NSNumber *length;
///  视频URL
@property (nonatomic, copy) NSString *videoURL;
///  图像URL，使用相对路径便于更换服务器
@property (nonatomic, copy) NSString *imageURL;
///  介绍
@property (nonatomic, copy) NSString *desc;
///  讲师
@property (nonatomic, copy) NSString *teacher;
/**
 *  完整的图像 URL
 */
@property (nonatomic, strong) NSURL *fullImageURL;

@property (nonatomic, copy, readonly) NSString *timeString;

+ (instancetype)videoWithDict:(NSDictionary *)dict;

@end
