//
//  ViewController.m
//  02-用户登录
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "ViewController.h"
#import "NetworkTools.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@end

@implementation ViewController

/**
 安全的约定：
 
 1. 客户端和服务器都不能保存用户密码明文
 2. 在网络上不允许直接传输传输密码明文
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadUserInfo];
}

/// 用户登录
- (IBAction)login {
    NetworkTools *tools = [NetworkTools sharedNetworkTools];
    
    // 使用用户输入信息，更新登录的单例
    tools.username = self.usernameText.text;
    tools.pwd = self.pwdText.text;
    
    [tools userLoginWithFailed:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或者密码错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
    }];
}

#pragma mark - 保存&加载用户信息
/// 加载用户信息
- (void)loadUserInfo {
    // 从网络管理工具单例加载
    NetworkTools *tools = [NetworkTools sharedNetworkTools];
    
    self.usernameText.text = tools.username;
    self.pwdText.text = tools.pwd;
}

@end
