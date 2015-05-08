//
//  DifferentRequest.m
//  网络知识点回顾
//
//  Created by Sariel's Mac on 15-5-6.
//  Copyright (c) 2015年 Sariel. All rights reserved.
//

#import "DifferentRequest.h"
#import "NSString+Hash.h"
#import "SSKeychain.h"

@interface DifferentRequest ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/// 服务器返回的 etag
@property (nonatomic, copy) NSString *etag;


@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *pwd;

@end

@implementation DifferentRequest


#pragma mark - GET缓存
/**
 1. 请求的缓存策略使用 NSURLRequestReloadIgnoringCacheData，忽略本地缓存
 2. 服务器响应结束后，要记录 Etag，服务器内容和本地缓存对比是否变化的重要依据！
 3. 在发送请求时，设置 If-None-Match，并且传入 etag
 4. 连接结束后，要判断响应头的状态码，如果是 304，说明本地缓存内容没有发生变化
 
 从本地缓存加载数据：
 NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
 self.iconView.image = [UIImage imageWithData:cachedResponse.data];
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSURL *url = [NSURL URLWithString:@"http://localhost/itcast/images/head5.png"];
    /**
     如果每次都从服务器获取，会降低性能！
     */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    // 设置请求头 - 所有的请求头都是通过此方法设置的
    if (self.etag.length > 0) {
        // 设置请求头，判断和上次请求的内容是否一致
        NSLog(@"设置 etag %@", self.etag);
        [request setValue:self.etag forHTTPHeaderField:@"If-None-Match"];
    }
    
    // 请求的默认方法就是 GET,GET的使用频率很高！
    NSLog(@"%@", request.HTTPMethod);
    
    /**
     Etag = "\"c7a5-50e4fd6975340\"";
     可以在请求中增加一个 etag 跟服务器返回的 etag 进行对比
     
     就能够判断服务器对应的资源是否发生变化，具体更新的时间，由request自行处理
     */
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        // allHeaderFields 所有响应头子端
        NSLog(@"%@ %@", httpResponse.allHeaderFields, httpResponse);
        
        // 如果服务器的响应的状态码是 304 说明数据已经被缓存，服务器不再返回数据！
        // 需要从本地缓存获取到被缓存的数据
        if (httpResponse.statusCode == 304) {
            NSLog(@"加载本地缓存数据");
            
            // 针对 http 访问的一个缓存类，提供了一个单例
            // 拿到被缓存的响应
            NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
            self.iconView.image = [UIImage imageWithData:cachedResponse.data];
            return;
        }
        
        // 记录 etag
        self.etag = httpResponse.allHeaderFields[@"Etag"];
        
        self.iconView.image = [UIImage imageWithData:data];
    }];
}

#pragma mark - GET登录
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//self.username = @"zhangsan";
//self.pwd = @"zhang";
//    [self getLogin];
//}

- (void)getLogin {
    /**
     URL 的基本格式
     
     1. 登录的脚本：login.php，提示：在不同的公司使用的后台接口是不一样的 jsp,aspx,...
     2. 如果要带参数，使用 `?` 衔接
     3. 参数格式：值对
     参数名=值
     4. 如果有多个参数，使用 `&` 连接
     
     GET 是可以缓存的-以下操作仅供演示，相关内容内容后续会讲，SQLite中！
     
     GET 缓存的数据会保存在 Cache 目录中 \bundleId 下，Cache.db 中
     - cfurl_cache_receiver_data，缓存所有的请求数据
     - cfurl_cache_response，缓存所有的响应
     */
    NSString *urlString = [NSString stringWithFormat:@"http://localhost/login.php?username=%@&password=%@", self.username, self.pwd];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@", result);
    }];
}

#pragma mark - POST登录
/**
 存在的问题：
 
 1. 保存在沙盒中的密码是"明文"
 2. 在网络上传输的是 明文
 
 安全的约定：
 
 1. 客户端和服务器都不能保存用户密码明文 iTools
 2. 在网络上不允许直接传输传输密码明文
 */
- (IBAction)login {
//    self.username = self.usernameText.text;
//    self.pwd = self.pwdText.text;
    
    [self postLogin];
}

/**
 1. url
 GET
 1. 登录的脚本：login.php，提示：在不同的公司使用的后台接口是不一样的 jsp,aspx,...
 2. 如果要带参数，使用 `?` 衔接
 3. 参数格式：值对
 参数名=值
 4. 如果有多个参数，使用 `&` 连接
 5. 如果 url 中包含中文或者空格，需要添加"百分号"转义
 POST
 1. 就是登录的脚本，URL中不包含任何参数
 
 2. request
 GET
 默认就是 GET 方法，不需要指定任何内容
 POST
 1> HTTPMethod -> POST
 2> HTTPBody，数据格式，可以从 firebug 拦截并且粘贴
 
 格式和 get 方法的 url 的格式几乎一样，只是没有 `?`
 
 提示：无论是 get 还是 post，最好从浏览器`粘贴`
 
 3. connection
 发送异步请求，返回服务器的二进制数据，是最单纯的方法，GET & POST 是一样的
 */
- (void)postLogin {
    // 1. url
    NSURL *url = [NSURL URLWithString:@"http://192.168.21.110/login.php"];
    
    // 2. request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 1> HTTP方法
    request.HTTPMethod = @"POST";
    // 2> 请求体 HTTPBody
    // 格式和 get 方法的 url 的格式几乎一样，只是没有 `?`
    NSString *bodyString = [NSString stringWithFormat:@"username=%@&password=%@", self.username, self.pwd];
    // 提示：将字符串转换成二进制数据，有直接的对象方法
    // POST 方法内部会自动转义，不需要程序员参与！
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 3. connection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"POST - %@", result);
        
        // 用户登录成功保存用户信息
        if ([result[@"userId"] integerValue] > 0) {
            [self saveUserInfo];
            NSLog(@"%@", NSHomeDirectory());
        }
    }];
}

#pragma mark 保存&加载用户信息
#define HMUsernameKey @"HMUsernameKey"
#define HMPwdKey @"HMPwdKey"
/// 保存用户信息
- (void)saveUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.username forKey:HMUsernameKey];
    [defaults setObject:self.pwd forKey:HMPwdKey];
    
    // 会立即保存在沙盒
    [defaults synchronize];
}

/// 加载用户信息
- (void)loadUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    self.usernameText.text = [defaults objectForKey:HMUsernameKey];
//    self.pwdText.text = [defaults objectForKey:HMPwdKey];
}


#pragma mark - BASE 64加密（在发送密码明文时加密，在保存密码时加密）...
/// 提示：从 iOS 7.0 开始， 提供了base64的支持，之前很多软件会有base64的第三方框架！
/// base64 编码 A －》 QQ==
- (NSString *)base64Encode:(NSString *)str {
    // 1. 将字符串转换成二进制数据
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2. 返回 base64 编码后的结果
    return [data base64EncodedStringWithOptions:0];
}

/// base 64 解码， QQ== => A
- (NSString *)base64Decode:(NSString *)str {
    // 1. 将base64编码后的字符串转换成解码后的二进制数据，一旦调用就已经解码完成
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:0];
    
    // 2. 返回字符串
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - MD5散列加密
/// 时间密码字符串
- (NSString *)timePassword {
    
    // 1. hmac 的 key
    NSString *key = @"itheima".md5String;
    NSLog(@"HMAC KEY %@", key);
    
    // 2. 对密码进行 hmac
    NSString *pwd = [self.pwd hmacMD5StringWithKey:key];
    
    // 3. 取当前的系统时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [fmt stringFromDate:[NSDate date]];
    
    // 4. 将日期字符串拼接在密码后面
    pwd = [pwd stringByAppendingString:dateStr];
    
    return [pwd hmacMD5StringWithKey:key];
}

static NSString *salt = @"123";

- (void)postLogin1 {
    // 对用户密码明文进行md5散列，因为国内用md5的人很多！
    //    NSString *pwd = self.pwd.md5String;
    // 方案一：加盐，过时了 - 盐值够长，够复杂，够"咸"
    // 有些公司盐的生成是从服务器获取的！
    //    NSString *pwd = [self.pwd stringByAppendingString:salt].md5String;
    
    // 方案二：HMAC，国内这一年来用的人越来越多，安全级别要高很多
    // 使用 itheima 对 pwd 进行"加密"，然后在进行 md5，然后再次加密，再次 md5
    //    NSString *pwd = [self.pwd hmacMD5StringWithKey:@"itheima"];
    
    // HMAC - 问题：
    // 1. 同样的密码，每次加密的结果一样
    // 2. 一旦 key 泄漏，风险很大！
    // 关于密码加密应该达到的效果：同样的密码，同样的加密算法，要每次的结果都不一样！
    // 思路：增加一个动态的"盐"，盐要有规律！- 时间
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
        NSLog(@"POST - %@", result);
        
        // 用户登录成功保存用户信息
        if ([result[@"userId"] integerValue] > 0) {
            [self saveUserInfo];
            NSLog(@"%@", NSHomeDirectory());
        }
    }];
}

#pragma mark - 保存&加载用户信息(钥匙串加密)
#define HMUsernameKey @"HMUsernameKey"
#define HMPwdKey @"HMPwdKey"
/// 保存用户信息
- (void)saveUserInfo1 {
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
- (void)loadUserInfo1 {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    self.usernameText.text = [defaults objectForKey:HMUsernameKey];
    
    // 从钥匙串访问提取用户密码
    NSLog(@"%@", [SSKeychain allAccounts]);
    // 从钥匙串访问提取用户密码
    // 提问：密码到底保存在哪里？只有苹果知道！
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
//    self.pwdText.text = [SSKeychain passwordForService:bundleId account:self.usernameText.text];
}


@end
