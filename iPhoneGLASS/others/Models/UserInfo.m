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

- (NSString *)tel {
    return self.phone;
}

- (void)setUserInfoWithModel:(UserModel *)model {
    self.userID = model.userID;
    self.name = model.name;
    self.phone = model.phone;
    self.tel = model.phone;
    self.password = model.password;
    self.admin = model.admin;
    self.JSPermission = model.JSPermission;
}

@end
