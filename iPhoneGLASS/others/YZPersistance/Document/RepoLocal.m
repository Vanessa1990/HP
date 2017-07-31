//
//  RepoLocal.m
//  BIM
//
//  Created by Dev on 15/5/5.
//  Copyright (c) 2015年 Pu Mai. All rights reserved.
//

#import "RepoLocal.h"

#define DataBaseVersionPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/databaseVersion.plist"]

@interface RepoLocal ()

@property (nonatomic, strong) DatabaseManager *databaseManager;

@end

@implementation RepoLocal

- (id)init
{
    if (self = [super init]) {
        self.databaseManager = [DatabaseManager instance];
        [self.databaseManager openDatabase];
        
        [self createTable];
    }
    return self;
}

#pragma mark - file r/w data

/**
 *  存缓存文件
 *
 *  @param insertObject 文件
 *  @param projectId    工程id
 *  @param userId       用户id
 *  @param fileName     文件名称
 */
- (void)setObject:(id)insertObject projectId:(NSString *)projectId userId:(NSString *)userId fileName:(NSString *)fileName
{
    [self setOfflineCache:insertObject forName:[NSString stringWithFormat:@"%@_%@_%@", projectId, userId, fileName]];
}

/**
 *  取缓存文件
 *
 *  @param projectId 工程id
 *  @param userId    用户id
 *  @param fileName  文件名称
 *
 *  @return 文件
 */
- (id)getObjectWithProjectId:(NSString *)projectId userId:(NSString *)userId fileName:(NSString *)fileName
{
    return [self getOfflineCacheWithName:[NSString stringWithFormat:@"%@_%@_%@", projectId, userId, fileName]];
}

#pragma mark - archive

/**
 *  缓存文件
 *
 *  @param offlineCacheArray 基本数据类型文件
 *  @param CacheName         名称
 */
- (void)setOfflineCache:(id)offlineCacheArray forName:(NSString *)CacheName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    cachesDirectory = [cachesDirectory stringByAppendingPathComponent:CacheName];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:offlineCacheArray];
    [data writeToFile:cachesDirectory atomically:YES];
}

/**
 *  获取缓存文件
 *
 *  @param CacheName 名称
 *
 *  @return 基本数据类型文件
 */
- (id)getOfflineCacheWithName:(NSString *)CacheName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    cachesDirectory = [cachesDirectory stringByAppendingPathComponent:CacheName];
    NSData *data = [NSData dataWithContentsOfFile:cachesDirectory];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return @[];
    }
}

#pragma mark - Database Manager

// 创建数据库表
- (void)createTable
{
    // 删除版本不对的表
    [self deleteTable];
    
    // 新建表(已建表不会重复创建)
    [self createAccountTable];
    [self createProjectTable];
    [self createAddressTable];
    [self createQuestionTable];
    [self creatAnnounceTable];
    [self creatDrawTable];
    [self creatDocument];
}

// 删除数据库表
- (void)deleteTable
{
    // 判断版本
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:DataBaseVersionPath];
    if (!dic) {
        dic = [[NSMutableDictionary alloc] init];
    }
    
    /**
     *  3.1.3版本开始使用该种升级策略, 默认起始版本号为300, 任何表有字段变更, 版本号手动进行加一操作, 从而达成升级目的。
     */
    [self versionControlTable:AddressTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:PositionTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:DepartmentTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:EnterpriseTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:AccountTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:IssueTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:ProjectTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:AnnounceTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:ProblemTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:TemplateTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:ModelTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:BuildTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:FloorTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:RoomTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:DrawDocumentTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:DrawPinTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:OfflineProblemTable dbVersionDic:dic programVersion:@"300"];
    [self versionControlTable:DocumentTable dbVersionDic:dic programVersion:@"300"];

    
    // 新的版本信息保存到本地
    [dic writeToFile:DataBaseVersionPath atomically:YES];
}

- (NSDictionary *)versionControlTable:(NSString *)tableName dbVersionDic:(NSDictionary *)dbVersionDic programVersion:(NSString *)programVersion
{
    NSString *tableKey = [NSString stringWithFormat:@"db_version_%@", tableName];
    
    // 判断版本号是否一致, 一致则直接返回
    if ([[NSString stringWithFormat:@"%@", [dbVersionDic objectForKey:tableKey]] isEqualToString:[NSString stringWithFormat:@"%@", programVersion]]) {
        return dbVersionDic;
    }
    
    // 版本号不一致, 删除表, 并设置新的版本号
    [self.databaseManager deleteTable:tableName];
    NSLog(@"deleteTableName: %@", tableName);
    [dbVersionDic setValue:programVersion forKey:tableKey];
    return dbVersionDic;
}

#pragma mark - Database Table

- (void)createAddressTable
{
    // 通讯录相关
    [self.databaseManager createTableWithName:AddressTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"name"              :@"varchar(255)",
                                                @"avatar"            :@"varchar(255)",
                                                @"phoneNumber"       :@"varchar(255)",
                                                @"premium"           :@"varchar(255)",
                                                @"capacity"          :@"varchar(255)",
                                                @"createDate"        :@"varchar(255)",
                                                @"updateDate"        :@"varchar(255)",
                                                @"positionId"        :@"varchar(255)",
                                                @"nickname"          :@"varchar(255)",
                                                @"email"             :@"varchar(255)",
                                                @"options"           :@"blob"
                                                }];
    
    [self.databaseManager createTableWithName:PositionTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"projectId"               :@"varchar(255)",
                                                @"departmentId"            :@"varchar(255)",
                                                @"name"                    :@"varchar(255)",
                                                @"authTemplates"           :@"blob",
                                                @"createdAt"               :@"varchar(255)",
                                                @"updatedAt"               :@"varchar(255)",
                                                @"updatedBy"               :@"varchar(255)"
                                                }];
    
    [self.databaseManager createTableWithName:DepartmentTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"projectId"               :@"varchar(255)",
                                                @"enterpriseId"            :@"varchar(255)",
                                                @"name"                    :@"varchar(255)",
                                                @"createdAt"               :@"varchar(255)"
                                                }];
    
    [self.databaseManager createTableWithName:EnterpriseTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"projectId"               :@"varchar(255)",
                                                @"name"                    :@"varchar(255)",
                                                @"createdAt"               :@"varchar(255)",
                                                @"updatedAt"               :@"varchar(255)",
                                                @"updatedBy"               :@"varchar(255)"
                                                }];
    
    [self.databaseManager createTableWithName:TemplateTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"projectId"               :@"varchar(255)",
                                                @"name"                    :@"varchar(255)",
                                                @"createdAt"               :@"varchar(255)"
                                                }];
}

// 创建问题相关表
- (void)createQuestionTable
{
    [self.databaseManager createTableWithName:IssueTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"name"            :@"varchar(255)",
                                                @"createdAt"       :@"varchar(255)",
                                                @"createdBy"       :@"varchar(255)",
                                                @"projectId"       :@"varchar(255)",
                                                @"updatedAt"       :@"varchar(255)",
                                                @"parentId"        :@"varchar(255)",
                                                @"updatedBy"       :@"varchar(255)"
                                                }];
    
    [self.databaseManager createTableWithName:ProblemTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"complete"        :@"TINYINT(255)",
                                                @"content"         :@"varchar(255)",
                                                @"createdAt"       :@"varchar(255)",
                                                @"createdBy"       :@"varchar(255)",
                                                @"handled_complete":@"TINYINT(255)",
                                                @"projectId"       :@"varchar(255)",
                                                @"timestamp"       :@"varchar(255)",
                                                @"type"            :@"varchar(255)",
                                                @"updatedAt"       :@"varchar(255)",
                                                @"drawingPin"      :@"varchar(255)",
                                                @"examined"        :@"blob",
                                                @"handled"         :@"blob",
                                                @"pictures"        :@"blob",
                                                @"documentIds"     :@"blob"
                                                }];
    
    [self.databaseManager createTableWithName:OfflineProblemTable
                                   primaryKey:@"content"
                                         type:@"varchar(255)"
                                  otherColumn:@{
                                                @"type"            :@"varchar(255)",
                                                @"createdAt"       :@"varchar(255)",
                                                @"createdBy"       :@"varchar(255)",
                                                @"projectId"       :@"varchar(255)",
                                                @"location"        :@"blob",
                                                @"handled"         :@"blob",
                                                @"pictures"        :@"blob"
                                                }];
}

// 创建项目表格
- (void)createProjectTable
{
    [self.databaseManager createTableWithName:ProjectTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"name"            :@"varchar(255)",
                                                @"createdAt"       :@"varchar(255)",
                                                @"createdBy"       :@"varchar(255)",
                                                @"updatedAt"       :@"varchar(255)",
                                                @"aerialView"      :@"varchar(255)"
                                                }];
    
    [self.databaseManager createTableWithName:ModelTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"name"             :@"varchar(255)",
                                                @"createdAt"        :@"varchar(255)",
                                                @"createdBy"        :@"varchar(255)",
                                                @"updatedAt"        :@"varchar(255)",
                                                @"updatedBy"        :@"varchar(255)",
                                                @"modelFile"        :@"varchar(255)",
                                                @"projectId"        :@"varchar(255)",
                                                @"tag"              :@"varchar(255)",
                                                @"infoModelFile"    :@"blob",
                                                }];
}

- (void)createAccountTable
{
    [self.databaseManager createTableWithName:AccountTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"name"       :@"varchar(255)",
                                                @"accountName":@"varchar(255)",
                                                @"password"   :@"varchar(255)",
                                                @"logged"     :@"varchar(255)",
                                                @"avatarId"   :@"varchar(255)",
                                                @"accountInfo":@"blob",
                                                @"url"        :@"varchar(255)"
                                                }];
}

- (void)creatAnnounceTable
{
    [self.databaseManager createTableWithName:AnnounceTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"content"       :@"varchar(255)",
                                                @"createdAt"     :@"varchar(255)",
                                                @"createdBy"     :@"varchar(255)",
                                                @"projectId"     :@"varchar(255)",
                                                @"title"         :@"varchar(255)",
                                                @"pictures"      :@"blob",
                                                @"timestamp"     :@"varchar(255)"
                                                }];

}

- (void)creatDrawTable
{
    [self.databaseManager createTableWithName:BuildTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"name"          :@"varchar(255)",
                                                @"projectId"     :@"varchar(255)",
                                                @"createdAt"     :@"varchar(255)",
                                                @"createdBy"     :@"varchar(255)",
                                                @"updatedAt"     :@"varchar(255)",
                                                @"updatedBy"     :@"varchar(255)",
                                                @"files"         :@"blob",
                                                @"documentId"    :@"varchar(255)",
                                                @"documentIds"   :@"blob"
                                                }];
    
    [self.databaseManager createTableWithName:FloorTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"name"          :@"varchar(255)",
                                                @"building"      :@"varchar(255)",
                                                @"projectId"     :@"varchar(255)",
                                                @"createdAt"     :@"varchar(255)",
                                                @"createdBy"     :@"varchar(255)",
                                                @"updatedAt"     :@"varchar(255)",
                                                @"updatedBy"     :@"varchar(255)",
                                                @"files"         :@"blob",
                                                @"documentId"    :@"varchar(255)",
                                                @"documentIds"   :@"blob"
                                                }];
    
    [self.databaseManager createTableWithName:RoomTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"name"          :@"varchar(255)",
                                                @"floor"         :@"varchar(255)",
                                                @"projectId"     :@"varchar(255)",
                                                @"createdAt"     :@"varchar(255)",
                                                @"createdBy"     :@"varchar(255)",
                                                @"updatedAt"     :@"varchar(255)",
                                                @"updatedBy"     :@"varchar(255)",
                                                @"files"         :@"blob",
                                                @"documentId"    :@"varchar(255)",
                                                @"documentIds"   :@"blob"
                                                }];
    
    [self.databaseManager createTableWithName:DrawDocumentTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"name"          :@"varchar(255)",
                                                @"projectId"     :@"varchar(255)",
                                                @"createdAt"     :@"varchar(255)",
                                                @"createdBy"     :@"varchar(255)",
                                                @"updatedAt"     :@"varchar(255)",
                                                @"fileId"        :@"varchar(255)",
                                                @"png"           :@"varchar(255)",
                                                @"type"          :@"varchar(255)",
                                                @"fileType"      :@"varchar(255)",
                                                @"fileLength"    :@"TINYINT(255)",
                                                @"parent"        :@"varchar(255)"
                                                }];
    
    [self.databaseManager createTableWithName:DrawPinTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"buildingId"     :@"varchar(255)",
                                                @"createdAt"      :@"varchar(255)",
                                                @"createdBy"      :@"varchar(255)",
                                                @"documentId"     :@"varchar(255)",
                                                @"floorId"        :@"varchar(255)",
                                                @"projectId"      :@"varchar(255)",
                                                @"roomId"         :@"varchar(255)",
                                                @"updatedAt"      :@"varchar(255)",
                                                @"x"              :@"varchar(255)",
                                                @"y"              :@"varchar(255)",
                                                @"building"       :@"blob",
                                                @"floor"          :@"blob",
                                                @"room"           :@"blob",
                                                @"issueCount"     :@"varchar(255)"
                                                }];
    
}

- (void)creatDocument {
    [self.databaseManager createTableWithName:DocumentTable
                                   primaryKey:@"_id"
                                         type:@"varchar(255)"
                                  otherColumn:@{@"name"       :@"varchar(255)",
                                                @"type"       :@"varchar(255)",
                                                @"parent"     :@"varchar(255)",
                                                @"projectId"  :@"varchar(255)",
                                                @"createdAt"  :@"varchar(255)",
                                                @"createdBy"  :@"varchar(255)",
                                                @"updatedAt"  :@"varchar(255)",
                                                @"fileId"     :@"varchar(255)",
                                                @"png"        :@"varchar(255)",
                                                @"fileLength" :@"TINYINT(255)",
                                                @"updatedBy"  :@"varchar(255)",
                                                @"isDrawing"  :@"varchar(255)",
                                                @"fileType"   :@"varchar(255)"
                                                }];
}


@end
