//
//  QYViewControllerManager.m
//  WeiBo
//
//  Created by qingyun on 15-4-20.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYViewControllerManager.h"

#import "QYGuideVC.h"
#import "QYMainViewController.h"
#import "QYAppDelegate.h"

@implementation QYViewControllerManager

+(id)getRootViewVC{
    //根据标识返回相应的控制器
    
    BOOL notFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"notFirstLaunch"];
    
    UIStoryboard *sotory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if (notFirstLaunch) {
        return [sotory instantiateViewControllerWithIdentifier:@"maintabbar"];
    }else{
        return [sotory instantiateInitialViewController];
    }
}


+(void)guideEnd{
    //引导结束，更改标识位，切换根控制器
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:YES forKey:@"notFirstLaunch"];
    [userDefault synchronize];
    
    QYAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    UIStoryboard *sotory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    delegate.window.rootViewController = [sotory instantiateViewControllerWithIdentifier:@"maintabbar"];
    
}


@end
