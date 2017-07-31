//
//  LocalBimService+Announce.h
//  GTiPhone
//
//  Created by 尤维维 on 2017/6/27.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService.h"

@interface LocalBimService (Announce)

/**同步所有公告*/
- (SHXPromise *)setAllAnnounce:(NSArray *)announceArray;
/**获取本地所有公告*/
- (SHXPromise *)getAllLocalAnnounce:(NSString *)projectId;
/**获取某条公告*/
- (SHXPromise *)getLocalAnnounce:(NSString *)announceId;

@end
