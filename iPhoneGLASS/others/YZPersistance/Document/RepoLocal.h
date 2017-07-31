//
//  RepoLocal.h
//  BIM
//
//  Created by Dev on 15/5/5.
//  Copyright (c) 2015年 Pu Mai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseManager.h"

// 表名常量

#pragma mark - Account
// 账户表
static NSString *const AccountTable = @"AccountTable";

#pragma mark - Project
// 工程表
static NSString *const ProjectTable = @"ProjectTable";
// 模型表
static NSString *const ModelTable = @"ModelTable";

#pragma mark - Mould
// 构件表[未创建]
static NSString *const EntityTable = @"EntityTable";
// 构件信息表[未创建]
static NSString *const EntityInfoTable = @"EntityInfoTable";
// 选择集表[未创建]
static NSString *const SelectionSetTable = @"SelectionSetTable";

#pragma mark - QRCode
// 二维码表[未创建]
static NSString *const QRTable = @"QRTable";

#pragma mark - Address
// 通讯录人员表
static NSString *const AddressTable = @"AddressTable";
// 企业表
static NSString *const EnterpriseTable = @"EnterpriseTable";
// 部门表
static NSString *const DepartmentTable = @"DepartmentTable";
// 职位表
static NSString *const PositionTable = @"PositionTable";

#pragma mark - Problem
// 问题类型表
static NSString *const IssueTable = @"issueTable";
// 问题表
static NSString *const ProblemTable = @"ProblemTable";
// 公告表
static NSString *const AnnounceTable = @"announceTable";
// 模板表
static NSString *const TemplateTable = @"TemplateTable";
// 离线问题表
static NSString *const OfflineProblemTable = @"OfflineProblemTable";

#pragma mark - Draw
// 楼号表
static NSString *const BuildTable = @"BuildTable";
// 楼层表
static NSString *const FloorTable = @"FloorTable";
// 房间表
static NSString *const RoomTable = @"RoomTable";
// 图纸资料信息表
static NSString *const DrawDocumentTable = @"DrawDocumentTable";
// 图钉信息表
static NSString *const DrawPinTable = @"DrawPinTable";

#pragma mark - Document
// 资料列表表
static NSString *const DocumentTable = @"DocumentTable";



@interface RepoLocal : NSObject

#pragma mark - file r/w data

/**
 *  存缓存文件
 *
 *  @param insertObject 文件
 *  @param projectId    工程id
 *  @param userId       用户id
 *  @param fileName     文件名称
 */
- (void)setObject:(id)insertObject projectId:(NSString *)projectId userId:(NSString *)userId fileName:(NSString *)fileName;

/**
 *  取缓存文件
 *
 *  @param projectId 工程id
 *  @param userId    用户id
 *  @param fileName  文件名称
 *
 *  @return 文件
 */
- (id)getObjectWithProjectId:(NSString *)projectId userId:(NSString *)userId fileName:(NSString *)fileName;

@end
