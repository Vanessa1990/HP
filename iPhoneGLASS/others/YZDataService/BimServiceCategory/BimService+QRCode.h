//
//  BimService+QRCode.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService.h"

@interface BimService (QRCode)

#pragma mark - 二维码管理
// 获得二维码-资源数据
- (SHXPromise *)getQR:(NSString *)projectID;

// 获得二维码个数
- (SHXPromise *)getQRCount:(NSString *)projectId attach:(NSString *)attach;
// 分页同步二维码
- (SHXPromise *)updateQR:(NSString *)projectId attach:(NSString *)attach;

/**
 *  精简二维码 个数
 *
 *  @param projectId 工程id
 *  @param attach    拼接属性
 *
 *  @return e.g: @{@"updated":44, @"deleted":14}
 */
- (SHXPromise *)getQR_simpleCount:(NSString *)projectId attach:(NSString *)attach;

/**
 *  分页获取新增精简二维码
 *
 *  @param projectId 工程id
 *  @param attach    拼接属性
 *
 *  @return 精简二维码模型
 */
- (SHXPromise *)updateQRs_simple:(NSString *)projectId attach:(NSString *)attach;

/**
 *  分页获取删除的二维码id
 *
 *  @param projectId 工程id
 *  @param attach    拼接属性
 *
 *  @return 被删除二维码id
 */
- (SHXPromise *)deleteQRs:(NSString *)projectId attach:(NSString *)attach;

/**
 *  根据code获取网络QRModel
 *
 *  @param projectId 工程id
 *  @param code      二维码信息
 *
 *  @return promise:QRModel
 */
- (SHXPromise *)getQRModel:(NSString *)projectId code:(NSString *)code;

/**
 *  根据rid获取网络QRModel
 *
 *  @param projectId 工程id
 *  @param rid       rid
 *
 *  @return promise:QRModel
 */
- (SHXPromise *)getQRModel:(NSString *)projectId rid:(NSString *)rid;

@end
