//
//  QYViewControllerManager.h
//  WeiBo
//
//  Created by qingyun on 15-4-20.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYViewControllerManager : NSObject

/**
 *  返回根视图控制器
 */
+(id)getRootViewVC;

/**
 *  引导结束切换根视图控制器
 */
+(void)guideEnd;

@end
