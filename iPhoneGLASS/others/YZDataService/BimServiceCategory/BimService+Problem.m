//
//  BimService+Problem.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService+Problem.h"

@implementation BimService (Problem)

- (SHXPromise *)postProblem:(NSDictionary *)dict projectID:(NSString *)projectID {
    
    NSString *url = [NSString stringWithFormat:@"%@issues", self.baseAPI];
    
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

// 获取问题列表
- (SHXPromise *)getAllProblem:(NSString *)projectID
{
    NSString *string = [[Utils jsonString:@{@"projectId": projectID}] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@issues?where=%@", self.baseAPI, string];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

/**获取相关类型问题*/
- (SHXPromise *)getProblem:(NSString *)projectId issueType:(NSString *)issueID
{
    NSString *string = [[Utils jsonString:@{@"projectId": projectId,@"type":issueID}] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@issues?where=%@", self.baseAPI, string];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

/**获取相关需求问题*/
- (SHXPromise *)getProblem:(NSString *)projectId dict:(NSDictionary *)dict
{
    NSString *string = [[Utils jsonString:dict] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@issues?where=%@", self.baseAPI, string];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 获取图钉问题列表
- (SHXPromise *)getDrawPinProblems:(NSString *)pinId
{
    NSString *string = [[Utils jsonString:@{@"drawingPin": pinId}] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url = [NSString stringWithFormat:@"%@issues?where=%@", self.baseAPI, string];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 获取图纸问题列表
- (SHXPromise *)getDrawProblems:(NSDictionary *)attach
{
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in attach) {
        if (string.length == 0) {
            [string appendString:[NSString stringWithFormat:@"?%@=%@", key, attach[key]]];
        } else {
            [string appendString:[NSString stringWithFormat:@"&%@=%@", key, attach[key]]];
        }
    }
    NSString *url = [NSString stringWithFormat:@"%@issues%@",self.baseAPI, string];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 获取单个问题
- (SHXPromise *)getProblem:(NSString *)questionId {
    NSString *url = [NSString stringWithFormat:@"%@issues/%@",self.baseAPI,questionId];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 获取所有的类型
- (SHXPromise *)getIssuesType:(NSDictionary *)dict {
    NSString *url = [NSString stringWithFormat:@"%@issue_types?projectid=%@",self.baseAPI,YZ_CURRENT_PROJECTID];
    return [AFNetworkingHelper getResource:url parameters:dict];
}

// 发送反馈意见
- (SHXPromise *)sendHandled:(NSString *)issueId handleId:(NSString *)handleId dict:(NSDictionary *)dict
{
    NSString *url = [NSString stringWithFormat:@"%@issues/%@/handlers/%@", self.baseAPI, issueId, handleId];
    
    NSMutableArray *pictures = dict[@"pictures"];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithDictionary:dict];
    [paramters removeObjectForKey:@"pictures"];
    
    return [AFNetworkingHelper postResource:url parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < pictures.count; i++) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:[Utils reviewPath:pictures[i]]] name:[NSString stringWithFormat:@"picture%d",i] error:nil];
        }
    }];
}

- (SHXPromise *)sendExamine:(NSString *)issueId examineId:(NSString *)examineId dict:(NSDictionary *)dict {
    NSString *url = [NSString stringWithFormat:@"%@issues/%@/examines/%@", self.baseAPI, issueId, examineId];
    return [AFNetworkingHelper postResource:url parameters:dict];
}

// 通知相关人查看  /issues/:id/at
- (SHXPromise *)informRelatedPeopleSee:(NSString *)problemId people:(NSArray *)people
{
    NSString *url = [NSString stringWithFormat:@"%@issues/%@/at", self.baseAPI, problemId];
    NSDictionary *dict = @{};
    return [AFNetworkingHelper updateResource:url parameters:people];
}

@end
