//
//  QYStatusTableViewCell.m
//  WeiBo
//
//  Created by qingyun on 15-4-26.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYStatusTableViewCell.h"
#import "QYStatusModel.h"
#import "QYUserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation QYStatusTableViewCell

-(void)setStatusModel:(QYStatusModel *)status{
    //绑定内容
    self.nameLabel.text = status.user.name;
    self.timeAgo.text = status.timeAgo;
    self.sourceLabel.text = status.source;
    self.contentText.text = status.text;
    self.reStatusContext.text = status.reStatus.reStatusText;
    
    
    
    //绑定人物头像
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:status.user.profile_image_url]];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:status.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"12"]];
    
    QYStatusModel *reStatus = status.reStatus;
    if (reStatus) {
        //绑定转发微博图片
        
        //绑定图片
        NSArray *imageDicArray = reStatus.pic_urls;
        
        //将所有url取出
        NSArray *imageURLArray = [imageDicArray valueForKeyPath:kStatusThumbnailPic];
        [self layout:imageURLArray forView:self.reStatusImageSuperView];
        [self layout:nil forView:self.contentImageSuperView];
    }else {
        //绑定自有微博图片
        
        //绑定图片
        NSArray *imageDicArray = status.pic_urls;
        
        //将所有url取出
        NSArray *imageURLArray = [imageDicArray valueForKeyPath:kStatusThumbnailPic];
        [self layout:imageURLArray forView:self.contentImageSuperView];
        [self layout:nil forView:self.reStatusImageSuperView];
    }
    
    
}

-(CGFloat)cellHeight4StatusModel:(QYStatusModel *)status{
    //计算出除去图片的所有高度
    CGFloat cellHeight = 0;
    
    
    //绑定model
    //绑定内容
    self.nameLabel.text = status.user.name;
    self.timeAgo.text = status.timeAgo;
    self.sourceLabel.text = status.source;
    self.contentText.text = status.text;
    self.reStatusContext.text = status.reStatus.reStatusText;
    
    //清除图片
    [self layout:nil forView:self.contentImageSuperView];
    [self layout:nil forView:self.reStatusImageSuperView];
    
    
    //计算contentView需要的size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    cellHeight += size.height;
    
    QYStatusModel *reStatus = status.reStatus;
    if (reStatus) {
        //计算转发微博图片
        //图片的张数
        NSInteger countImage = reStatus.pic_urls.count;
        
        if (countImage != 0) {
            //显示的行数
            NSInteger line = ceil((CGFloat)countImage / 3.f);
            
            //图片显示需要的高度
            NSInteger imageHeight = line * 90 + 16 + (line - 1) * 5;
            cellHeight += imageHeight;
        }
        
    }else {
        //计算图片需要的高度,如果没有转发微博的时候
        
        //图片的张数
        NSInteger countImage = status.pic_urls.count;
        
        if (countImage != 0) {
            //显示的行数
            NSInteger line = ceil((CGFloat)countImage / 3.f);
            
            //图片显示需要的高度
            NSInteger imageHeight = line * 90 + 16 + (line - 1) * 5;
            cellHeight += imageHeight;
        }
    }
    
    
    return cellHeight;
}

-(void)layout:(NSArray *)imageArray forView:(UIView *)view{
    //先移除之前的所有子视图图片
    NSArray *subViews = view.subviews;
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }
    
    //计算出需要的高度
    //显示的行数
    NSInteger line = ceil((CGFloat)imageArray.count / 3.f);
    
    //图片显示需要的高度
    NSInteger imageHeight = line * 90 + 16 + (line - 1) * 5;
    //找到约束,更改为需要的高度
    NSArray *constraintArray = view.constraints;
    for (NSLayoutConstraint *constraint in constraintArray) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            if (imageArray.count != 0) {
                constraint.constant = imageHeight;
            }else{
                //更改高度为0;
                constraint.constant = 0;
            }
            
        }
    }
    
    
    for (int i = 0; i < imageArray.count; i ++) {
        NSString *imageURL = imageArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i % 3 * (90 + 5), 8 + (90 + 5)* (i/3), 90, 90)];
        [view addSubview:imageView];
        imageView.backgroundColor = [UIColor redColor];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"12"]];
    }
    
}

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

@end
