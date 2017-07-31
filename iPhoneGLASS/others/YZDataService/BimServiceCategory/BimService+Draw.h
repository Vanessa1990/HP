//
//  BimService+Draw.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService.h"

// 请求图钉时的追加字段
typedef NS_ENUM(NSInteger, GTDrawInfoExtendType) {
    GTDrawInfoExtendTypeNone = 1,
    GTDrawInfoExtendTypeInfo,
    GTDrawInfoExtendTypeIssue
};

@interface BimService (Draw)

- (SHXPromise *)getAllBuilds:(NSString *)projectID;
- (SHXPromise *)getAllFloors:(NSString *)projectID;
- (SHXPromise *)getAllRooms:(NSString *)projectID;

// 获取图纸
- (SHXPromise *)getDrawDocumentByDocumentId:(NSString *)documentId;
// 获取图纸
- (SHXPromise *)getDrawDocument:(NSDictionary *)dict;

// 获取所有图纸信息
- (SHXPromise *)getAllDrawDocument:(NSString *)projectID;

// 创建图钉
- (SHXPromise *)createDrawPin:(NSString *)projectId documentId:(NSString *)documentId point:(CGPoint)point attach:(NSDictionary *)attachDic;
// 获取所有图钉
- (SHXPromise *)getDrawPins:(NSString *)documentId drawInfoType:(GTDrawInfoExtendType)infoType attach:(NSDictionary *)attach;
// 获取单个图钉
- (SHXPromise *)getDrawPin:(NSString *)pinId;
// 根据doucment获取file
- (SHXPromise *)getPinFromDocument:(NSString *)documentId;

@end
