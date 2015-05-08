//
//  ViewController.m
//  06-XML解析
//
//  Created by apple on 15/4/23.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "XMLController.h"
#import "Video.h"
#import "VideoCell.h"

@interface XMLController () <NSXMLParserDelegate>

// 显示用的数组
@property (nonatomic, strong) NSArray *dataList;

// MARK: - XML解析需要的素材
@property (nonatomic, strong) NSMutableArray *videos;
@property (nonatomic, strong) Video *currentVideo;
@property (nonatomic, strong) NSMutableString *elementString;
@end

@implementation XMLController

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    
    [self.tableView reloadData];
    
    // 结束刷新
    [self.refreshControl endRefreshing];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = (indexPath.row % 2) ? @"Cell2" : @"Cell";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 设置 Cell...
    cell.video = self.dataList[indexPath.row];
    
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadData {
    // 1. url
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/videos.xml"];
    
    // 2. request
    NSURLRequest *reqest = [NSURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:10.0];
    
    // 3. connection
    [NSURLConnection sendAsynchronousRequest:reqest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
        NSLog(@"%@", [NSThread currentThread]);
        
        // XML 是一种特殊格式的字符串！
//        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        // XML解析器
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        
        parser.delegate = self;
        
        // 解析器开始解析 － 后续的操作都是通过代理方法来实现的
        // 所有代理的执行工作，会在当前线程执行！
        [parser parse];
    }];
}

#pragma mark - <NSXMLParserDelegate>
// 1. 打开文档－准备开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"1. 打开文档");
    
    // 清空数据数组
    [self.videos removeAllObjects];
}

// 2. 开始节点 - 如果是 video 节点，会有属性字典
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    NSLog(@"2. 开始节点 %@ %@", elementName, attributeDict);
    
    // 如果 elementName 是 video
    if ([elementName isEqualToString:@"video"]) {
        // 新建对象
        self.currentVideo = [[Video alloc] init];
        
        // 给 videoId 设置数值
        self.currentVideo.videoId = @([attributeDict[@"videoId"] intValue]);
    }
    
    // 清空字符串，准备拼接（清空内容，不改变地址）
    [self.elementString setString:@""];
}

// 3. 发现节点中的文字 － 可能会执行多次(需要把几次执行获得的字符串进行拼接)
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"==> %@", string);
    
    [self.elementString appendString:string];
}

// 4. 结束节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"4. 结束节点 %@", elementName);
    
    // KVC 是 cocoa 的大招！，一种间接设置数值的手段
    if ([elementName isEqualToString:@"video"]) {
        // 将当前解析的节点添加到数组
        [self.videos addObject:self.currentVideo];
    } else if (![elementName isEqualToString:@"videos"]) {
        // 使用 KVC 设置数值
        [self.currentVideo setValue:self.elementString forKey:elementName];
    }
}

// 5. 结束文档
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"结束文档 %@ %@", [NSThread currentThread], self.videos);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 解析的数组和显示的数组，各司其职，互不干扰！
        self.dataList = self.videos.copy;
    });
}

#pragma mark - 懒加载
- (NSMutableArray *)videos {
    if (_videos == nil) {
        _videos = [[NSMutableArray alloc] init];
    }
    return _videos;
}

- (NSMutableString *)elementString {
    if (_elementString == nil) {
        _elementString = [[NSMutableString alloc] init];
        
        NSLog(@"!!!!++++++> %p", _elementString);
    }
    return _elementString;
}

@end
