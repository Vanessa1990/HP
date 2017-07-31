//
//  BimService+YZMould.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService+YZMould.h"

#import "EntityModel.h"
#import "EntityInfoModel.h"
#import "SelectionSetModel.h"

@implementation BimService (YZMould)

#pragma mark - Entity(EntityProperties构件属性; EntityInfo构件信息)
// 模糊搜索Entity
- (SHXPromise *)getEntityBySearch:(NSString *)searchString project:(NSString *)projectId attach:(NSString *)attach
{
    // /projects/:id/entities?regex=查找值
    NSString *urlString = [NSString stringWithFormat:@"%@projects/%@/entities?regex=%@&%@", [self baseAPI], projectId, searchString, attach?attach:@""];
    return [AFNetworkingHelper getResource:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil];
}

// 获得构件属性(包括扩展属性和基本属性)
- (SHXPromise *)getEntityProperty:(NSString *)entityId project:(NSString *)projectId
{
    NSString *urlString = [NSString stringWithFormat:@"%@projects/%@/entities/%@/properties", [self baseAPI], projectId, entityId];
    return [[AFNetworkingHelper getResource:urlString parameters:nil] onFulfilled:^id(id value) {
        return value;
    }];
}

// 获得构件(有扩展属性)个数
- (SHXPromise *)getEntityCount:(NSString *)projectId attach:(NSString *)attach
{
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/extend_properties?only_count=true", [self baseAPI], projectId];
    if (attach) {
        url = [NSString stringWithFormat:@"%@&%@", url, attach];
    }
    
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 分页同步构件扩展属性
- (SHXPromise *)updateEntity:(NSString *)projectId attach:(NSString *)attach
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@projects/%@/extend_properties", [self baseAPI], projectId];
    if (attach) {
        requestUrl = [NSString stringWithFormat:@"%@?%@", requestUrl, attach];
    }
    
    return [[AFNetworkingHelper getResource:requestUrl parameters:nil] onFulfilled:^id(id value) {
        return Underscore.arrayMap(value, ^id(id item) {
            return [EntityModel entityWithData:item];
        });
    }];
}

// 获得单个构件扩展属性
- (SHXPromise *)getEntityExpandProperty:(NSString *)entityId projectId:(NSString *)projectId
{
    NSString *urlString = [NSString stringWithFormat:@"%@entities/%@/extend_property?projectid=%@", [self baseAPI], entityId, projectId];
    return [[AFNetworkingHelper getResource:urlString parameters:nil] onFulfilled:^id(id value) {
        return [EntityModel entityWithData:value];
    } rejected:^id(NSError *reason) {
        return reason;
    }];
}

/**
 *  获得构件信息变更数量
 *
 *  @param projectId 工程id
 *  @param attach    拼接字段
 *
 *  @return promise
 */
- (SHXPromise *)getEntityInfoCount:(NSString *)projectId attach:(NSString *)attach
{
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/entities_info?only_count=true", [self baseAPI], projectId];
    if (attach) {
        url = [NSString stringWithFormat:@"%@&%@", url, attach];
    }
    
    return [AFNetworkingHelper getResource:url parameters:nil];
}

/**
 *  分页获取新增构件信息
 *
 *  @param projectId 工程id
 *  @param attach    拼接字段
 *
 *  @return promise
 */
- (SHXPromise *)updateEntityInfo:(NSString *)projectId attach:(NSString *)attach
{
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/entities_info?sync=update", [self baseAPI], projectId];
    if (attach) {
        url = [NSString stringWithFormat:@"%@&%@", url, attach];
    }
    
    return [[AFNetworkingHelper getResource:url parameters:nil] onFulfilled:^id(id value) {
        return Underscore.arrayMap(value, ^id(id item) {
            return [EntityInfoModel entityInfoModelWithData:item];
        });
    }];
}

/**
 *  通过构件uuid获得构件信息
 *
 *  @param entityIdArray  构件uuidArray
 *  @param projectId 工程id
 *
 *  @return promise NSArray
 */
- (SHXPromise *)getEntityInfoByEntityId:(NSArray *)entityIdArray projectId:(NSString *)projectId
{
    NSDictionary *dic = @{@"uuid":@{@"$in":entityIdArray}};
    NSString *string = [[Utils jsonString:dic] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"%@projects/%@/entities_info?where=%@", [self baseAPI], projectId, string];
    
    return [[AFNetworkingHelper getResource:urlString parameters:nil] onFulfilled:^id(id value) {
        return Underscore.arrayMap(value, ^id(id item) {
            return [EntityInfoModel entityInfoModelWithData:item];
        });
    } rejected:^id(NSError *reason) {
        return reason;
    }];
}

/**
 *  通过二维码获得构件信息
 *
 *  @param code      二维码
 *  @param projectId 工程id
 *
 *  @return promise NSArray
 */
- (SHXPromise *)getEntityInfoByCode:(NSString *)code projectId:(NSString *)projectId
{
    NSDictionary *dic = @{@"code":@{@"$in":@[code]}};
    NSString *string = [[Utils jsonString:dic] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"%@projects/%@/entities_info?where=%@", [self baseAPI], projectId, string];
    
    return [[AFNetworkingHelper getResource:urlString parameters:nil] onFulfilled:^id(id value) {
        return Underscore.arrayMap(value, ^id(id item) {
            return [EntityInfoModel entityInfoModelWithData:item];
        });
    } rejected:^id(NSError *reason) {
        return reason;
    }];
}


#pragma mark - SelectionSet
/**
 *  获得选择集变更数量
 *
 *  @param projectId 工程id
 *  @param attach    拼接字段
 *
 *  @return promise
 */
- (SHXPromise *)getSelectionSetCount:(NSString *)projectId attach:(NSString *)attach
{
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/selection_sets?sync=true&only_count=true", [self baseAPI], projectId];
    if (attach) {
        url = [NSString stringWithFormat:@"%@&%@", url, attach];
    }
    
    return [AFNetworkingHelper getResource:url parameters:nil];
}

/**
 *  分页获取新增选择集
 *
 *  @param projectId 工程id
 *  @param attach    拼接字段
 *
 *  @return promise
 */
- (SHXPromise *)updateSelectionSet:(NSString *)projectId attach:(NSString *)attach
{
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/selection_sets?sync=update", [self baseAPI], projectId];
    if (attach) {
        url = [NSString stringWithFormat:@"%@&%@", url, attach];
    }
    
    return [[AFNetworkingHelper getResource:url parameters:nil] onFulfilled:^id(id value) {
        return Underscore.arrayMap(value, ^id(id item) {
            return [SelectionSetModel selectionSetModelWithData:item];
        });
    }];
}

/**
 通过选择集id获得选择集
 
 @param modelId   选择集id
 @param projectId 工程id
 
 @return promise NSArray
 */
- (SHXPromise *)getSelectionSetBySelectionSetModelId:(NSString *)modelId projectId:(NSString *)projectId
{
    NSDictionary *dic = @{@"_id":@{@"$in":@[modelId]}};
    NSString *string = [[Utils jsonString:dic] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"%@projects/%@/selection_sets?where=%@", [self baseAPI], projectId, string];
    
    return [[AFNetworkingHelper getResource:urlString parameters:nil] onFulfilled:^id(id value) {
        return Underscore.arrayMap(value, ^id(id item) {
            return [SelectionSetModel selectionSetModelWithData:item];
        });
    } rejected:^id(NSError *reason) {
        return reason;
    }];
}

/**
 *  通过二维码获得选择集
 *
 *  @param code      二维码
 *  @param projectId 工程id
 *
 *  @return promise NSArray
 */
- (SHXPromise *)getSelectionSetByCode:(NSString *)code projectId:(NSString *)projectId
{
    NSDictionary *dic = @{@"qrCode":@{@"$in":@[code]}};
    NSString *string = [[Utils jsonString:dic] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"%@projects/%@/selection_sets?where=%@", [self baseAPI], projectId, string];
    
    return [[AFNetworkingHelper getResource:urlString parameters:nil] onFulfilled:^id(id value) {
        return Underscore.arrayMap(value, ^id(id item) {
            return [SelectionSetModel selectionSetModelWithData:item];
        });
    } rejected:^id(NSError *reason) {
        return reason;
    }];
}

@end
