//
//  QYSendStatusesViewController.h
//  WeiBo
//
//  Created by qingyun on 15-5-11.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYSendStatusesViewController : UIViewController

//将button放到一个数组中，
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sendButtons;

- (IBAction)sendImage:(id)sender;

-(void)animationButton;
@end
