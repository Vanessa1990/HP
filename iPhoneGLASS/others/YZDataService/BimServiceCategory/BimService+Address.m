//
//  BimService+Address.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService+Address.h"

@implementation BimService (Address)

- (SHXPromise *)getAllEnterprises:(NSString *)projectID {
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/enterprises",self.baseAPI,projectID];
    return [AFNetworkingHelper getResource:url parameters:nil];
}
- (SHXPromise *)getAllDepartments:(NSString *)projectID {
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/departments",self.baseAPI,projectID];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

- (SHXPromise *)getAllMembers:(NSString *)projectID {
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/members",self.baseAPI,projectID];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

- (SHXPromise *)getAllPositions:(NSString *)projectID {
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/positions",self.baseAPI,projectID];
    return [AFNetworkingHelper getResource:url parameters:nil];
}


- (SHXPromise *)addMember:(NSDictionary *)member projectID:(NSString *)projectID{
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/members",self.baseAPI,projectID];
    return [AFNetworkingHelper postResource:url parameters:member];
}
/**获取权限模板*/
- (SHXPromise *)getTemplate:(NSString *)projectID departmentId:(NSString *)templateId {
    NSString *url = [NSString stringWithFormat:@"%@auth_templates/%@",self.baseAPI,templateId];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

@end
