//
//  QYAccountModel.h
//  WeiBo
//
//  Created by qingyun on 15-4-25.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QYUserModel;
@interface QYAccountModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *accessToken;//Oauth
@property (nonatomic, copy) NSString *sinaId;//id
@property (nonatomic, copy) NSDate *loseEfficacy;//失效时间
@property (nonatomic, strong)QYUserModel *userModel;//当前登录用户的信息


//单例初始化方法
+(instancetype)accountModel;

//设置登陆信息
-(void)loginSuccess:(NSDictionary *)loginInfo;

//退出登陆
-(void)logout;

//登陆状态判断
-(BOOL)isLogin;

//构造请求的基本字典
-(NSMutableDictionary *)requestParameters;



@end
