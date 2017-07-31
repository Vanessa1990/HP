//
//  BimService+Account.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService.h"

@interface BimService (Account)

// 登陆
- (SHXPromise *)login:(NSString *)name pwd:(NSString *)password;
// 登出
- (SHXPromise *)logout;
// 验证登陆
- (SHXPromise *)getLogged;

// 注册
- (SHXPromise *)registerNewUserWithName:(NSString *)name andUserPwd:(NSString *)pwd attach:(NSDictionary *)attachDic;
// 验证账号名是否存在(解析exists字段)
- (SHXPromise *)verifyUserAccount:(NSString *)userAccount;
// 验证手机号是否存在(解析exists字段)
- (SHXPromise *)verifyUserMobile:(NSString *)mobile;
// 发送手机验证码
- (SHXPromise *)postMobileVerify:(NSString *)mobile;
// 更改用户信息
- (SHXPromise *)putUserInfo:(NSString *)userId attach:(NSDictionary *)attachDic;
// 重置密码
- (SHXPromise *)resetPwd:(NSString *)userId password:(NSString *)newPwd;

// 获取用户信息
- (SHXPromise *)getUserInfo:(NSString *)userId;
// 设置用户头像
- (SHXPromise *)sendUserAvatar:(NSString *)avatar userId:(NSString *)userId;

@end
