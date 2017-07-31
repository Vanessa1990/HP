//
//  LocalBimService+QRCode.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService.h"

@class QRModel;

@interface LocalBimService (QRCode)

/**同步二维码表*/
- (SHXPromise *)setLocalQR:(NSArray *)qrArray projectID:(NSString *)projectID;
/**删除二维码*/
- (SHXPromise *)delLocalQRs:(NSArray *)qrIds;

/**查询某个二维码*/
- (QRModel *)getQRModel:(NSString *)modelID projectID:(NSString *)projectID;
/**通过二维码查询二维码记录*/
- (QRModel *)getQRModelByCode:(NSString *)code projectID:(NSString *)projectID;
/**通过构件查询二维码记录*/
- (QRModel *)getLocalQRModelByEntityUUID:(NSString *)uuid projectID:(NSString *)projectID;

@end
