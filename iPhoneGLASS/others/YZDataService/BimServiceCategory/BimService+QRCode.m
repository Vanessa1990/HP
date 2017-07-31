//
//  BimService+QRCode.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService+QRCode.h"

#import "QRModel.h"

@implementation BimService (QRCode)

#pragma mark - 二维码管理
// 获得二维码-资源数据
- (SHXPromise *)getQR:(NSString *)projectID
{
    //GET api/qrs
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/qrs", [self baseAPI], projectID];
    
    return [[AFNetworkingHelper getResource:url parameters:nil] onFulfilled:^id(id value) {
        return Underscore.arrayMap(value, ^id(id item) {
            return [QRModel modelWithData:item];
        });
    } rejected:^id(NSError *reason) {
        return reason;
    }];
}

// 获得二维码个数
- (SHXPromise *)getQRCount:(NSString *)projectId attach:(NSString *)attach
{
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/qrs?only_count=true", [self baseAPI], projectId];
    if (attach) {
        url = [NSString stringWithFormat:@"%@&%@", url, attach];
    }
    
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 分页同步二维码
- (SHXPromise *)updateQR:(NSString *)projectId attach:(NSString *)attach
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@projects/%@/qrs", [self baseAPI], projectId];
    if (attach) {
        requestUrl = [NSString stringWithFormat:@"%@?%@", requestUrl, attach];
    }
    
    return [[AFNetworkingHelper getResource:requestUrl parameters:nil] onFulfilled:^id(id value) {
        return Underscore.arrayMap(value, ^id(id item) {
            return [QRModel modelWithData:item];
        });
    }];
}

/**
 *  精简二维码 个数
 *
 *  @param projectId 工程id
 *  @param attach    拼接属性
 *
 *  @return e.g: @{@"updated":44, @"deleted":14}
 */
- (SHXPromise *)getQR_simpleCount:(NSString *)projectId attach:(NSString *)attach
{
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/qrs?only_count=true&sync=update", [self baseAPI], projectId];
    if (attach) {
        url = [NSString stringWithFormat:@"%@&%@", url, attach];
    }
    
    return [AFNetworkingHelper getResource:url parameters:nil];
}

/**
 *  分页获取新增精简二维码
 *
 *  @param projectId 工程id
 *  @param attach    拼接属性
 *
 *  @return 精简二维码模型
 */
- (SHXPromise *)updateQRs_simple:(NSString *)projectId attach:(NSString *)attach
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@projects/%@/qrs?sync=update&device=ios", [self baseAPI], projectId];
    if (attach) {
        requestUrl = [NSString stringWithFormat:@"%@&%@", requestUrl, attach];
    }
    
    return [[AFNetworkingHelper getResource:requestUrl parameters:nil] onFulfilled:^id(id value) {
        return Underscore.arrayMap(value, ^id(id item) {
            return [QRModel qrWithData_simple:item projectId:projectId];
        });
    } rejected:^id(NSError *reason) {
        return reason;
    }];
}

/**
 *  分页获取删除的二维码id
 *
 *  @param projectId 工程id
 *  @param attach    拼接属性
 *
 *  @return 被删除二维码id
 */
- (SHXPromise *)deleteQRs:(NSString *)projectId attach:(NSString *)attach
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@projects/%@/qrs?sync=delete", [self baseAPI], projectId];
    if (attach) {
        requestUrl = [NSString stringWithFormat:@"%@&%@", requestUrl, attach];
    }
    
    return [AFNetworkingHelper getResource:requestUrl parameters:nil];
}

/**
 *  根据code获取网络QRModel
 *
 *  @param projectId 工程id
 *  @param code      二维码信息
 *
 *  @return promise:QRModel
 */
- (SHXPromise *)getQRModel:(NSString *)projectId code:(NSString *)code
{
    if (!code) {
        SHXPromise *promise = [[SHXPromise alloc] init];
        [promise reject:[NSError errorWithDomain:@"无code" code:400 userInfo:nil]];
        return promise;
    }
    
    NSDictionary *dic = @{@"code":@{@"$in":@[code]}};
    NSString *string = [[Utils jsonString:dic] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/qrs?where=%@", [self baseAPI], projectId, string];
    
    return [[AFNetworkingHelper getResource:url parameters:nil] onFulfilled:^id(id value) {
        return [QRModel modelWithData:[value lastObject]];
    }];
}

/**
 *  根据rid获取网络QRModel
 *
 *  @param projectId 工程id
 *  @param rid       rid
 *
 *  @return promise:QRModel
 */
- (SHXPromise *)getQRModel:(NSString *)projectId rid:(NSString *)rid
{
    if (!rid) {
        SHXPromise *promise = [[SHXPromise alloc] init];
        [promise reject:[NSError errorWithDomain:@"无rid" code:400 userInfo:nil]];
        return promise;
    }
    
    NSDictionary *dic = @{@"rId":@{@"$in":@[rid]}};
    NSString *string = [[Utils jsonString:dic] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/qrs?where=%@", [self baseAPI], projectId, string];
    
    return [[AFNetworkingHelper getResource:url parameters:nil] onFulfilled:^id(id value) {
        return [QRModel modelWithData:[value lastObject]];
    }];
}

@end
