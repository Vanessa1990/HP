//
//  LocalBimService+Draw.h
//  GTiPhone
//
//  Created by 尤维维 on 2017/6/30.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService.h"

@interface LocalBimService (Draw)

// 同步楼号
- (SHXPromise *)setAllBuild:(NSArray *)builds projectId:(NSString *)projectId;

// 同步楼层
- (SHXPromise *)setAllFloor:(NSArray *)floors projectId:(NSString *)projectId;

// 同步房间
- (SHXPromise *)setAllRoom:(NSArray *)rooms projectId:(NSString *)projectId;

// 获取所有楼号
- (SHXPromise *)getAllLocalBuild:(NSString *)projectId;

// 获取所有楼层
- (SHXPromise *)getAllLocalFloor:(NSString *)projectId;

// 获取所有房间
- (SHXPromise *)getAllLocalRoom:(NSString *)projectId;

// 获取某一楼层房间
- (SHXPromise *)getRooms:(NSString *)projectID floor:(NSString *)floor;

// 获取某一楼号
- (SHXPromise *)getLocalBuild:(NSString *)buildId;

// 获取某一楼层
- (SHXPromise *)getLocalFloor:(NSString *)floorId;

// 获取某一房间
- (SHXPromise *)getLocalRoom:(NSString *)roomId;

// 同步图纸资料信息
- (SHXPromise *)setDrawDocument:(NSArray *)draeDocuments projectId:(NSString *)projectId;

// 获取所有图纸资料信息
- (SHXPromise *)getAllDrawDocument:(NSString *)projectId;

// 获取某一图纸资料信息
- (SHXPromise *)getDrawDocument:(NSString *)drawDocumentId;

// 同步图钉
- (SHXPromise *)setDrawPin:(NSArray *)drawPins projectId:(NSString *)projectId;

// 获取某一图钉
- (SHXPromise *)getDrawPin:(NSString *)drawPinId;

// 获取某一图纸资料下图钉
- (SHXPromise *)getDrawPinFromDocument:(NSString *)drawDocumentId;

@end
