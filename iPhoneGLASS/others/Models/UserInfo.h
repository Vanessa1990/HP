//
//  UserInfo.h
//  iPhoneGLASS
//
//  Created by    Vanessa on 2017/9/7.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserModel.h"
#define admin_tel @"13852689266"

@interface UserInfo : UserModel

@property (nonatomic, strong) NSString *tel;

@property (nonatomic, strong) NSString *icon;

+ (instancetype)shareInstance;

@end
