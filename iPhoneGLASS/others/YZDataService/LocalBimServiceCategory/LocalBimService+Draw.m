//
//  LocalBimService+Draw.m
//  GTiPhone
//
//  Created by 尤维维 on 2017/6/30.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService+Draw.h"
#import "BuildModel.h"
#import "DrawDocumentModel.h"
#import "DrawViewPinModel.h"

@implementation LocalBimService (Draw)

- (SHXPromise *)setAllBuild:(NSArray *)builds projectId:(NSString *)projectId {
    return [self setBaseArray:builds tableName:BuildTable];
}

- (SHXPromise *)setAllFloor:(NSArray *)floors projectId:(NSString *)projectId {
    return [self setBaseArray:floors tableName:FloorTable];
}

- (SHXPromise *)setAllRoom:(NSArray *)rooms projectId:(NSString *)projectId {
    return [self setBaseArray:rooms tableName:RoomTable];
}

// 获取所有楼号
- (SHXPromise *)getAllLocalBuild:(NSString *)projectId {
    return [self getLocalBase:BuildTable modelClass:[BuildModel new] unarchiveKeys:@[@"files",@"documentIds"]  searchDict:@{@"projectId" : projectId}];
}

// 获取所有楼层
- (SHXPromise *)getAllLocalFloor:(NSString *)projectId {
    return [self getLocalBase:FloorTable modelClass:[FloorModel new] unarchiveKeys:@[@"files",@"documentIds"] searchDict:@{@"projectId" : projectId}];
}

// 获取所有房间
- (SHXPromise *)getAllLocalRoom:(NSString *)projectId {
    return [self getLocalBase:RoomTable modelClass:[RoomModel new] unarchiveKeys:@[@"files",@"documentIds"] searchDict:@{@"projectId" : projectId}];
}

- (SHXPromise *)getRooms:(NSString *)projectID floor:(NSString *)floor{
     return [self getLocalBase:RoomTable modelClass:[RoomModel new] unarchiveKeys:@[@"files",@"documentIds"] searchDict:@{@"floor" : floor}];
}

// 获取某一楼号
- (SHXPromise *)getLocalBuild:(NSString *)buildId {
    return [[self getLocalBase:BuildTable modelClass:[BuildModel new] unarchiveKeys:@[@"files",@"documentIds"] searchDict:@{@"_id" : buildId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

// 获取某一楼层
- (SHXPromise *)getLocalFloor:(NSString *)floorId {
    return [[self getLocalBase:FloorTable modelClass:[FloorModel new] unarchiveKeys:@[@"files",@"documentIds"] searchDict:@{@"_id" : floorId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

// 获取某一房间
- (SHXPromise *)getLocalRoom:(NSString *)roomId {
    return [[self getLocalBase:RoomTable modelClass:[RoomModel new] unarchiveKeys:@[@"files",@"documentIds"] searchDict:@{@"_id" : roomId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

// 同步图纸资料信息
- (SHXPromise *)setDrawDocument:(NSArray *)draeDocuments projectId:(NSString *)projectId {
    return [self setBaseArray:draeDocuments tableName:DrawDocumentTable];
}

// 获取所有图纸资料信息
- (SHXPromise *)getAllDrawDocument:(NSString *)projectId {
    return [self getLocalBase:DrawDocumentTable modelClass:[DrawDocumentModel new] searchDict:@{@"projectId" : projectId}];
}

// 获取某一图纸资料信息
- (SHXPromise *)getDrawDocument:(NSString *)drawDocumentId {
    return [[self getLocalBase:DrawDocumentTable modelClass:[DrawDocumentModel new] searchDict:@{@"_id" : drawDocumentId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

// 同步图钉
- (SHXPromise *)setDrawPin:(NSArray *)drawPins projectId:(NSString *)projectId {
    return [self setBaseArray:drawPins tableName:DrawPinTable];
}

// 获取某一图钉
- (SHXPromise *)getDrawPin:(NSString *)drawPinId {
    return [[self getLocalBase:DrawPinTable modelClass:[DrawViewPinModel new] unarchiveKeys:@[@"building",@"floor",@"room"] searchDict:@{@"_id" : drawPinId}] onFulfilled:^id(NSArray *value) {
        return value[0];
    }];
}

// 获取某一图纸资料下图钉
- (SHXPromise *)getDrawPinFromDocument:(NSString *)drawDocumentId {
    return [[self getLocalBase:DrawPinTable modelClass:[DrawViewPinModel new] unarchiveKeys:@[@"building",@"floor",@"room"] searchDict:@{@"documentId" : drawDocumentId}] onFulfilled:^id(id value) {
        return value;
    }rejected:^id(NSError *reason) {
        if (reason.code == 400) {
            return @[];
        }else{
            return reason;
        }
    }];
}

@end
