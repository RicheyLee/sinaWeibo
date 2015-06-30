//
//  QYDataBaseEngine.m
//  WeiBo
//
//  Created by qingyun on 15-4-27.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYDataBaseEngine.h"
#import "FMDB.h"
#import "QYStatusModel.h"

#define kDatabaseName @"status.db"
#define kStatusTableName @"status"

//保存table的字段数组
static NSArray *statusTableColumn;

@implementation QYDataBaseEngine

#pragma mark - creat database

+(void)initialize{
    //创建数据库数据库
    [QYDataBaseEngine copyDatabaseToDocuments];
    
    //得到status的字段数组
    statusTableColumn = [QYDataBaseEngine tableColumn:kStatusTableName];
    
}

+(NSString *)DatabasePath{
    //查找documents文件路径，
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //数据库文件的路径
    return [documentsPath stringByAppendingPathComponent:kDatabaseName];
}

+(void)copyDatabaseToDocuments{
    //判断documents下有没有数据库
    NSString *dataPath = [QYDataBaseEngine DatabasePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:dataPath]) {
        //找到man bundle下数据库的路径
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"status" ofType:@"db"];
        //copy 到 documents下
        [manager copyItemAtPath:sourcePath toPath:dataPath error:nil];
    }
    
}

#pragma mark - save data

//查询表中所有字段
+(NSArray *)tableColumn:(NSString *)table{
    FMDatabase *db = [FMDatabase databaseWithPath:[QYDataBaseEngine DatabasePath]];
    [db open];
    //将名字转化为全小写
    NSString *tableName = [table lowercaseString];
    //使用Database的扩展方法，查询字段名字
    FMResultSet *result = [db getTableSchema:tableName];
    //接收查询的结果
    NSMutableArray *columnArray = [NSMutableArray array];
    while ([result next]) {
        [columnArray addObject:[result stringForColumn:@"name"]];
    }
    [result close];
    [db close];
    return columnArray;
    
}

//创建插入语句，table column ，插入的数据

+(NSString *)createInsertSql4Table:(NSString *)table valueDictionary:(NSDictionary *)values{
    //得到插入的数据的key的集合
    NSArray *dicKayArray = [values allKeys];
    
    // 构造insert into tableName (column1, column2) values(:column1, :column2)
    //构造column
    NSString *columnString = [dicKayArray componentsJoinedByString:@", "];
    
    //构造key
    NSString *keyString = [dicKayArray componentsJoinedByString:@", :"];
    keyString = [@":" stringByAppendingString:keyString];
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@(%@) values(%@)", table, columnString, keyString];

    return sql;
}

+(void)saveStatusToDatabase:(NSArray *)statusArray{
    NSString *dbPath = [QYDataBaseEngine DatabasePath];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [queue inDatabase:^(FMDatabase *db) {
        for (NSDictionary *statusInfo in statusArray) {
            //过滤字典中无用的值
            NSMutableDictionary *muStatusInfo = [NSMutableDictionary dictionaryWithDictionary:statusInfo];
            NSArray *allKey = [statusInfo allKeys];
            for (NSString *key in allKey) {
                //判断key是否在数据库中存在
                if (![statusTableColumn containsObject:key]) {
                    [muStatusInfo removeObjectForKey:key];
                }else{
                    //如果存在, 取出来内容，判断类型是否需要归档
                    id object = statusInfo[key];
                    
                    if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
                        [muStatusInfo setObject:data forKey:key];
                    }
                }
                
            }
            NSString *sql = [QYDataBaseEngine createInsertSql4Table:kStatusTableName valueDictionary:muStatusInfo];
//            执行插入语句
            BOOL result = [db executeUpdate:sql withParameterDictionary:muStatusInfo];
        }
    }];
}

#pragma mark - select

+(NSArray *)statusArrayFromDataBase{
    NSString *dbPath = [QYDataBaseEngine DatabasePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    //查询语句
    NSString *sql = @"select * from status order by id desc limit 20";
    
    //执行查询
    FMResultSet *result = [db executeQuery:sql];
    NSMutableArray *modelArray = [NSMutableArray array];
    while ([result next]) {
        //将结果转化为字典
        NSDictionary *statusInfo = [result resultDictionary];
        //转化为model并且保存
        QYStatusModel *statusModel = [[QYStatusModel alloc] initWithDictionary:statusInfo];
        [modelArray addObject:statusModel];
    }
    return modelArray;
}


@end
