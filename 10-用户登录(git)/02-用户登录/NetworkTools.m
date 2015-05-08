//
//  NetworkTools.m
//  02-用户登录
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "NetworkTools.h"
#import "NSString+Hash.h"
#import "SSKeychain.h"

NSString *const HMUserLoginSuccessedNotification = @"HMUserLoginSuccessedNotification";
/// 用户注销通知
NSString *const HMUserLogoutNotification = @"HMUserLogoutNotification";

@implementation NetworkTools

// 提示：如果面试中遇到要手写单例，只需要写以下代码即可！
// allocWithZone, copyWithZone，目的补充知识点，学会如何堵死所有新建副本的可能！
// 在实际开发中，通常会留出接口，保证在需要的时候，能够创建一个新的副本！
//
//    NSNotificationCenter
//    NSUserDefaults
//    NSFileManager
//    NSBundle
//    NSURLSession
//    UIApplication，只有这一个不能建立副本

+ (instancetype)sharedNetworkTools {
    static id instance;

    // dispatch_once { }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 加载用户信息
        [self loadUserInfo];
    }
    return self;
}

/// 用户登录
- (void)userLoginWithFailed:(void (^)())failed {

    // 断言 － 提前预判必须符合某一个条件
    // 如果不符合，直接让程序崩溃！可以在开发中提前发现很多代码的缺陷，而且有利于团队的协作开发！
    // 断言是所有 C/C++ 程序员的最爱，仅在测试版本有效，发布版本会无效！
    NSAssert(failed, @"必须传入 failed 回调块代码");
    
    // 判断是否有用户名和密码，用户第一次运行
    if (self.username.length == 0 || self.pwd.length == 0) {
        // 调用 failed 的回调，显示登录界面
        NSLog(@"初始调用");
        
        failed();
        
        return;
    }
    
    NSString *pwd = [self timePassword];
    
    NSLog(@"发送的密码是 %@", pwd);
    
    // 1. url - 使用新的登录脚本
    NSURL *url = [NSURL URLWithString:@"http://192.168.21.110/loginhmac.php"];
    
    // 2. request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 1> HTTP方法
    request.HTTPMethod = @"POST";
    // 2> 请求体 HTTPBody
    // 格式和 get 方法的 url 的格式几乎一样，只是没有 `?`
    NSString *bodyString = [NSString stringWithFormat:@"username=%@&password=%@", self.username, pwd];
    // 提示：将字符串转换成二进制数据，有直接的对象方法
    // POST 方法内部会自动转义，不需要程序员参与！
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 3. connection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"POST - %@ -%@", result, [NSThread currentThread]);
        
        // 用户登录成功保存用户信息
        if ([result[@"userId"] integerValue] > 0) {
            [self saveUserInfo];
            NSLog(@"用户登录成功！%@", NSHomeDirectory());
            
            // 发布通知
            [[NSNotificationCenter defaultCenter] postNotificationName:HMUserLoginSuccessedNotification object:nil];
        } else {
            // 用户登录失败
            // 执行block，C语言的
            failed();
        }
    }];
}

#pragma mark - 私有方法
/// 时间密码字符串
- (NSString *)timePassword {
    
    // 1. hmac 的 key
    NSString *key = @"itheima".md5String;
    NSLog(@"HMAC KEY %@", key);
    
    // 2. 对密码进行 hmac
    NSString *pwd = [self.pwd hmacMD5StringWithKey:key];
    
    // 3. 取当前的系统时间
    // 从服务器取服务器的系统时间
    NSURL *url = [NSURL URLWithString:@"http://192.168.21.110/hmackey.php"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSLog(@"%@", dict);
    
    NSString *dateStr = dict[@"key"];
    
    // 4. 将日期字符串拼接在密码后面
    pwd = [pwd stringByAppendingString:dateStr];
    
    return [pwd hmacMD5StringWithKey:key];
}

#pragma mark - 保存&加载用户信息
#define HMUsernameKey @"HMUsernameKey"
#define HMPwdKey @"HMPwdKey"
/// 保存用户信息
- (void)saveUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.username forKey:HMUsernameKey];
    
    // 会立即保存在沙盒
    [defaults synchronize];
    
    // 将用户密码明文保存在钥匙串中，之所以保存明文，是因为加密工作苹果已经负责了
    // 提示：service可以随便写，但是推荐使用 bundleId
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    NSLog(@"bundleId - %@", bundleId);
    /**
     1. 密码明文
     2. bundleId
     3. 当前用户名，钥匙串访问中可以保存很多密码
     */
    [SSKeychain setPassword:self.pwd forService:bundleId account:self.username];
}

/// 加载用户信息
- (void)loadUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.username = [defaults objectForKey:HMUsernameKey];
    
    // 从钥匙串访问提取用户密码
    NSLog(@"%@", [SSKeychain allAccounts]);
    // 从钥匙串访问提取用户密码
    // 提问：密码到底保存在哪里？只有苹果知道！
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    self.pwd = [SSKeychain passwordForService:bundleId account:self.username];
}

@end
