//
//  QYSendStatusesViewController.m
//  WeiBo
//
//  Created by qingyun on 15-5-11.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYSendStatusesViewController.h"

@interface QYSendStatusesViewController ()<UIImagePickerControllerDelegate>

@end

@implementation QYSendStatusesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sendImage:(id)sender {
    //弹出imagePicker
    
    
}

-(void)animationButton{
//    button 显示的动画
    for (int i = 0; i < self.sendButtons.count; i ++) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //单个button的动画
            UIButton *button = self.sendButtons[i];
            CGRect frame = button.frame;
            button.frame = CGRectOffset(button.frame, 0, self.view.frame.size.height - button.frame.origin.y);
            button.hidden = NO;
            [UIView animateWithDuration:.25f animations:^{
                button.frame = CGRectOffset(frame, 0, -20);
            } completion:^(BOOL finished) {
                button.frame = frame;
            }];
        });
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - image picker delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //1.得到用户选择的图片
    //2.取消imagePicker
    //3.从故事版初始化sendStatusVC
    //将选择的图片传递给sendStatusVC
    //用model弹出sendStatusVC
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}

@end
