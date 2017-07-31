//
//  LocalBimService+Address.m
//  GTiPhone
//
//  Created by 尤维维 on 2017/6/16.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService+Address.h"

#import "TeamModel.h"
#import "TemplateModel.h"

@implementation LocalBimService (Address)

/**同步通讯录*/
- (SHXPromise *)setAddress:(NSArray *)members projectID:(NSString *)projectID{

    NSMutableArray *userIDArray = [[NSMutableArray alloc] init];
    Underscore.arrayEach(members, ^(NSDictionary *key) {
        [userIDArray addObject:[key objectForKey:@"_id"]];
    });
    // 保存工程下所有人员的ID
    [self setObject:userIDArray projectId:projectID userId:[UserService instance].user.userId fileName:@"addressArray"];
    
    return [self setBaseArray:members tableName:AddressTable];
}

/**获取某一成员*/
- (SHXPromise *)getmembers:(NSString *)projectID memberId:(NSString *)memberId {
    return [[self getLocalBase:AddressTable modelClass:[AddressModel new] unarchiveKeys:@[@"options"] searchDict:@{@"_id" : memberId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

/**获取某一成员下所有的成员*/
- (SHXPromise *)getAllMembers:(NSString *)projectID userId:(NSString *)userId {
    // 1.获取该用户拥有的工程ID数组
    NSArray *array = [self getObjectWithProjectId:projectID userId:userId fileName:@"addressArray"];
    
    NSMutableArray *resMembers = [NSMutableArray array];
    for (NSString *ID in array) {
        id p = [self getmembers:[UserService instance].user.curProject.projectId memberId:ID];
        [resMembers addObject:p];
    }
    return [SHXPromise all:resMembers];
}

/**同步企业*/
- (SHXPromise *)setEnterprises:(NSArray *)enterprises projectID:(NSString *)projectID {
    return [self setBaseArray:enterprises tableName:EnterpriseTable];
}
/**获取所有企业*/
- (SHXPromise *)getAllEnterprise:(NSString *)projectID {
    return [self getLocalBase:EnterpriseTable modelClass:[TeamModel new] searchDict:@{@"projectId" : projectID}];
}


/**获取某一企业*/
- (SHXPromise *)getEnterprise:(NSString *)projectID enterpriseId:(NSString *)enterpriseId {
    return [[self getLocalBase:EnterpriseTable modelClass:[TeamModel new] searchDict:@{@"_id" : enterpriseId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

/**同步部门*/
- (SHXPromise *)setDepartments:(NSArray *)departments projectID:(NSString *)projectID {
    return [self setBaseArray:departments tableName:DepartmentTable];
}

/**获取所有部门*/
- (SHXPromise *)getAllDepartment:(NSString *)projectID {
    return [self getLocalBase:DepartmentTable modelClass:[SectionModel new] searchDict:@{@"projectId" : projectID}];
}

/**获取某一部门*/
- (SHXPromise *)getDepartment:(NSString *)projectID departmentId:(NSString *)departmentId;
{
    return [[self getLocalBase:DepartmentTable modelClass:[SectionModel new] searchDict:@{@"_id" : departmentId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

/**同步职业*/
- (SHXPromise *)setPositions:(NSArray *)positions projectID:(NSString *)projectID {
    return [self setBaseArray:positions tableName:PositionTable];
}

/**获取当前项目所有职业*/
- (SHXPromise *)getAllPosition:(NSString *)projectID {
    return [self getLocalBase:PositionTable modelClass:[PositionModel new] unarchiveKeys:@[@"authTemplates"] searchDict:@{@"projectId" : projectID}];
}
/**获取某一职业*/
- (SHXPromise *)getPosition:(NSString *)projectID positionId:(NSString *)positionId {
    return [[self getLocalBase:PositionTable modelClass:[PositionModel new] unarchiveKeys:@[@"authTemplates"] searchDict:@{@"_id" : positionId?positionId:@""}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];

}
- (SHXPromise *)setTemplate:(NSArray *)templates projectID:(NSString *)projectID
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self getObjectWithProjectId:projectID userId:[UserService instance].user.userId fileName:templateIDArray]];
    if (!array) {
        array = [NSMutableArray array];
    }
    for (NSDictionary *dic in templates) {
        if (![array containsObject:dic[@"_id"]]) {
            [array addObject:dic[@"_id"]];
        }
    }
    [self setObject:array projectId:projectID userId:[UserService instance].user.userId fileName:templateIDArray];
    return [self setBaseArray:templates tableName:TemplateTable];
}

/**获取某一模板*/
- (SHXPromise *)getTemplate:(NSString *)projectID templateId:(NSString *)templateId {
    return [[self getLocalBase:TemplateTable modelClass:[TemplateModel new] searchDict:@{@"_id" : templateId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

/**获取当前项目所有模板*/
- (SHXPromise *)getAllTemplate:(NSString *)projectID {
    return [self getLocalBase:TemplateTable modelClass:[TemplateModel new] searchDict:@{@"projectId" : projectID}];
}

@end
