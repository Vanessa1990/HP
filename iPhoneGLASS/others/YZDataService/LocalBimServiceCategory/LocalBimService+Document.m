//
//  LocalBimService+Document.m
//  GTiPhone
//
//  Created by 尤维维 on 2017/7/5.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService+Document.h"
#import "GTDocumentModel.h"

@implementation LocalBimService (Document)

// 同步资料列表
- (SHXPromise *)setAllDocument:(NSArray *)documents projectId:(NSString *)projectId {
    return [self setBaseArray:documents tableName:DocumentTable];
}

// 获取所有资料列表
- (SHXPromise *)getAllDocument:(NSString *)projectId {
    return [self getLocalBase:DocumentTable modelClass:[GTDocumentModel new] searchDict:@{@"projectId" : projectId}];
}

// 获取文件夹下资料列表
- (SHXPromise *)getDocumentsWithParent:(NSString *)parent {
    
    if (!parent) {
        return [self getLocalBase:DocumentTable modelClass:[GTDocumentModel new] NullKey:@"parent"];

    }else{
        return [self getDocumentsWithSearchDict:@{@"parent" : parent}];
    }
}

// 获取文件夹下资料列表
- (SHXPromise *)getDocumentsWithSearchDict:(NSDictionary *)searchDict{
    return [self getLocalBase:DocumentTable modelClass:[GTDocumentModel new] searchDict:searchDict];
}


// 获取某条资料
- (SHXPromise *)getDocument:(NSString *)documentId {
    return [[self getLocalBase:DocumentTable modelClass:[GTDocumentModel new] searchDict:@{@"_id" : documentId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

@end
