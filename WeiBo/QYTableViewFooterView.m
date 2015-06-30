//
//  QYTableViewFooterView.m
//  WeiBo
//
//  Created by qingyun on 15-4-28.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYTableViewFooterView.h"
#import "QYStatusModel.h"

@implementation QYTableViewFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)awakeFromNib{
    //设置背景视图
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
}

-(void)setStatusModel:(QYStatusModel *)status{
    //绑定内容
    
    [self.reStatus setTitle:[NSString stringWithFormat:@"%ld",status.reposts_count] forState:UIControlStateNormal];
    [self.comments setTitle:[NSString stringWithFormat:@"%ld",status.comments_count] forState:UIControlStateNormal];
    [self.star setTitle:[NSString stringWithFormat:@"%ld", status.attitudes_count] forState:UIControlStateNormal];
}


@end
