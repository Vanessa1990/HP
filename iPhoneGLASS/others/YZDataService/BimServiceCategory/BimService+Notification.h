//
//  BimService+Notification.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService.h"

typedef NS_ENUM(NSInteger, YZNotificationState) {
    YZNotificationStateAll      = 0,
    YZNotificationStateIssue    = 1,
    YZNotificationStateReport   = 2,
    YZNotificationStateTask     = 3,
    YZNotificationStateMaterial = 4,
    YZNotificationStateSystem   = 5,
    YZNotificationStateDefault  = 6 // cloud issue&report&task&system
};

typedef NS_ENUM(NSInteger, YZNotificationReadState) {
    YZNotificationReadStateAll      = 0,
    YZNotificationReadStateReaded   = 1,
    YZNotificationReadStateUnReaded = 2
};

@interface BimService (Notification)

/**
 获取通知
 
 @param notificationState 通知类型
 @param readState 通知状态
 @param attach 拼接字段(可以是分页等)
 @return SHXPromise
 */
- (SHXPromise *)getNotification:(YZNotificationState)notificationState read:(YZNotificationReadState)readState attach:(NSString *)attach;
/**
 标志通知已读
 
 @param receiptArray 通知id
 @return SHXPromise
 */
- (SHXPromise *)postNotificationReceipt:(NSArray *)receiptArray;
/**
 标志某类通知已读
 
 @param notificationState 通知类型
 @return SHXPromise
 */
- (SHXPromise *)postNotificationReceiptOfState:(YZNotificationState)notificationState;

@end
