//
//  QYCommentModel.m
//  WeiBo
//
//  Created by qingyun on 15-5-7.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYCommentModel.h"
#import "QYUtilities.h"
#import "QYUserModel.h"

@implementation QYCommentModel

-(instancetype)initCommentWithInfo:(NSDictionary *)commentInfo{
    self = [super init];
    if (self) {
        //初始化属性
        NSString *dateString = [commentInfo objectForKey:kCommontCreated_at];
        
        self.createdAt = [QYUtilities weiboDateWithString:dateString];
        
        self.source = [QYUtilities sourceWithString:commentInfo[kCommontSource]];
        self.commentId = commentInfo[kCommontID];
        self.commntUser = [[QYUserModel alloc] initWithDictionary:commentInfo[kCommontUser]];
        self.text = commentInfo[kCommontText];
        NSDictionary *replyComment = commentInfo[kCommontReply_comment];
        if (replyComment) {
            self.replyComment = [[QYCommentModel alloc] initCommentWithInfo:replyComment];
        }
    }
    return self;
}

@end
