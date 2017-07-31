//
//  LocalBimService+Account.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService+Account.h"

#import "AccountModel.h"

@implementation LocalBimService (Account)

- (SHXPromise *)insertLocalAccountWithAccount:(AccountModel *)accountModel
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    if ([Utils isNilOrNull:accountModel]) {
        [promise reject:[NSError errorWithDomain:@"reportModel can not be nil" code:500 userInfo:nil]];
        return promise;
    }
    
    NSDictionary *localSaveData = [accountModel parseModelToDataWithState:YZDatabaseAccountData];
    
    if ([[DatabaseManager instance] insertRecordWithColumns:localSaveData toTable:AccountTable]) {
        [promise fulfill:accountModel];
    } else {
        [promise reject:[NSError errorWithDomain:@"insert error" code:500 userInfo:nil]];
    }
    
    return promise;
}

- (SHXPromise *)getLocalAccountWithAccountID:(NSString *)accountID
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    AccountModel *databaseAccountModel = nil;
    
    FMResultSet *rs = [[DatabaseManager instance] findColumnNames:nil recordsWithColumns:@{@"_id":accountID} fromTable:AccountTable];
    NSArray *keys = [AccountModel localFileKeys];
    
    while ([rs next]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        Underscore.arrayEach(keys, ^(id key) {
            if ([key isEqualToString:@"accountInfo"] && [rs dataForColumn:key]) {
                [dic setObject:[rs dataForColumn:key] forKey:key];
            } else if ([rs stringForColumn:key]) {
                [dic setObject:[rs stringForColumn:key] forKey:key];
            }
        });
        
        databaseAccountModel = [AccountModel parseDataToModel:dic state:YZDatabaseAccountData];
    }
    
    if (databaseAccountModel) {
        [promise fulfill:databaseAccountModel];
    } else {
        [promise reject:[NSError errorWithDomain:@"not find" code:400 userInfo:nil]];
    }
    
    return promise;
}

@end
