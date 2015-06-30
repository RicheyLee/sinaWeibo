//
//  QYStatusModel.h
//  WeiBo
//
//  Created by qingyun on 15-4-26.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QYUserModel;
@interface QYStatusModel : NSObject

@property(nonatomic, strong) QYUserModel *user;
@property(nonatomic, strong) NSNumber *status_id;
@property(nonatomic, strong) NSString *source;
@property(nonatomic, strong) NSDate *created_at;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSArray *pic_urls;
@property(nonatomic) NSInteger reposts_count;
@property(nonatomic) NSInteger comments_count;
@property(nonatomic) NSInteger attitudes_count;
@property(nonatomic, strong) QYStatusModel *reStatus;

@property (nonatomic)NSString *reStatusText;

@property(nonatomic)NSString *timeAgo;//显示的多长时间前创建的微博



//初始化model
-(instancetype)initWithDictionary:(NSDictionary *)statusInfo;

@end
