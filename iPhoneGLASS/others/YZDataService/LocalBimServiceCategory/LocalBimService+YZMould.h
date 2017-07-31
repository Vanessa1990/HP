//
//  LocalBimService+YZMould.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService.h"

@class EntityModel;
@class EntityInfoModel;
@class SelectionSetModel;

@interface LocalBimService (YZMould)

#pragma mark Entity ExpandProperties API

/**同步构件扩展属性*/
- (SHXPromise *)setLocalEntityExpandProperties:(NSArray *)entityDicArray projectId:(NSString *)projectId;
/**保存构件扩展属性*/
- (SHXPromise *)setLocalExpandProperties:(EntityModel *)entityModel projectId:(NSString *)projectId;
/**获得构件扩展属性*/
- (SHXPromise *)getLocalExpandProperties:(NSString *)entityID projectId:(NSString *)projectId;

#pragma mark EntityInfo

/**
 *  同步构件信息
 *
 *  @param entityInfoModels 构件信息数组
 *  @param projectId        工程id
 *
 *  @return promise : NSArray
 */
- (SHXPromise *)setLocalEntityInfos:(NSArray *)entityInfoModels projectId:(NSString *)projectId;
/**
 *  同步单个构件信息
 *
 *  @param entityInfoModel 构件信息模型
 *  @param projectId       工程id
 *
 *  @return promise : EntityInfoModel
 */
- (SHXPromise *)setLocalEntityInfo:(EntityInfoModel *)entityInfoModel projectId:(NSString *)projectId;
/**
 *  通过构件uuid获取构件信息
 *
 *  @param entityIdArray  构件uuidArray
 *  @param projectId 工程id
 *
 *  @return promise : NSArray
 */
- (SHXPromise *)getLocalEntityInfoByEntityId:(NSArray *)entityIdArray projectId:(NSString *)projectId;
/**
 *  通过二维码获取构件信息
 *
 *  @param code      二维码
 *  @param projectId 工程id
 *
 *  @return promise : NSArray
 */
- (SHXPromise *)getLocalEntityInfoByCode:(NSString *)code projectId:(NSString *)projectId;

#pragma mark SelectionSet

/**
 *  同步选择集
 *
 *  @param SelectionSetModels 选择集数组
 *  @param projectId          工程id
 *
 *  @return promise : NSArray
 */
- (SHXPromise *)setLocalSelectionSets:(NSArray *)SelectionSetModels projectId:(NSString *)projectId;

/**
 *  同步单个选择集
 *
 *  @param selectionSetModel 选择集模型
 *  @param projectId         工程id
 *
 *  @return promise : SelectionSetModel
 */
- (SHXPromise *)setLocalSelectionSet:(SelectionSetModel *)selectionSetModel projectId:(NSString *)projectId;
/**
 通过选择集id获取选择集
 
 @param modelId   选择集id
 @param projectId 工程id
 
 @return promise : NSArray
 */
- (SHXPromise *)getLocalSelectionSetBySelectionSetModelId:(NSString *)modelId projectId:(NSString *)projectId;
/**
 *  通过二维码获取选择集
 *
 *  @param code      二维码
 *  @param projectId 工程id
 *
 *  @return promise : NSArray
 */
- (SHXPromise *)getLocalSelectionSetByCode:(NSString *)code projectId:(NSString *)projectId;

@end
