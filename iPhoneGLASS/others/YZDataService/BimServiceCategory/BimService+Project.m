//
//  BimService+Project.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService+Project.h"

#import "ProjectModel.h"

@implementation BimService (Project)

#pragma mark - Project
// 获取工程列表
- (SHXPromise *)getProjects
{
    NSString *urlString = [NSString stringWithFormat:@"%@projects", self.baseAPI];
    return [AFNetworkingHelper getResource:urlString parameters:nil];
}

// 获取工程详情
- (SHXPromise *)getProject:(NSString *)projectId
{
    NSString *url = [NSString stringWithFormat:@"%@projects/%@", self.baseAPI,projectId];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

@end
