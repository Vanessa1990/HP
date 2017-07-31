//
//  BimService+YZMould.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService.h"

@interface BimService (YZMould)

#pragma mark - Entity(EntityProperties构件属性; EntityInfo构件信息)
// 模糊搜索Entity
- (SHXPromise *)getEntityBySearch:(NSString *)searchString project:(NSString *)projectId attach:(NSString *)attach;

// 获得构件属性(包括扩展属性和基本属性)
- (SHXPromise *)getEntityProperty:(NSString *)entityId project:(NSString *)projectId;

// 获得构件(有扩展属性)个数
- (SHXPromise *)getEntityCount:(NSString *)projectId attach:(NSString *)attach;
// 分页同步构件扩展属性
- (SHXPromise *)updateEntity:(NSString *)projectId attach:(NSString *)attach;
// 获得单个构件扩展属性
- (SHXPromise *)getEntityExpandProperty:(NSString *)entityId projectId:(NSString *)projectId;
// 获得所有构件扩展属性
- (SHXPromise *)getAllEntityExpandProperty:(NSString *)projectId __attribute__((deprecated("iOSCommon 1.3.1 版本已过期(数据量大时间久)")));

/**
 *  获得构件信息变更数量
 *
 *  @param projectId 工程id
 *  @param attach    拼接字段
 *
 *  @return promise
 */
- (SHXPromise *)getEntityInfoCount:(NSString *)projectId attach:(NSString *)attach;
/**
 *  分页获取新增构件信息
 *
 *  @param projectId 工程id
 *  @param attach    拼接字段
 *
 *  @return promise
 */
- (SHXPromise *)updateEntityInfo:(NSString *)projectId attach:(NSString *)attach;
/**
 *  通过构件uuid获得构件信息
 *
 *  @param entityIdArray  构件uuidArray
 *  @param projectId 工程id
 *
 *  @return promise NSArray
 */
- (SHXPromise *)getEntityInfoByEntityId:(NSArray *)entityIdArray projectId:(NSString *)projectId;
/**
 *  通过二维码获得构件信息
 *
 *  @param code      二维码
 *  @param projectId 工程id
 *
 *  @return promise NSArray
 */
- (SHXPromise *)getEntityInfoByCode:(NSString *)code projectId:(NSString *)projectId;


#pragma mark - SelectionSet
/**
 *  获得选择集变更数量
 *
 *  @param projectId 工程id
 *  @param attach    拼接字段
 *
 *  @return promise
 */
- (SHXPromise *)getSelectionSetCount:(NSString *)projectId attach:(NSString *)attach;
/**
 *  分页获取新增选择集
 *
 *  @param projectId 工程id
 *  @param attach    拼接字段
 *
 *  @return promise
 */
- (SHXPromise *)updateSelectionSet:(NSString *)projectId attach:(NSString *)attach;
/**
 通过选择集id获得选择集
 
 @param modelId   选择集id
 @param projectId 工程id
 
 @return promise NSArray
 */
- (SHXPromise *)getSelectionSetBySelectionSetModelId:(NSString *)modelId projectId:(NSString *)projectId;
/**
 *  通过二维码获得选择集
 *
 *  @param code      二维码
 *  @param projectId 工程id
 *
 *  @return promise NSArray
 */
- (SHXPromise *)getSelectionSetByCode:(NSString *)code projectId:(NSString *)projectId;

@end
