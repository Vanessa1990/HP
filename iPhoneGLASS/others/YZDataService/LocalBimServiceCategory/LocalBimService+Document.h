//
//  LocalBimService+Document.h
//  GTiPhone
//
//  Created by 尤维维 on 2017/7/5.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService.h"

@interface LocalBimService (Document)

// 同步资料列表
- (SHXPromise *)setAllDocument:(NSArray *)documents projectId:(NSString *)projectId;

// 获取所有资料列表
- (SHXPromise *)getAllDocument:(NSString *)projectId;

// 获取文件夹下资料列表
- (SHXPromise *)getDocumentsWithParent:(NSString *)parent;

// 获取文件夹下资料列表
- (SHXPromise *)getDocumentsWithSearchDict:(NSDictionary *)searchDict;

// 获取某条资料
- (SHXPromise *)getDocument:(NSString *)documentId;

@end
