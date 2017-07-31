//
//  LocalBimService+Problem.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService+Problem.h"
#import "ProblemModel.h"
#import "IssueTypeModel.h"

@implementation LocalBimService (Problem)

/**同步问题类型*/
- (SHXPromise *)setIssueType:(NSArray *)issues
{
    return [self setBaseArray:issues tableName:IssueTable];
    
}

/**获取所有问题类型*/
- (SHXPromise *)getAllIssueType:(NSString *)projectId
{
    return [self getLocalBase:IssueTable modelClass:[IssueTypeModel new] searchDict:@{@"projectId" : projectId}];
}

/**获取单个问题类型*/
- (SHXPromise *)getIssueType:(NSString *)issueId {
    return [[self getLocalBase:IssueTable modelClass:[IssueTypeModel new] searchDict:@{@"_id" : issueId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

/**同步问题*/
- (SHXPromise *)setAllProblem:(NSArray *)problems {
    return [self setBaseArray:problems tableName:ProblemTable];
}

/**获取all问题*/
- (SHXPromise *)getAllProblem:(NSString *)projectId {
    return [self getLocalBase:ProblemTable modelClass:[ProblemModel new] unarchiveKeys:@[@"examined",@"handled",@"pictures",@"documentIds"] searchDict:@{@"projectId" : projectId}];
}

/**获取相关问题*/
- (SHXPromise *)getProblemWithSearchDict:(NSDictionary *)searchDict {
    return [self getLocalBase:ProblemTable modelClass:[ProblemModel new] unarchiveKeys:@[@"examined",@"handled",@"pictures",@"documentIds"] searchDict:searchDict];
}

/**获取某个问题*/
- (SHXPromise *)getProblem:(NSString *)problemId {
    return [[self getLocalBase:ProblemTable modelClass:[ProblemModel new]  unarchiveKeys:@[@"examined",@"handled",@"pictures",@"documentIds"]  searchDict:@{@"_id" : problemId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

/**获取某个图钉问题*/
- (SHXPromise *)getProblemForPin:(NSString *)pinId {
    return [[self getLocalBase:ProblemTable modelClass:[ProblemModel new]  unarchiveKeys:@[@"examined",@"handled",@"pictures"]  searchDict:@{@"drawingPin" : pinId}] onFulfilled:^id(NSArray *value) {
        return value;
    }];
}


/**保存离线问题类型*/
- (SHXPromise *)saveOfflineProblem:(NSDictionary *)problemDict {
    
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    [databaseManager openDatabase];
    
    NSMutableArray *DicArray = [[NSMutableArray alloc] init];
    [DicArray addObject:problemDict];
    
    // 插入数据库
    [databaseManager insertRecordWithinsertArray:DicArray toTable:OfflineProblemTable projectId:nil userId:nil];
    [promise fulfill:DicArray];
    return promise;
    
}

/**获取离线问题类型*/
- (SHXPromise *)getOfflineProblem:(NSString *)projectId createBy:(NSString *)createBy {
    
    SHXPromise *promise = [SHXPromise new];
    if (!projectId || !createBy) {
        [promise reject:[NSError errorWithDomain:@"SEARCHKEY IS NULL" code:401 userInfo:nil]];
        return promise;
    }
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    if (![databaseManager openDatabase]) {
        YZLog(@"open db failed");
        [promise reject:[NSError errorWithDomain:@"open db failed" code:401 userInfo:nil]];
        return promise;
    }
    
    FMResultSet *rs = [databaseManager findColumnNames:nil recordsWithColumns:@{@"projectId" : projectId, @"createdBy": createBy} fromTable:OfflineProblemTable];
    
    NSArray *keys = @[@"content",@"createdAt",@"createdBy",@"location",@"handled",@"pictures",@"projectId",@"type"];
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    while ([rs next]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        Underscore.arrayEach(keys, ^(id key) {
            if ([key isEqualToString:@"handled"] || [key isEqualToString:@"pictures"] || [key isEqualToString:@"location"]){
                if ([rs dataForColumn:key]){
                    NSData *data = [rs dataForColumn:key];
                    id keyValue = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    keyValue?[dic setObject:keyValue forKey:key]:0;
                }
            }else{
                if ([rs stringForColumn:key]) {
                    [dic setObject:[rs stringForColumn:key] forKey:key];
                }
            }
            
        });
        
        [newArray addObject:dic];
    }
    if (newArray.count) {
        [promise fulfill:newArray];
        return promise;
    }else{
        [promise fulfill:@[]];
        return promise;
    }

}

/**删除离线问题*/
- (BOOL)deleteOfflineProblem:(NSDictionary *)problemDict {
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    [databaseManager openDatabase];
    BOOL delete = [databaseManager removeRecordWithColumns:@{@"content":problemDict[@"content"]} fromTable:OfflineProblemTable];
    return delete;
}

@end
