//
//  BimService+Notification.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService+Notification.h"

@implementation BimService (Notification)

/**
 获取通知
 
 @param notificationState 通知类型
 @param readState 通知状态
 @param attach 拼接字段(可以是分页等)
 @return SHXPromise
 */
- (SHXPromise *)getNotification:(YZNotificationState)notificationState read:(YZNotificationReadState)readState attach:(NSString *)attach
{
    NSString *typeString = [self getNotificationTypeAttach:notificationState];
    
    NSString *readString;
    switch (readState) {
        case YZNotificationReadStateAll:
            readString = nil;
            break;
        case YZNotificationReadStateReaded:
            readString = @"unRead=false";
            break;
        case YZNotificationReadStateUnReaded:
            readString = @"unRead=true";
            break;
        default:
            readString = nil;
            break;
    }
    
    // notifications
    NSString *url = [NSString stringWithFormat:@"%@notifications?%@%@%@", self.baseAPI, typeString, readString?[NSString stringWithFormat:@"&%@", readString]:@"", attach?[NSString stringWithFormat:@"&%@", attach]:@""];
    
    return [AFNetworkingHelper getResource:url parameters:nil];
}

/**
 标志通知已读
 
 @param receiptArray 通知id
 @return SHXPromise
 */
- (SHXPromise *)postNotificationReceipt:(NSArray *)receiptArray
{
    NSString *url = [NSString stringWithFormat:@"%@notifications/receipts", self.baseAPI];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:receiptArray forKey:@"notifyIds"];
    
    return [AFNetworkingHelper postResource:url parameters:parameters];
}

/**
 标志某类通知已读
 
 @param notificationState 通知类型
 @return SHXPromise
 */
- (SHXPromise *)postNotificationReceiptOfState:(YZNotificationState)notificationState
{
    NSString *typeString = [self getNotificationTypeAttach:notificationState];
    
    NSString *url = [NSString stringWithFormat:@"%@notifications/receipts?%@", self.baseAPI, typeString];
    return [AFNetworkingHelper postResource:url parameters:nil];
}

// 通知类型转换为attach
- (NSString *)getNotificationTypeAttach:(YZNotificationState)notificationState
{
    NSString *typeString;
    switch (notificationState) {
        case YZNotificationStateAll:
            typeString = @"type=issue&type=report&type=task&type=material&type=system";
            break;
        case YZNotificationStateIssue:
            typeString = @"type=issue";
            break;
        case YZNotificationStateReport:
            typeString = @"type=report";
            break;
        case YZNotificationStateTask:
            typeString = @"type=task";
            break;
        case YZNotificationStateMaterial:
            typeString = @"type=material";
            break;
        case YZNotificationStateSystem:
            typeString = @"type=system";
            break;
        case YZNotificationStateDefault:
            typeString = @"type=issue_create";
        default:
            typeString = @"type=issue_create";
            break;
    }
    return typeString;
}

@end
