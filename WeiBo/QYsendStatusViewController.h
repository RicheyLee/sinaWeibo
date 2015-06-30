//
//  QYsendStatusViewController.h
//  WeiBo
//
//  Created by qingyun on 15-5-11.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYsendStatusViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)dismiss:(id)sender;
- (IBAction)send:(id)sender;


@end
