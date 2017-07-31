//
//  RepoLocal+SQLHelper.m
//  BIM
//
//  Created by Dev on 15/5/19.
//  Copyright (c) 2015年 Pu Mai. All rights reserved.
//

#import "DatabaseManager.h"

#define __INSERT_DATE_TIME @"__insert_date"
#define databasePath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/cache.db"]

@interface DatabaseManager()

@end

@implementation DatabaseManager {
    //数据库
    FMDatabase * _database;
    //线程锁
    NSLock * _lock;
}

+ (DatabaseManager*)instance
{
    static DatabaseManager* _instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[DatabaseManager alloc] initWithPath:databasePath];
        }
    });
    return _instance;
}

+ (DatabaseManager *)yzPropertyInstance
{
    static DatabaseManager* _yzProperty = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!_yzProperty)
        {
            _yzProperty = [[DatabaseManager alloc] init];
        }
    });
    
    return _yzProperty;
}

- (DatabaseManager *)initYzPropertyWithPath:(NSString *)path
{
    DatabaseManager* dm = [DatabaseManager yzPropertyInstance];
    return [dm initWithPath:path];
}

- (instancetype)initWithPath:(NSString *)path
{
    if (self = [super init]) {
        _database = [[FMDatabase alloc] initWithPath:path];
        //打开数据库，如果数据库不存在，创建数据库
//        BOOL ret = [_database open];
//        if (!ret) {
//            perror("缓存数据库打开");
//        }
        _lock = [[NSLock alloc] init];
     }
    return self;
}

/**
 *  开启数据库
*/
- (BOOL)openDatabase {
    BOOL ret = [_database open];
    return ret;
}

/**
 *  关闭数据库
 */
- (BOOL)closeDatabase {
    BOOL ret = [_database close];
    return ret;
}


/**建表*/
- (void)createTableWithName:(NSString *)name primaryKey:(NSString *)key type:(NSString *)type otherColumn:(NSDictionary *)dict
{
    [_lock lock];
    NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ DATETIME", name, __INSERT_DATE_TIME];

    
    for (NSString * columnName in dict) {
        sql = [sql stringByAppendingFormat:@", %@ %@", columnName, dict[columnName]];
    }
    
    if (type != nil) {
        sql = [sql stringByAppendingFormat:@", %@ %@ PRIMARY KEY", key, type];
        
    } else {
        sql = [sql stringByAppendingFormat:@", CONSTRAINT pk_ID PRIMARY KEY (%@)", key];
    }
    sql = [sql stringByAppendingString:@");"];
    
    BOOL ret = [_database executeUpdate:sql];
    if (ret == NO) {
        perror("建表错误");
    }
    
    [_lock unlock];
}

/**删表*/
- (void)deleteTable:(NSString *)tableName
{
    [_lock lock];
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    BOOL ret = [_database executeUpdate:sql];
    if (ret == NO)
    {
        perror("删表错误");
    }
    
    [_lock unlock];
}

/**插入记录*/
- (BOOL)insertRecordWithColumns:(NSDictionary *)dict toTable:(NSString *)tableName
{
    [_lock lock];
    
    NSString * columnNames = [dict.allKeys componentsJoinedByString:@", "];
    
    NSMutableArray * xArray = [NSMutableArray array];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    for (NSString * key in dict) {
#pragma clang diagnostic pop
        [xArray addObject:@"?"];
    }
    NSString * valueStr = [xArray componentsJoinedByString:@", "];
    
    NSString * sql = [NSString stringWithFormat:@"REPLACE INTO %@(%@, %@) VALUES(%@, ?);", tableName, columnNames, __INSERT_DATE_TIME, valueStr];
    
    BOOL ret = [_database executeUpdate:sql withArgumentsInArray:[dict.allValues arrayByAddingObject:[NSDate date]]];
    if (ret == NO) {
        perror("插入错误");
    }
    
    [_lock unlock];
    return ret;
}

/**插入多条记录*/
- (void)insertRecordWithinsertArray:(NSArray *)insertArray toTable:(NSString *)tableName projectId:(NSString *)projectId userId:(NSString *)userId
{
    [_lock lock];
    
    [_database beginTransaction];
    BOOL isRollBack = NO;
    @try {
        for (NSDictionary *dic in insertArray) {
            NSString * columnNames = [dic.allKeys componentsJoinedByString:@", "];
            
            NSMutableArray * xArray = [NSMutableArray array];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
            for (NSString * key in dic) {
#pragma clang diagnostic pop
                [xArray addObject:@"?"];
            }
            NSString *placeholders = [xArray componentsJoinedByString:@", "];
            
            NSString * sql;
            NSArray *arguments = dic.allValues;
            
            if (projectId) {
                sql = [NSString stringWithFormat:@"REPLACE INTO %@(%@, projectId, %@) VALUES(%@, ?, ?);", tableName, columnNames, __INSERT_DATE_TIME, placeholders];
                arguments = [arguments arrayByAddingObject:projectId];
                arguments = [arguments arrayByAddingObject:[NSDate date]];
            } else {
                sql = [NSString stringWithFormat:@"REPLACE INTO %@(%@, %@) VALUES(%@, ?);", tableName, columnNames, __INSERT_DATE_TIME, placeholders];
                arguments = [arguments arrayByAddingObject:[NSDate date]];
            }
            
            BOOL ret = [_database executeUpdate:sql withArgumentsInArray:arguments];
            if (ret == NO) {
                perror("错误");
            }
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [_database rollback];
    }
    @finally {
        if (!isRollBack) {
            [_database commit];
        }
    }
    
    [_lock unlock];
}

/**
 *  更新记录
 *
 *  UPDATE table_name
 *  SET column1=value1,column2=value2,...
 *  WHERE some_column=some_value;
 */
- (BOOL)updateRecordWithColumns:(NSDictionary *)dict fromTable:(NSString *)tableName inPathDic:(NSDictionary *)pathDic
{
    [_lock lock];
    
    NSString *updateValues = [NSString string];
    NSString *updateKeys = [NSString string];
    
    BOOL isFrist = YES;
    for (NSString *key in dict) {
        if (isFrist) {
            updateValues = [updateValues stringByAppendingFormat:@"%@ = %@",key, dict[key]];
            isFrist = NO;
        } else {
            updateValues = [updateValues stringByAppendingFormat:@",%@ = %@",key, dict[key]];
        }
    }
    
    isFrist = YES;
    for (NSString *key in pathDic) {
        if (isFrist) {
            updateKeys = [updateKeys stringByAppendingFormat:@"%@ = %@",key, pathDic[key]];
            isFrist = NO;
        } else {
            updateKeys = [updateKeys stringByAppendingFormat:@" and %@ = %@",key, pathDic[key]];
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@;", tableName, updateValues ,updateKeys];
    
    NSLog(@"%@",sql);
    
    BOOL ret = [_database executeUpdate:sql];
    if (!ret) {
        perror("更新错误");
    }
    
    [_lock unlock];
    return ret;
}

/**删除记录*/
- (BOOL)removeRecordWithColumns:(NSDictionary *)dict fromTable:(NSString *)tableName
{
    [_lock lock];
    
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    
    BOOL isFirst = YES;
    for (NSString * key in dict) {
        if (isFirst) {
            sql = [sql stringByAppendingString:@" WHERE "];
            isFirst = NO;
        } else {
            sql = [sql stringByAppendingString:@" AND "];
        }
        sql = [sql stringByAppendingFormat:@"%@ = '%@'",key,dict[key]];
    }
    
    sql = [sql stringByAppendingString:@";"];
    BOOL ret = [_database executeUpdate:sql];
//    BOOL ret = [_database executeUpdate:sql withArgumentsInArray:dict.allValues];
    if (!ret) {
        perror("删除错误");
    }
    
    [_lock unlock];
    return ret;
}

/**删除全部记录*/
- (BOOL)removeAllTable:(NSString *)tableName
{
    [_lock lock];
    
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    
    sql = [sql stringByAppendingString:@";"];
    
    BOOL ret = [_database executeUpdate:sql];
    if (!ret) {
        perror("删除错误");
    }
    
    [_lock unlock];
    return ret;
}

/**删除多条记录*/
- (void)removeRecordWithinsertArray:(NSArray *)removeArray fromTable:(NSString *)tableName
{
    [_lock lock];
    
    [_database beginTransaction];
    BOOL isRollBack = NO;
    
    @try {
        for (NSDictionary *dict in removeArray) {
            NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
            
            BOOL isFirst = YES;
            for (NSString * key in dict) {
                if (isFirst) {
                    sql = [sql stringByAppendingString:@" WHERE "];
                    isFirst = NO;
                } else {
                    sql = [sql stringByAppendingString:@" AND "];
                }
                sql = [sql stringByAppendingFormat:@"%@ = '?'",key];
            }
            
            sql = [sql stringByAppendingString:@";"];
            
            BOOL ret = [_database executeUpdate:sql withArgumentsInArray:dict.allValues];
            
            if (!ret) {
                perror("删除错误");
            }
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [_database rollback];
    }
    @finally {
        if (!isRollBack) {
            [_database commit];
        }
    }
    
    [_lock unlock];
}


/**查找记录*/
- (FMResultSet *)findColumnNames:(NSArray *)names recordsWithColumns:(NSDictionary *)dict fromTable:(NSString *)tableName
{
    [_lock lock];
    
    NSString * colNames = nil;
    if (names == nil) {
        colNames = @"*";
    } else {
        colNames = [names componentsJoinedByString:@","];
    }
    
    NSString * sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", colNames, tableName];
    
    BOOL isFirst = YES;
    for (NSString * key in dict) {
        if (isFirst) {
            sql = [sql stringByAppendingString:@" WHERE "];
            isFirst = NO;
        } else {
            sql = [sql stringByAppendingString:@" AND "];
        }
        sql = [sql stringByAppendingFormat:@"%@ = ?",key];
    }
    
    sql = [sql stringByAppendingString:@";"];
    
    
    FMResultSet * set = [_database executeQuery:sql withArgumentsInArray:dict.allValues];
    
    [_lock unlock];
    
    return set;
}

/**查找记录*/
- (FMResultSet *)findColumnNames:(NSArray *)names recordsWithNullColumns:(NSString *)key fromTable:(NSString *)tableName
{
    [_lock lock];
    
    NSString * colNames = nil;
    if (names == nil) {
        colNames = @"*";
    } else {
        colNames = [names componentsJoinedByString:@","];
    }
    
    NSString * sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", colNames, tableName];
    sql = [sql stringByAppendingString:[NSString stringWithFormat:@" WHERE %@ is NULL ;",key]];

    FMResultSet * set = [_database executeQuery:sql ];
    
    [_lock unlock];
    
    return set;
}

/**查找某个记录存储时间，返回这时间距离现在多久*/
- (NSTimeInterval)timeIntervalForColumns:(NSDictionary *)dict fromTable:(NSString *)tableName
{
    FMResultSet * set = [self findColumnNames:@[__INSERT_DATE_TIME] recordsWithColumns:dict fromTable:tableName];
    
    NSDate * date = nil;
    if ([set next]) {
        date = [set dateForColumn:__INSERT_DATE_TIME];
    } else {
        date = [NSDate distantPast];
    }
    
    return -[date timeIntervalSinceNow];
}

@end
