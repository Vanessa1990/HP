//
//  RepoLocal+SQLHelper.m
//  BIM
//
//  Created by Dev on 15/5/19.
//  Copyright (c) 2015年 Pu Mai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

/**数据库管理类*/
@interface DatabaseManager : NSObject

+ (DatabaseManager*)instance;

- (instancetype)initWithPath:(NSString *)path;
- (DatabaseManager *)initYzPropertyWithPath:(NSString *)path;

- (BOOL)openDatabase;
- (BOOL)closeDatabase;

/**建表*/
- (void)createTableWithName:(NSString *)name primaryKey:(NSString *)key type:(NSString *)type otherColumn:(NSDictionary *)dict;
/**删表*/
- (void)deleteTable:(NSString *)tableName;

/**插入记录*/
- (BOOL)insertRecordWithColumns:(NSDictionary *)dict toTable:(NSString *)tableName;
- (void)insertRecordWithinsertArray:(NSArray *)insertArray toTable:(NSString *)tableName projectId:(NSString *)projectId userId:(NSString *)userId;

/**更新记录*/
- (BOOL)updateRecordWithColumns:(NSDictionary *)dict fromTable:(NSString *)tableName inPathDic:(NSDictionary *)pathDic;

/**删除记录*/
- (BOOL)removeRecordWithColumns:(NSDictionary *)dict fromTable:(NSString *)tableName;

/**删除全部记录*/
- (BOOL)removeAllTable:(NSString *)tableName;

/**删除多条记录*/
- (void)removeRecordWithinsertArray:(NSArray *)removeArray fromTable:(NSString *)tableName;

/**查找记录*/
- (FMResultSet *)findColumnNames:(NSArray *)names recordsWithColumns:(NSDictionary *)dict fromTable:(NSString *)tableName;
/**查找记录2*/
- (FMResultSet *)findColumnNames:(NSArray *)names recordsWithNullColumns:(NSString *)key fromTable:(NSString *)tableName;

/**查找某个记录存储时间，返回这时间距离现在多久*/
- (NSTimeInterval)timeIntervalForColumns:(NSDictionary *)dict fromTable:(NSString *)tableName;

@end
