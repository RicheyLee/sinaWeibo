//
//  QYDataBaseEngine.h
//  WeiBo
//
//  Created by qingyun on 15-4-27.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//处理数据库的创建、增加记录、查询记录

@interface QYDataBaseEngine : NSObject

//插入
+(void)saveStatusToDatabase:(NSArray *)statusArray;

//查询
+(NSArray *)statusArrayFromDataBase;

@end
