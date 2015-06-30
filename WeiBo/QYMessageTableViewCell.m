//
//  QYMessageTableViewCell.m
//  WeiBo
//
//  Created by qingyun on 15-5-8.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYMessageTableViewCell.h"
#import "QYStatusModel.h"
#import "QYUserModel.h"
#import <UIImageView+WebCache.h>


@implementation QYMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStatusModel:(QYStatusModel *)status{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:status.user.profile_image_url]];
    self.name.text = status.user.name;
    self.time.text = status.timeAgo;
    self.source.text = status.source;
    self.contentText.text = status.text;
    
    if (status.reStatus.pic_urls.count > 0) {
        NSString *urlString = [status.reStatus.pic_urls.firstObject objectForKey:kStatusThumbnailPic];
        [self.reStatusImage sd_setImageWithURL:[NSURL URLWithString:urlString]];
    }else{
        //使用用户图片
        [self.reStatusImage sd_setImageWithURL:[NSURL URLWithString:status.reStatus.user.profile_image_url]];
    }
    
    self.reStatusUserName.text = status.reStatus.user.name;
    self.reStatusText.text = status.reStatus.text;
    
    
}

-(CGFloat)cellHeightWithStatus:(QYStatusModel *)status{
    self.contentText.text = status.text;
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

@end
