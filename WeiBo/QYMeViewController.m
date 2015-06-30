//
//  QYMeViewController.m
//  WeiBo
//
//  Created by qingyun on 15-4-20.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYMeViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "QYAccountModel.h"
#import "QYUserModel.h"

@interface QYMeViewController ()

@end

@implementation QYMeViewController

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
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[[QYAccountModel accountModel] userModel] profile_image_url]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
