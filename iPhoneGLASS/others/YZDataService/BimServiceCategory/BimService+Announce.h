//
//  BimService+Announce.h
//  GTiPhone
//  =============================================公告相关API=============================================
//  Created by 尤维维 on 2017/6/27.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService.h"

@interface BimService (Announce)

// 获取所有的公告列表
- (SHXPromise *)getAllAnnounce:(NSString *)projectId;

// 获取公告详情
- (SHXPromise *)getAnnounceInfo:(NSString *)announceId;

// 发布公告
- (SHXPromise *)postAnnounce:(NSDictionary *)dict projectID:(NSString *)projectID;

// 删除公告
- (SHXPromise *)deleteAnnounce:(NSString *)announceId;

@end
