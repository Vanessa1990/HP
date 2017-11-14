//
//  UserInfo.m
//  iPhoneGLASS
//
//  Created by    Vanessa on 2017/9/7.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *_instance = nil;

@implementation UserInfo

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

- (BOOL)isAdmin {
    return [self.tel isEqualToString:admin_tel];
}

@end
