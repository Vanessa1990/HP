//
//  BimService+Problem.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService.h"

@interface BimService (Problem)

// 新建问题
- (SHXPromise *)postProblem:(NSDictionary *)dict projectID:(NSString *)projectID;
// 获取问题列表
- (SHXPromise *)getAllProblem:(NSString *)projectID;
/**获取相关类型问题*/
- (SHXPromise *)getProblem:(NSString *)projectId issueType:(NSString *)issueID;
/**获取相关需求问题*/
- (SHXPromise *)getProblem:(NSString *)projectId dict:(NSDictionary *)dict;
// 获取图钉问题列表
- (SHXPromise *)getDrawPinProblems:(NSString *)pinId;
// 获取图纸问题列表
- (SHXPromise *)getDrawProblems:(NSDictionary *)attach;
// 获取单个问题
- (SHXPromise *)getProblem:(NSString *)questionId;
// 获取所有的类型
- (SHXPromise *)getIssuesType:(NSDictionary *)dict;
// 发送反馈意见
- (SHXPromise *)sendHandled:(NSString *)issueId handleId:(NSString *)handleId dict:(NSDictionary *)dict;
// 发送审阅意见
- (SHXPromise *)sendExamine:(NSString *)issueId examineId:(NSString *)examineId dict:(NSDictionary *)dict;
// 通知相关人查看
- (SHXPromise *)informRelatedPeopleSee:(NSString *)problemId people:(NSArray *)people;

@end
