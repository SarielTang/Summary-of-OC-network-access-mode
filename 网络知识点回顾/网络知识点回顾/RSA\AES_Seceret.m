//
//  RSA\AES_Seceret.m
//  网络知识点回顾
//
//  Created by xl_bin on 15/5/10.
//  Copyright (c) 2015年 Sariel. All rights reserved.
//

#import "RSA\AES_Seceret.h"
#import "CryptorTools.h"

@implementation RSA_AES_Seceret

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // ECB 加密
    NSLog(@"加密 %@", [CryptorTools AESEncryptString:@"hello" keyString:@"itheima" iv:nil]);
    NSLog(@"解密 %@", [CryptorTools AESDecryptString:@"YB+m7LRUIWnZxO97PUyxCQ==" keyString:@"itheima" iv:nil]);
    
    // CBC加密
    // 向量需要使用数组指定
    uint8_t iv[8] = {1,2,3,4,5,6,7,8};
    NSData *ivData = [NSData dataWithBytes:iv length:sizeof(iv)];
    NSLog(@"%@", [CryptorTools AESEncryptString:@"i love you" keyString:@"abc" iv:ivData]);
    NSLog(@"%@", [CryptorTools AESDecryptString:@"DLUEfBbhjjk2yaKhAlkJwA==" keyString:@"abc" iv:ivData]);
}

- (void)aesDemo {
    // ECB 加密
    NSLog(@"加密 %@", [CryptorTools AESEncryptString:@"hello" keyString:@"abc" iv:nil]);
    NSLog(@"解密 %@", [CryptorTools AESDecryptString:@"d1QG4T2tivoi0Kiu3NEmZQ==" keyString:@"abc" iv:nil]);
    
    // CBC加密
    // 向量需要使用数组指定
    uint8_t iv[8] = {1,2,3,4,5,6,7,8};
    NSData *ivData = [NSData dataWithBytes:iv length:sizeof(iv)];
    NSLog(@"%@", [CryptorTools AESEncryptString:@"i love you" keyString:@"abc" iv:ivData]);
    NSLog(@"%@", [CryptorTools AESDecryptString:@"DLUEfBbhjjk2yaKhAlkJwA==" keyString:@"abc" iv:ivData]);
}

@end
