//
//  LocalBimService+Problem.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService.h"

@interface LocalBimService (Problem)

/**同步问题类型*/
- (SHXPromise *)setIssueType:(NSArray *)issues;
/**获取所有问题类型*/
- (SHXPromise *)getAllIssueType:(NSString *)projectId;
/**获取单个问题类型*/
- (SHXPromise *)getIssueType:(NSString *)issueId;

/**同步问题*/
- (SHXPromise *)setAllProblem:(NSArray *)problems;
/**获取all问题*/
- (SHXPromise *)getAllProblem:(NSString *)projectId;
/**获取相关问题*/
- (SHXPromise *)getProblemWithSearchDict:(NSDictionary *)searchDict;
/**获取某个问题*/
- (SHXPromise *)getProblem:(NSString *)problemId;
/**获取某个图钉问题*/
- (SHXPromise *)getProblemForPin:(NSString *)pinId;
/**保存离线问题*/
- (SHXPromise *)saveOfflineProblem:(NSDictionary *)problemDict;
/**获取离线问题*/
- (SHXPromise *)getOfflineProblem:(NSString *)projectId createBy:(NSString *)createBy;
/**删除离线问题*/
- (BOOL)deleteOfflineProblem:(NSDictionary *)problemDict;



@end
