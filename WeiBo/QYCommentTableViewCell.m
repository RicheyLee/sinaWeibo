//
//  QYCommentTableViewCell.m
//  WeiBo
//
//  Created by qingyun on 15-5-7.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYCommentTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "QYCommentModel.h"
#import "QYUserModel.h"

@implementation QYCommentTableViewCell

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

-(void)setCommentModel:(QYCommentModel *)comment{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:comment.commntUser.profile_image_url]];
    self.name.text = comment.commntUser.name;
    self.time.text = [NSDateFormatter localizedStringFromDate:comment.createdAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.contentLabel.text = comment.text;
    
}

@end
