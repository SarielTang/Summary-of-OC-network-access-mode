//
//  AppDelegate.m
//  02-用户登录
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkTools.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 一旦删除了引导的 sb，self.window不会被实例化
    // 显示一个白色的窗口
    NSLog(@"%@", self.window);
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:HMUserLoginSuccessedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:HMUserLogoutNotification object:nil];
    
    // 用户登录
    [[NetworkTools sharedNetworkTools] userLoginWithFailed:^{
        [self logout];
    }];
    
    return YES;
}

// 通知的监听方法，会在发布通知所在的线程执行！
// 一定注意，提示：如果 UI 更新异常缓慢，通常就是在异步更新 UI!
- (void)loginSuccessed {
    // 切换界面
    NSLog(@"%s %@", __FUNCTION__, [NSThread currentThread]);
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    self.window.rootViewController = sb.instantiateInitialViewController;
}

- (void)logout {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.window.rootViewController = sb.instantiateInitialViewController;
}

@end
