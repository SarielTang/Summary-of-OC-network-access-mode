//
//  VideoCell.m
//  06-XML解析
//
//  Created by apple on 15/4/23.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "VideoCell.h"
#import "Video.h"
#import "UIImageView+WebCache.h"

@interface VideoCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation VideoCell

- (void)setVideo:(Video *)video {

    self.titleLabel.text = video.name;
    self.teacherLabel.text = video.teacher;
    self.timeLabel.text = video.timeString;
    
    /**
     SDWebImageRetryFailed 如果图像下载失败，会再次下载
        SDWebImage 在下载图像的时候，如果一个图片下载失败，会放在黑名单中，不再下载！
     SDWebImageLowPriority 能够保证，在滚动表格的时候，停止下载
     */
    [self.iconView sd_setImageWithURL:video.fullImageURL placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

@end
