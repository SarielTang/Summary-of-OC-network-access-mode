//
//  HomeTableViewController.m
//  02-用户登录
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HomeTableViewController.h"
#import "NetworkTools.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

// 切换界面，谁来做？AppDelegate
- (IBAction)logout:(id)sender {
    // 发送注销通知
    [[NSNotificationCenter defaultCenter] postNotificationName:HMUserLogoutNotification object:nil];
}

@end
