//
//  LocalBimService+YZMould.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService+YZMould.h"

#import "EntityModel.h"
#import "EntityInfoModel.h"
#import "SelectionSetModel.h"

@implementation LocalBimService (YZMould)

#pragma mark Entity ExpandProperties API

/**同步构件扩展属性*/
- (SHXPromise *)setLocalEntityExpandProperties:(NSArray *)entityDicArray projectId:(NSString *)projectId
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    if (![databaseManager openDatabase]) {
        [promise reject:[NSError errorWithDomain:@"open db failed" code:500 userInfo:nil]];
        NSLog(@"open db failed");
        return promise;
    }
    
    NSMutableArray *insertArray = [NSMutableArray array];
    
    Underscore.arrayEach(entityDicArray, ^(EntityModel *key) {
        [insertArray addObject:[key representationToLocalData]];
        //        NSLog(@"新增构件扩展属性:%@", key.entityId);
    });
    [databaseManager insertRecordWithinsertArray:insertArray toTable:EntityTable projectId:projectId userId:nil];
    
    [promise fulfill:entityDicArray];
    return promise;
}

/**保存构件扩展属性*/
- (SHXPromise *)setLocalExpandProperties:(EntityModel *)entityModel projectId:(NSString *)projectId
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    if (![databaseManager openDatabase]) {
        [promise reject:[NSError errorWithDomain:@"open db failed" code:500 userInfo:nil]];
        NSLog(@"open db failed");
        return promise;
    }
    
    [databaseManager removeRecordWithColumns:@{@"entityId" : entityModel.entityId, @"projectId" : entityModel.projectId} fromTable:EntityTable];
    [databaseManager insertRecordWithColumns:[entityModel representationToLocalData] toTable:EntityTable];
    
    [promise fulfill:entityModel];
    return promise;
}

/**获得构件扩展属性*/
- (SHXPromise *)getLocalExpandProperties:(NSString *)entityID projectId:(NSString *)projectId
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    if (![databaseManager openDatabase]) {
        return nil;
    }
    
    FMResultSet *rs = [databaseManager findColumnNames:nil recordsWithColumns:@{@"entityId" : entityID, @"projectId": projectId} fromTable:EntityTable];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSArray *keys = [EntityModel localFileKeys];
    
    while ([rs next]) {
        Underscore.arrayEach(keys, ^(id key) {
            if ([key isEqualToString:@"properties"]) {
                [dic setObject:[rs dataForColumn:key] forKey:key];
            } else {
                if ([rs stringForColumn:key]) {
                    [dic setObject:[rs stringForColumn:key] forKey:key];
                }
            }
        });
    }
    
    [promise fulfill:[EntityModel entityWithLocalData:dic]];
    return promise;
}

#pragma mark EntityInfo

/**
 *  同步构件信息
 *
 *  @param entityInfoModels 构件信息数组
 *  @param projectId        工程id
 *
 *  @return promise : NSArray
 */
- (SHXPromise *)setLocalEntityInfos:(NSArray *)entityInfoModels projectId:(NSString *)projectId
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    if (![databaseManager openDatabase]) {
        [promise reject:[NSError errorWithDomain:@"open db failed" code:500 userInfo:nil]];
        NSLog(@"open db failed");
        return promise;
    }
    
    NSMutableArray *insertArray = [NSMutableArray array];
    
    Underscore.arrayEach(entityInfoModels, ^(EntityInfoModel *key) {
        [insertArray addObject:[key representationToLocalData]];
        //        NSLog(@"新增构件信息:%@", key.uuid);
    });
    [databaseManager insertRecordWithinsertArray:insertArray toTable:EntityInfoTable projectId:projectId userId:nil];
    
    [promise fulfill:entityInfoModels];
    return promise;
}

/**
 *  同步单个构件信息
 *
 *  @param entityInfoModel 构件信息模型
 *  @param projectId       工程id
 *
 *  @return promise : EntityInfoModel
 */
- (SHXPromise *)setLocalEntityInfo:(EntityInfoModel *)entityInfoModel projectId:(NSString *)projectId
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    if (![databaseManager openDatabase]) {
        [promise reject:[NSError errorWithDomain:@"open db failed" code:500 userInfo:nil]];
        NSLog(@"open db failed");
        return promise;
    }
    
    [databaseManager removeRecordWithColumns:@{@"modelId" : entityInfoModel.modelId, @"projectId" : entityInfoModel.projectId} fromTable:EntityInfoTable];
    [databaseManager insertRecordWithColumns:[entityInfoModel representationToLocalData] toTable:EntityInfoTable];
    
    [promise fulfill:entityInfoModel];
    return promise;
}

/**
 *  通过构件uuid获取构件信息
 *
 *  @param entityIdArray  构件uuidArray
 *  @param projectId 工程id
 *
 *  @return promise : NSArray
 */
- (SHXPromise *)getLocalEntityInfoByEntityId:(NSArray *)entityIdArray projectId:(NSString *)projectId
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    if (![databaseManager openDatabase]) {
        return nil;
    }
    
    NSArray *keys = [EntityInfoModel localFileKeys];
    NSMutableArray *entityInfoArray = [NSMutableArray array];
    
    for (NSString *entityId in entityIdArray) {
        FMResultSet *rs = [databaseManager findColumnNames:nil recordsWithColumns:@{@"uuid" : entityId, @"projectId": projectId} fromTable:EntityInfoTable];
        while ([rs next]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            Underscore.arrayEach(keys, ^(id key) {
                if ([key isEqualToString:@"modelsArray"]) {
                    [dic setObject:[rs dataForColumn:key] forKey:key];
                } else {
                    if ([rs stringForColumn:key]) {
                        [dic setObject:[rs stringForColumn:key] forKey:key];
                    }
                }
            });
            [entityInfoArray addObject:[EntityInfoModel entityInfoModelWithLocalData:dic]];
        }
    }
    
    [promise fulfill:entityInfoArray];
    return promise;
}

/**
 *  通过二维码获取构件信息
 *
 *  @param code      二维码
 *  @param projectId 工程id
 *
 *  @return promise : NSArray
 */
- (SHXPromise *)getLocalEntityInfoByCode:(NSString *)code projectId:(NSString *)projectId
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    if (![databaseManager openDatabase]) {
        return nil;
    }
    
    FMResultSet *rs = [databaseManager findColumnNames:nil recordsWithColumns:@{@"code" : code, @"projectId": projectId} fromTable:EntityInfoTable];
    
    NSArray *keys = [EntityInfoModel localFileKeys];
    NSMutableArray *entityInfoArray = [NSMutableArray array];
    
    while ([rs next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        Underscore.arrayEach(keys, ^(id key) {
            if ([key isEqualToString:@"modelsArray"]) {
                [dic setObject:[rs dataForColumn:key] forKey:key];
            } else {
                if ([rs stringForColumn:key]) {
                    [dic setObject:[rs stringForColumn:key] forKey:key];
                }
            }
        });
        [entityInfoArray addObject:[EntityInfoModel entityInfoModelWithLocalData:dic]];
    }
    
    [promise fulfill:entityInfoArray];
    return promise;
}

#pragma mark SelectionSet

/**
 *  同步选择集
 *
 *  @param SelectionSetModels 选择集数组
 *  @param projectId          工程id
 *
 *  @return promise : NSArray
 */
- (SHXPromise *)setLocalSelectionSets:(NSArray *)SelectionSetModels projectId:(NSString *)projectId
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    if (![databaseManager openDatabase]) {
        [promise reject:[NSError errorWithDomain:@"open db failed" code:500 userInfo:nil]];
        NSLog(@"open db failed");
        return promise;
    }
    
    NSMutableArray *insertArray = [NSMutableArray array];
    
    Underscore.arrayEach(SelectionSetModels, ^(SelectionSetModel *key) {
        [insertArray addObject:[key representationToLocalData]];
        //        NSLog(@"新增选择集:%@", key.uuid);
    });
    [databaseManager insertRecordWithinsertArray:insertArray toTable:SelectionSetTable projectId:projectId userId:nil];
    
    [promise fulfill:SelectionSetModels];
    return promise;
}

/**
 *  同步单个选择集
 *
 *  @param SelectionSetModel 选择集模型
 *  @param projectId         工程id
 *
 *  @return promise : SelectionSetModel
 */
- (SHXPromise *)setLocalSelectionSet:(SelectionSetModel *)selectionSetModel projectId:(NSString *)projectId
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    if (![databaseManager openDatabase]) {
        [promise reject:[NSError errorWithDomain:@"open db failed" code:500 userInfo:nil]];
        NSLog(@"open db failed");
        return promise;
    }
    
    [databaseManager removeRecordWithColumns:@{@"modelId" : selectionSetModel.modelId, @"projectId" : selectionSetModel.projectId} fromTable:SelectionSetTable];
    [databaseManager insertRecordWithColumns:[selectionSetModel representationToLocalData] toTable:SelectionSetTable];
    
    [promise fulfill:selectionSetModel];
    return promise;
}

/**
 通过选择集id获取选择集
 
 @param modelId   选择集id
 @param projectId 工程id
 
 @return promise : NSArray
 */
- (SHXPromise *)getLocalSelectionSetBySelectionSetModelId:(NSString *)modelId projectId:(NSString *)projectId
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    if (![databaseManager openDatabase]) {
        return nil;
    }
    
    FMResultSet *rs = [databaseManager findColumnNames:nil recordsWithColumns:@{@"modelId" : modelId, @"projectId": projectId} fromTable:SelectionSetTable];
    
    NSArray *keys = [SelectionSetModel localFileKeys];
    NSMutableArray *selectionSetArray = [NSMutableArray array];
    
    while ([rs next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        Underscore.arrayEach(keys, ^(id key) {
            if ([key isEqualToString:@"entityUuids"] ||
                [key isEqualToString:@"properties"] ||
                [key isEqualToString:@"spreadsheetIds"] ||
                [key isEqualToString:@"documentIds"]) {
                [dic setObject:[rs dataForColumn:key] forKey:key];
            } else {
                if ([rs stringForColumn:key]) {
                    [dic setObject:[rs stringForColumn:key] forKey:key];
                }
            }
        });
        [selectionSetArray addObject:[SelectionSetModel selectionSetModelWithLocalData:dic]];
    }
    
    [promise fulfill:selectionSetArray];
    return promise;
}

/**
 *  通过二维码获取选择集
 *
 *  @param code      二维码
 *  @param projectId 工程id
 *
 *  @return promise : NSArray
 */
- (SHXPromise *)getLocalSelectionSetByCode:(NSString *)code projectId:(NSString *)projectId
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    if (![databaseManager openDatabase]) {
        return nil;
    }
    
    FMResultSet *rs = [databaseManager findColumnNames:nil recordsWithColumns:@{@"qrCode" : code, @"projectId": projectId} fromTable:SelectionSetTable];
    
    NSArray *keys = [SelectionSetModel localFileKeys];
    NSMutableArray *selectionSetArray = [NSMutableArray array];
    
    while ([rs next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        Underscore.arrayEach(keys, ^(id key) {
            if ([key isEqualToString:@"entityUuids"] ||
                [key isEqualToString:@"properties"] ||
                [key isEqualToString:@"spreadsheetIds"] ||
                [key isEqualToString:@"documentIds"]) {
                [dic setObject:[rs dataForColumn:key] forKey:key];
            } else {
                if ([rs stringForColumn:key]) {
                    [dic setObject:[rs stringForColumn:key] forKey:key];
                }
            }
        });
        [selectionSetArray addObject:[SelectionSetModel selectionSetModelWithLocalData:dic]];
    }
    
    [promise fulfill:selectionSetArray];
    return promise;
}

@end
