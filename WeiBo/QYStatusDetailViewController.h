//
//  QYStatusDetailViewController.h
//  WeiBo
//
//  Created by qingyun on 15-5-7.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kreStatus,
    kcomments,
    kstar
} kDetailType;

@class QYStatusModel;
@interface QYStatusDetailViewController : UIViewController

//显示的微博model
@property (nonatomic, strong)QYStatusModel *status;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic)kDetailType type;

@end
