//
//  LocalBimService+QRCode.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService+QRCode.h"

#import "QRModel.h"

@implementation LocalBimService (QRCode)

/**同步二维码表*/
- (SHXPromise *)setLocalQR:(NSArray *)qrArray projectID:(NSString *)projectID
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    [databaseManager openDatabase];
    
    NSMutableArray *insertArray = [NSMutableArray array];
    
    Underscore.arrayEach(qrArray, ^(QRModel *key) {
        [insertArray addObject:[key representationToLocalData]];
        //        NSLog(@"新增二维码 %@", key.code);
    });
    [databaseManager insertRecordWithinsertArray:insertArray toTable:QRTable projectId:projectID userId:nil];
    
    [promise fulfill:qrArray];
    return promise;
}

/**
 *  删除二维码
 *
 *  @param materialIds 二维码id数组
 *
 *  @return 二维码id数组
 */
- (SHXPromise *)delLocalQRs:(NSArray *)qrIds
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *qrId in qrIds) {
        [array addObject:@{@"modelID" : qrId}];
    }
    
    DatabaseManager *databaseManager = [DatabaseManager instance];
    [databaseManager openDatabase];
    [databaseManager removeRecordWithinsertArray:array fromTable:QRTable];
    
    [promise fulfill:qrIds];
    return promise;
}

/**查询某个二维码*/
- (QRModel *)getQRModel:(NSString *)modelID projectID:(NSString *)projectID
{
    if (!modelID) {
        return nil;
    }
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    [databaseManager openDatabase];
    FMResultSet *rs = [databaseManager findColumnNames:nil recordsWithColumns:@{@"modelID" : modelID, @"projectId" : projectID} fromTable:QRTable];
    
    NSArray *keys = [QRModel localFileKeys];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    while ([rs next]) {
        Underscore.arrayEach(keys, ^(id key) {
            if ([rs stringForColumn:key]) {
                [dic setObject:[rs stringForColumn:key] forKey:key];
            }
        });
        
        QRModel *model = [QRModel modelWithLocalData:dic];
        [dic removeAllObjects];
        return model;
    }
    return nil;
}

/**通过二维码查询二维码记录*/
- (QRModel *)getQRModelByCode:(NSString *)code projectID:(NSString *)projectID
{
    if (!code) {
        return nil;
    }
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    [databaseManager openDatabase];
    FMResultSet *rs = [databaseManager findColumnNames:nil recordsWithColumns:@{@"code" : code, @"projectId" : projectID} fromTable:QRTable];
    
    NSArray *keys = [QRModel localFileKeys];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    while ([rs next]) {
        Underscore.arrayEach(keys, ^(id key) {
            if ([rs stringForColumn:key]) {
                [dic setObject:[rs stringForColumn:key] forKey:key];
            }
        });
        
        QRModel *model = [QRModel modelWithLocalData:dic];
        [dic removeAllObjects];
        return model;
    }
    return nil;
}

/**通过构件查询二维码记录*/
- (QRModel *)getLocalQRModelByEntityUUID:(NSString *)uuid projectID:(NSString *)projectID
{
    if (!uuid || !projectID) {
        return nil;
    }
    
    DatabaseManager* databaseManager = [DatabaseManager instance];
    [databaseManager openDatabase];
    FMResultSet *rs = [databaseManager findColumnNames:nil recordsWithColumns:@{@"rId" : uuid, @"type":@"entity", @"projectId" : projectID} fromTable:QRTable];
    
    NSArray *keys = [QRModel localFileKeys];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    while ([rs next]) {
        Underscore.arrayEach(keys, ^(id key) {
            if ([rs stringForColumn:key]) {
                [dic setObject:[rs stringForColumn:key] forKey:key];
            }
        });
        
        QRModel *model = [QRModel modelWithLocalData:dic];
        [dic removeAllObjects];
        return model;
    }
    return nil;
}

@end
