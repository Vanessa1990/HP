//
//  BimService+Address.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService.h"

@interface BimService (Address)

- (SHXPromise *)getAllEnterprises:(NSString *)projectID;
- (SHXPromise *)getAllDepartments:(NSString *)projectID;
- (SHXPromise *)getAllMembers:(NSString *)projectID;
- (SHXPromise *)getAllPositions:(NSString *)projectID;
- (SHXPromise *)addMember:(NSDictionary *)member projectID:(NSString *)projectID; 

/**获取权限模板*/
- (SHXPromise *)getTemplate:(NSString *)projectID departmentId:(NSString *)templateId;

@end
