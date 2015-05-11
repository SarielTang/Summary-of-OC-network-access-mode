//
//  ViewController.m
//  02-下载文件
//
//  Created by apple on 15/4/28.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "ViewController.h"
#import "DownloadManager.h"
#import "ProgressButton.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ProgressButton *progressView;
@property (nonatomic, strong) NSURL *url;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pause {
    [[DownloadManager sharedManager] pauseWithURL:self.url];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSString *urlString = @"http://192.168.21.110/03-指针的指针.mp4";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    self.url = url;
    
    // 使用下载管理器单例，直接下载
    [[DownloadManager sharedManager] downloadWithURL:url progress:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = progress;
        });
    } finished:^(NSString *filePath, NSError *error) {
        NSLog(@"%@ %@ %@", filePath , error, [NSThread currentThread]);
    }];
}

@end
