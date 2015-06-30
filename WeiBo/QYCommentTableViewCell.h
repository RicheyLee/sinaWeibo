//
//  QYCommentTableViewCell.h
//  WeiBo
//
//  Created by qingyun on 15-5-7.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QYCommentModel;
@interface QYCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

-(void)setCommentModel:(QYCommentModel*)comment;

@end
