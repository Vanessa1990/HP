//
//  LocalBimService+Project.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService+Project.h"

#import "ProjectModel.h"

@implementation LocalBimService (Project)

/**获得本地工程列表*/
- (SHXPromise *)getLocalProjects:(NSString *)userID
{
    // 1.获取该用户拥有的工程ID数组
    NSArray *array = [self getObjectWithProjectId:@"projectList" userId:userID fileName:@"projectsArray"];
    
    NSMutableArray *projectArray = [[NSMutableArray alloc] init];
    for (NSString *projectId in array) {
        ProjectModel *model = [self getLocalProjectModel:projectId];
        model.projectId?[projectArray addObject:model]:0;
    }
    
    SHXPromise *promise = [[SHXPromise alloc] init];
    [promise fulfill:projectArray];
    return promise;
}

- (ProjectModel *)getLocalProjectModel:(NSString *)projectId
{
    DatabaseManager* databaseManager = [DatabaseManager instance];
    [databaseManager openDatabase];
    FMResultSet *rs = [databaseManager findColumnNames:nil recordsWithColumns:@{@"_id" : projectId} fromTable:ProjectTable];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSArray *keys = [ProjectModel allPropertyNames];

    while ([rs next]) {
        Underscore.arrayEach(keys, ^(id key) {
            if ([rs stringForColumn:key]) {
                [dic setObject:[rs stringForColumn:key] forKey:key];
            }
        });
    }

    return [ProjectModel mj_objectWithKeyValues:dic];
}

/**同步本地工程列表*/
- (SHXPromise *)setLocalProjects:(NSArray *)projectArray userID:(NSString *)userID
{
    // 工程列表存入本地数据库
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    [databaseManager openDatabase];
    
    // 工程ID数组
    NSMutableArray *projectIdArray = [[NSMutableArray alloc] init];
    // 项目字典数组
    NSMutableArray *projectDicArray = [[NSMutableArray alloc] init];
    // 更新项目字典
    NSMutableArray *reProjectDicArray = [[NSMutableArray alloc] init];
    
    Underscore.arrayEach(projectArray, ^(NSDictionary *key) {
        [reProjectDicArray addObject:@{@"_id" : key[@"_id"]}];
        [projectDicArray addObject:key];
        [projectIdArray addObject:key[@"_id"]];
    });
    
    // 删除旧的
    [databaseManager removeRecordWithinsertArray:reProjectDicArray fromTable:ProjectTable];
    // 插入数据库
    [databaseManager insertRecordWithinsertArray:projectDicArray toTable:ProjectTable projectId:nil userId:nil];
    // 保存该用户拥有的工程ID数组
    [self setObject:projectIdArray projectId:@"projectList" userId:userID fileName:@"projectsArray"];
    
    [promise fulfill:projectArray];
    return promise;
}

/**更新本地工程*/
- (SHXPromise *)updateLocalProject:(ProjectModel *)projectModel
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    [databaseManager openDatabase];
    
    [databaseManager removeRecordWithColumns:@{@"_id" : projectModel.projectId} fromTable:ProjectTable];
    //    [databaseManager insertRecordWithColumns:[projectModel representationToLocalData] toTable:ProjectTable];
    
    [promise fulfill:projectModel];
    return promise;
}

/**删除工程下所有信息*/
- (void)delLocalProject:(NSString *)projectID
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:[NSString stringWithFormat:@"%@_materials", projectID]];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    //    [databaseManager removeRecordWithColumns:@{@"projectId" : projectID} fromTable:ProjectTable];
    [databaseManager removeRecordWithColumns:@{@"_id" : projectID} fromTable:EntityTable];
}

@end
