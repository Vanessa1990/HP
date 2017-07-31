//
//  LocalBimService+Model.m
//  GTiPhone
//
//  Created by 尤维维 on 2017/6/30.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService+Model.h"
#import "GTMouldModel.h"

@implementation LocalBimService (Model)

/**同步所有模型*/
- (SHXPromise *)setAllModel:(NSArray *)modelArray {
    return [self setBaseArray:modelArray tableName:ModelTable];
}
/**获取本地所有模型*/
- (SHXPromise *)getAllLocalModel:(NSString *)projectId {
    return [self getLocalBase:ModelTable modelClass:[GTMouldModel new] unarchiveKeys:@[@"infoModelFile"] searchDict:@{@"projectId" : projectId}];
}
/**获取某条模型*/
- (SHXPromise *)getLocalModel:(NSString *)modelId {
    return [[self getLocalBase:ModelTable modelClass:[GTMouldModel new] unarchiveKeys:@[@"infoModelFile"]  searchDict:@{@"_id" : modelId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

@end
