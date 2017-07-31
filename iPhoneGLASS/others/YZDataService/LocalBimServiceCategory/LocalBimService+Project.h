//
//  LocalBimService+Project.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService.h"

@class ProjectModel;

@interface LocalBimService (Project)

/**获得本地工程列表*/
- (SHXPromise *)getLocalProjects:(NSString *)userID;
/**同步本地工程列表*/
- (SHXPromise *)setLocalProjects:(NSArray *)projectArray userID:(NSString *)userID;
/**更新本地工程*/
- (SHXPromise *)updateLocalProject:(ProjectModel *)projectModel;

/**删除工程下所有信息*/
- (void)delLocalProject:(NSString *)projectID;

@end
