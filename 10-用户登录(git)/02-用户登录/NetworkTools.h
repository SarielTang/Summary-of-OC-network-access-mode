//
//  NetworkTools.h
//  02-用户登录
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 使用 extern 定义的字符串，表示字符串的内容，在其他位置已经设置，可以直接使用
/// 通常设置数值的代码在.m中，声明在.h中，这种方式更安全！
/// 被苹果广泛的使用！推荐大家使用！

// 定义通知字符串
/// 用户登录成功通知
extern NSString *const HMUserLoginSuccessedNotification;
///// 用户注销通知
extern NSString *const HMUserLogoutNotification;

/**
 1. 提供一个全局访问入口，供外部统一调用
 2. 在内存中，只保存一个副本
 */
@interface NetworkTools : NSObject

+ (instancetype)sharedNetworkTools;

/// 用户登录
/// block 是预先准备好的代码，在需要的时候执行，可以当作参数传递！
//- (void)userLoginWithName:(NSString *)name;
- (void)userLoginWithFailed:(void (^)())failed;

/// 用户名
@property (nonatomic, copy) NSString *username;
/// 密码
@property (nonatomic, copy) NSString *pwd;

@end
