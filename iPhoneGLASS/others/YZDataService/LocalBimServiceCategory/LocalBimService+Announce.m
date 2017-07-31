//
//  LocalBimService+Announce.m
//  GTiPhone
//
//  Created by 尤维维 on 2017/6/27.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService+Announce.h"
#import "AnnounceModel.h"

@implementation LocalBimService (Announce)

/**同步所有公告*/
- (SHXPromise *)setAllAnnounce:(NSArray *)announceArray {
    return [self setBaseArray:announceArray tableName:AnnounceTable];
}

/**获取本地所有公告*/
- (SHXPromise *)getAllLocalAnnounce:(NSString *)projectId {
    return [self getLocalBase:AnnounceTable modelClass:[AnnounceModel new] unarchiveKeys:@[@"pictures"] searchDict:@{@"projectId" : projectId}];
}

/**获取某条公告*/
- (SHXPromise *)getLocalAnnounce:(NSString *)announceId {
    return [[self getLocalBase:AnnounceTable modelClass:[AnnounceModel new] unarchiveKeys:@[@"pictures"] searchDict:@{@"_id" : announceId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

@end
