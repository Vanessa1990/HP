//
//  BimService+Announce.m
//  GTiPhone
//
//  Created by 尤维维 on 2017/6/27.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService+Announce.h"

@implementation BimService (Announce)

// 获取所有的公告列表
- (SHXPromise *)getAllAnnounce:(NSString *)projectId {
    NSString *url = [NSString stringWithFormat:@"%@announcements?projectid=%@",self.baseAPI,projectId];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 获取公告详情
- (SHXPromise *)getAnnounceInfo:(NSString *)announceId {
    NSString *url = [NSString stringWithFormat:@"%@announcements/%@",self.baseAPI,announceId];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 发布公告
- (SHXPromise *)postAnnounce:(NSDictionary *)dict projectID:(NSString *)projectID {
    NSString *url = [NSString stringWithFormat:@"%@announcements", self.baseAPI];
    
    NSMutableArray *pictures = dict[@"pictures"];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithDictionary:dict];
    [paramters removeObjectForKey:@"pictures"];
    
    return [[AFNetworkingHelper postResource:url parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < pictures.count; i++) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:[Utils reviewPath:pictures[i]]] name:[NSString stringWithFormat:@"picture%d",i] error:nil];
        }
    }] onFulfilled:^id(id value) {
        return value;
    }];
    return nil;
}

// 删除公告
- (SHXPromise *)deleteAnnounce:(NSString *)announceId{
    NSString *url = [NSString stringWithFormat:@"%@announcements/%@", self.baseAPI,announceId];
    return [AFNetworkingHelper deleteResource:url parameters:nil];
}

@end
