//
//  QYUserModel.m
//  WeiBo
//
//  Created by qingyun on 15-4-26.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYUserModel.h"

@implementation QYUserModel

-(instancetype)initWithDictionary:(NSDictionary *)userInfo{
    self = [super init];
    if (self) {
        //根据传递的字典，赋值属性
        self.userId = userInfo[kUserID];
        self.name = userInfo[kUserInfoName];
        self.profile_image_url = userInfo[kUserProfileImageURL];
        self.follower = [userInfo[kUserFollowersCount] intValue];
        self.friends = [userInfo[kUserFriendCount] intValue];
        self.statuses = [userInfo[kUserStatusCount] intValue];
        self.favourites = [userInfo[@"favourites_count"] intValue];
    }
    return self;
}

@end
