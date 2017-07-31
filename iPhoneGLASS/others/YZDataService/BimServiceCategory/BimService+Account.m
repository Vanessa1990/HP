//
//  BimService+Account.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService+Account.h"

@implementation BimService (Account)

#pragma mark - Account
// 登陆
- (SHXPromise *)login:(NSString *)name pwd:(NSString *)password
{
    NSString *url = [NSString stringWithFormat:@"%@login", self.baseAPI];//?expand=true
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"name"] = name;
    dic[@"password"] = password;
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [AFNetworkingHelper postResource:url parameters:dic];
}

// 登出
- (SHXPromise *)logout
{
    NSString *url = [NSString stringWithFormat:@"%@logout", self.baseAPI];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 验证登陆
- (SHXPromise *)getLogged
{
    NSString *url = [NSString stringWithFormat:@"%@logged?expand=true", [self baseAPI]];
    return [[AFNetworkingHelper getResource:url parameters:nil] onFulfilled:^id(id value) {
        return value;
    } rejected:^id(NSError *reason) {
        return reason;
    }];
}

// 注册
- (SHXPromise *)registerNewUserWithName:(NSString *)name andUserPwd:(NSString *)pwd attach:(NSDictionary *)attachDic
{
    NSString *url = [NSString stringWithFormat:@"%@register",self.baseAPI];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:attachDic?attachDic:@{}];
    
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:pwd forKey:@"password"];
    
    return [[AFNetworkingHelper postResource:url parameters:parameters] onFulfilled:^id(id value) {
        return value;
    } rejected:^id(NSError *reason) {
        return reason;
    }];
}

// 验证账号名是否存在(解析exists字段)
- (SHXPromise *)verifyUserAccount:(NSString *)userAccount
{
    NSString *url = [NSString stringWithFormat:@"%@user_exists?username=%@", self.baseAPI, userAccount?userAccount:@""];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 验证手机号是否存在(解析exists字段)
- (SHXPromise *)verifyUserMobile:(NSString *)mobile
{
    NSString *url = [NSString stringWithFormat:@"%@user_exists?mobile=%@", self.baseAPI, mobile?mobile:@""];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 发送手机验证码
- (SHXPromise *)postMobileVerify:(NSString *)mobile
{
    NSString *url = [NSString stringWithFormat:@"%@sms", self.baseAPI];
    return [[AFNetworkingHelper postResource:url parameters:@{@"mobile":mobile}] onFulfilled:^id(id value) {
        return [value objectForKey:@"hash"];
    }];
}

// 更改用户信息
- (SHXPromise *)putUserInfo:(NSString *)userId attach:(NSDictionary *)attachDic
{
    NSString *url = [NSString stringWithFormat:@"%@users/%@",self.baseAPI, userId];
    
    return [[AFNetworkingHelper updateResource:url parameters:attachDic] onFulfilled:^id(id value) {
        return value;
    } rejected:^id(NSError *reason) {
        return reason;
    }];
}

// 重置密码
- (SHXPromise *)resetPwd:(NSString *)userId password:(NSString *)newPwd
{
    NSString *url = [NSString stringWithFormat:@"%@users/%@/password",self.baseAPI, userId];
    return [AFNetworkingHelper updateResource:url parameters:@{@"oldPassword":[UserService instance].account.password,@"oldPassword":newPwd}];
}

// 获取用户信息
- (SHXPromise *)getUserInfo:(NSString *)userId
{
    NSString *url = [NSString stringWithFormat:@"%@users/%@?expand=true", [self baseAPI], userId];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 设置用户头像
- (SHXPromise *)sendUserAvatar:(NSString *)avatar userId:(NSString *)userId
{
    NSString *url = [NSString stringWithFormat:@"%@users/%@/avatar", self.baseAPI, userId];
    return [AFNetworkingHelper updateResource:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:[Utils reviewPath:avatar]] name:@"avatar" error:nil];
    }];
}

@end
