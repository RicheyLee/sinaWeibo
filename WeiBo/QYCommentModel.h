//
//  QYCommentModel.h
//  WeiBo
//
//  Created by qingyun on 15-5-7.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

//created_at	string	评论创建时间
//id	int64	评论的ID
//text	string	评论的内容
//source	string	评论的来源
//user	object	评论作者的用户信息字段 详细
//status	object	评论的微博信息字段 详细
//reply_comment object	评论来源评论，当本评论属于对另一评论的回复时返回此字段

#import <Foundation/Foundation.h>

@class QYUserModel;
@interface QYCommentModel : NSObject

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) QYUserModel *commntUser;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) QYCommentModel *replyComment;

-(instancetype)initCommentWithInfo:(NSDictionary *)commentInfo;
@end
