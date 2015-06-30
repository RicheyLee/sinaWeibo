//
//  QYTableViewFooterView.h
//  WeiBo
//
//  Created by qingyun on 15-4-28.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QYStatusModel;
@interface QYTableViewFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *reStatus;//转发
@property (weak, nonatomic) IBOutlet UIButton *comments;
@property (weak, nonatomic) IBOutlet UIButton *star;

-(void)setStatusModel:(QYStatusModel *)status;

@end
