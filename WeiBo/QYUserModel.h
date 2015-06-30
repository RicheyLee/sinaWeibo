//
//  QYUserModel.h
//  WeiBo
//
//  Created by qingyun on 15-4-26.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

//followers_count	int	粉丝数
//friends_count	int	关注数
//statuses_count	int	微博数
//favourites_count	int	收藏数

#import <Foundation/Foundation.h>

@interface QYUserModel : NSObject

@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *profile_image_url;

@property(nonatomic)int follower;
@property(nonatomic)int friends;
@property(nonatomic)int statuses;
@property(nonatomic)int favourites;

-(instancetype)initWithDictionary:(NSDictionary *)userInfo;

@end
