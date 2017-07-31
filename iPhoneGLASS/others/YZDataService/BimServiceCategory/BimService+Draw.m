//
//  BimService+Draw.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService+Draw.h"

@implementation BimService (Draw)

#pragma mark Draw

- (SHXPromise *)getAllBuilds:(NSString *)projectID {
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/buildings",self.baseAPI,projectID];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

- (SHXPromise *)getAllFloors:(NSString *)projectID {
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/floors",self.baseAPI,projectID];
    return [AFNetworkingHelper getResource:url parameters:nil];
}
- (SHXPromise *)getAllRooms:(NSString *)projectID {
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/rooms",self.baseAPI,projectID];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 获取图纸
- (SHXPromise *)getDrawDocumentByDocumentId:(NSString *)documentId {
    NSString *url = [NSString stringWithFormat:@"%@documents/%@", self.baseAPI, documentId];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 获取图纸
- (SHXPromise *)getDrawDocument:(NSDictionary *)dict {
    NSString *url = [NSString stringWithFormat:@"%@documents",self.baseAPI];
    return [AFNetworkingHelper getResource:url parameters:dict];
}

// 创建图钉
- (SHXPromise *)createDrawPin:(NSString *)projectId documentId:(NSString *)documentId point:(CGPoint)point attach:(NSDictionary *)attachDic
{
    NSString *url = [NSString stringWithFormat:@"%@pins", self.baseAPI];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:attachDic];
    [parameters setObject:@(point.x) forKey:@"x"];
    [parameters setObject:@(point.y) forKey:@"y"];
    [parameters setObject:projectId forKey:@"projectId"];
    [parameters setObject:documentId forKey:@"documentId"];
    
    return [AFNetworkingHelper postResource:url parameters:parameters];
}

// 获取所有图钉
- (SHXPromise *)getDrawPins:(NSString *)documentId drawInfoType:(GTDrawInfoExtendType)infoType attach:(NSDictionary *)attach
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:attach];
    if (documentId) {
        [dic setObject:documentId forKey:@"documentId"];
    }
    
    NSString *string = [[Utils jsonString:dic] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@pins?where=%@%@", self.baseAPI, string, [self drawInfoExtend:infoType]];
    
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 获取单个图钉
- (SHXPromise *)getDrawPin:(NSString *)pinId
{
    NSString *url = [NSString stringWithFormat:@"%@pins/%@", self.baseAPI, pinId];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

- (NSString *)drawInfoExtend:(GTDrawInfoExtendType)infoType
{
    switch (infoType) {
        case GTDrawInfoExtendTypeNone:
            return @"";
        case GTDrawInfoExtendTypeInfo:
            return @"&extend=info";
        case GTDrawInfoExtendTypeIssue:
            return @"&extend=issue";
    }
}

// 根据doucment获取file
- (SHXPromise *)getPinFromDocument:(NSString *)documentId {
    NSString *url = [NSString stringWithFormat:@"%@documents/%@", self.baseAPI, documentId];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 获取所有图纸信息
- (SHXPromise *)getAllDrawDocument:(NSString *)projectID
{
    NSString *string = [[Utils jsonString:@{@"fileType": @"drawing"}] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@documents?projectid=%@&where=%@", self.baseAPI, projectID,string];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

@end
