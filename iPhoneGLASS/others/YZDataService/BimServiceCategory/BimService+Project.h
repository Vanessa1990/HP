//
//  BimService+Project.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService.h"

@interface BimService (Project)

// 获取工程列表
- (SHXPromise *)getProjects;
// 获取工程详情
- (SHXPromise *)getProject:(NSString *)projectId;

@end
