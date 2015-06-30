//
//  QYAccountModel.m
//  WeiBo
//
//  Created by qingyun on 15-4-25.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYAccountModel.h"
#import "AFNetworking/AFNetworking.h"
#import "QYUserModel.h"

#define kAccountInfoFileName @"kAccountInfoFileName"
static QYAccountModel *currentAccountModel;



@implementation QYAccountModel



+(instancetype)accountModel{
    //只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //归档保存信息，解档方法初始化model
        //查找documents文件路径，
        NSString *documentsPah = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        //文件路径
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsPah, kAccountInfoFileName];
        
        currentAccountModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        //如果归档文件不存在，初始化对象
        if (!currentAccountModel) {
            currentAccountModel = [[QYAccountModel alloc] init];
        }
    });
    
    return currentAccountModel;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    //解档的初始化方法
    self = [super init];
    if (self) {
        self.loseEfficacy = [aDecoder decodeObjectForKey:kExpires_in];
        //当前时间小于过期时间有效
        if ([[NSDate date] compare:self.loseEfficacy] < 0) {
            //登录有效
            self.accessToken = [aDecoder decodeObjectForKey:kAccess_token];
            self.sinaId = [aDecoder decodeObjectForKey:kUid];
            [self loadUserModel];
            
        }else{
            //重新登录
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    //归档，将属性保存到文件
    [aCoder encodeObject:self.accessToken forKey:kAccess_token];
    [aCoder encodeObject:self.loseEfficacy forKey:kExpires_in];
    [aCoder encodeObject:self.sinaId forKey:kUid];
    
    
}


-(void)loginSuccess:(NSDictionary *)loginInfo{
    //令牌
    self.accessToken = loginInfo[kAccess_token];
    //失效时间 = 当前的登录时间 + 生命周期时间
    self.loseEfficacy = [NSDate dateWithTimeIntervalSinceNow:[loginInfo[kExpires_in] doubleValue]];
    self.sinaId = loginInfo[kUid];
    
    //保存物理文件
    
    //查找documents文件路径，
    NSString *documentsPah = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //文件路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsPah, kAccountInfoFileName];
    //将当前model归档到文件
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
    
    
}

-(void)logout{
    
    //清除内存中保存的信息
    self.accessToken = nil;
    self.loseEfficacy = nil;
    self.sinaId = nil;
    
    //清除物理文件
    //查找documents文件路径，
    NSString *documentsPah = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //文件路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsPah, kAccountInfoFileName];
    //将当前model归档到文件
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

-(BOOL)isLogin{
    if (self.accessToken) {
        return YES;
    }
    return NO;
}

-(NSMutableDictionary *)requestParameters{
    if ([self isLogin]) {
        //构造网络请求用的字典，却在在登录状态
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.accessToken forKey:kAccess_token];
        return dic;
    }
    return nil;
}

-(void)loadUserModel{
    NSMutableDictionary *dic = [self requestParameters];
    if (!dic) {
        return;
    }
    
    //设置用户的id
    [dic setObject:self.sinaId forKey:@"uid"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.weibo.com/2/users/show.json" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QYUserModel *user = [[QYUserModel alloc] initWithDictionary:responseObject];
        self.userModel = user;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
