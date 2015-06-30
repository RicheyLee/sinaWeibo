//
//  QYStatusTableViewCell.h
//  WeiBo
//
//  Created by qingyun on 15-4-26.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QYStatusModel;
@interface QYStatusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentText;
@property (weak, nonatomic) IBOutlet UILabel *timeAgo;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *reStatusContext;
@property (weak, nonatomic) IBOutlet UIView *contentImageSuperView;
@property (weak, nonatomic) IBOutlet UIView *reStatusImageSuperView;

-(void)setStatusModel:(QYStatusModel *)status;

/**
 *  计算cell显示model需要的高度
 */
-(CGFloat)cellHeight4StatusModel:(QYStatusModel *)status;


@end
