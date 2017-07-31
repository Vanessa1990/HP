//
//  LocalBimService+Address.h
//  GTiPhone
//
//  Created by 尤维维 on 2017/6/16.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService.h"

@class TeamModel, SectionModel, PositionModel, AddressModel;

@interface LocalBimService (Address)

/**同步通讯录人员*/
- (SHXPromise *)setAddress:(NSArray *)members projectID:(NSString *)projectID;
/**获取某一成员*/
- (SHXPromise *)getmembers:(NSString *)projectID memberId:(NSString *)memberId;
/**获取某一成员下所有的成员*/
- (SHXPromise *)getAllMembers:(NSString *)projectID userId:(NSString *)userId;
/**同步企业*/
- (SHXPromise *)setEnterprises:(NSArray *)enterprises projectID:(NSString *)projectID;
/**获取某一企业*/
- (SHXPromise *)getEnterprise:(NSString *)projectID enterpriseId:(NSString *)enterpriseId;
/**获取所有企业*/
- (SHXPromise *)getAllEnterprise:(NSString *)projectID;
/**同步部门*/
- (SHXPromise *)setDepartments:(NSArray *)departments projectID:(NSString *)projectID;
/**获取某一部门*/
- (SHXPromise *)getDepartment:(NSString *)projectID departmentId:(NSString *)departmentId;
/**获取所有部门*/
- (SHXPromise *)getAllDepartment:(NSString *)projectID;
/**同步职业*/
- (SHXPromise *)setPositions:(NSArray *)positions projectID:(NSString *)projectID;
/**获取某一职业*/
- (SHXPromise *)getPosition:(NSString *)projectID positionId:(NSString *)positionId;
/**获取当前项目所有职业*/
- (SHXPromise *)getAllPosition:(NSString *)projectID;
/**同步模板*/
- (SHXPromise *)setTemplate:(NSArray *)templates projectID:(NSString *)projectID;
/**获取某一模板*/
- (SHXPromise *)getTemplate:(NSString *)projectID templateId:(NSString *)templateId;
/**获取当前项目所有模板*/
- (SHXPromise *)getAllTemplate:(NSString *)projectID;

@end
