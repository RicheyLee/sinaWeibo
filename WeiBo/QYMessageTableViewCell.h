//
//  QYMessageTableViewCell.h
//  WeiBo
//
//  Created by qingyun on 15-5-8.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QYStatusModel;
@interface QYMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UILabel *contentText;
@property (weak, nonatomic) IBOutlet UIImageView *reStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *reStatusUserName;
@property (weak, nonatomic) IBOutlet UILabel *reStatusText;


//绑定内容
-(void)setStatusModel:(QYStatusModel *)status;

//计算cell高度
-(CGFloat)cellHeightWithStatus:(QYStatusModel *)status;

@end
