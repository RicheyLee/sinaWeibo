//
//  QYStatusModel.m
//  WeiBo
//
//  Created by qingyun on 15-4-26.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYStatusModel.h"
#import "QYUserModel.h"
#import "QYUtilities.h"

@implementation QYStatusModel

-(instancetype)initWithDictionary:(NSDictionary *)statusInfo{
    self = [super init];
    if (self) {
        //设置属性
        //设置user属性
        NSDictionary *userInfo = statusInfo[kStatusUserInfo];
        
        //如果是从数据库中查询出来，则为nsdata类型
        if ([userInfo isKindOfClass:[NSData class]]) {
            userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)userInfo];
        }
        
        self.user = [[QYUserModel alloc] initWithDictionary:userInfo];
        self.source = [QYUtilities sourceWithString:statusInfo[kStatusSource]];
        self.status_id = statusInfo[kStatusID];
        
        
        NSString *dateString = statusInfo[kStatusCreateTime];
        
        self.created_at = [QYUtilities weiboDateWithString:dateString];
        
        self.text = statusInfo[kStatusText];
        self.pic_urls = statusInfo[kStatusPicUrls];
        //如果是从数据库中查询出来，则为nsdata类型
        if ([self.pic_urls isKindOfClass:[NSData class]]) {
            self.pic_urls = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)self.pic_urls];
        }
        
        self.reposts_count = [statusInfo[kStatusRepostsCount] integerValue];
        self.comments_count = [statusInfo[kStatusCommentsCount] integerValue];
        self.attitudes_count = [statusInfo[kStatusAttitudesCount] integerValue];
        
        //根据有无转发微博，创建微博对象
        NSDictionary *reStatusInfo = statusInfo[kStatusRetweetStatus];
        
        if (reStatusInfo && ![reStatusInfo isKindOfClass:[NSNull class]]) {
            
            //如果是从数据库中查询出来，则为nsdata类型
            if ([reStatusInfo isKindOfClass:[NSData class]]) {
                reStatusInfo = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)reStatusInfo];
            }
            self.reStatus = [[QYStatusModel alloc] initWithDictionary:reStatusInfo];
        }
        
    }
    
    return self;
}
//重写get方法
-(NSString *)timeAgo{
    //计算跟当前时间的时间差
    NSTimeInterval time = -[self.created_at timeIntervalSinceNow];
    
    if (time < 60) {
        return @"刚刚";
    }else if (time < 3600) {
        return [NSString stringWithFormat:@"%ld 分钟前", (NSInteger)time/60];
    }else if (time < 3600 * 24) {
        return [NSString stringWithFormat:@"%ld 小时前", (NSInteger)time/3600];
    }else if (time < 3600 * 24 * 30){
        return [NSString stringWithFormat:@"%ld 天前", (NSInteger)time/(3600 * 24)];
    }else{
        return [NSDateFormatter localizedStringFromDate:self.created_at dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    }
    
}

////"<a href=\"http://app.weibo.com/t/feed/5yiHuw\" rel=\"nofollow\">iPhone 6 Plus</a>"
////从这其中找出正文
////">.*<"
//
//-(NSString *)sourceWithString:(NSString *)string{
//    NSString *soure = nil;//保存结果；
//    //定义的正则表达式字符串
//    NSString *regExStr = @">.*<";
//    //排除无效的情况
//    if ([string isKindOfClass:[NSNull class]] || string == nil || [string isEqualToString:@""]) {
//        return @"";
//    }
//    //构造正则
//    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regExStr options:0 error:nil];
//    //查询出结果
//    NSTextCheckingResult *result = [expression firstMatchInString:string options:0 range:NSMakeRange(0, string.length -1)];
//    
//    //取出子字符串
//    if (result) {
//        NSRange range = [result rangeAtIndex:0];
//        soure = [string substringWithRange:NSMakeRange(range.location + 1, range.length - 2)];
//    }
//    return soure;
//}

-(NSString *)reStatusText{
    return [NSString stringWithFormat:@"@%@ %@",self.user.name, self.text];
}


@end
