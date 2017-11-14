//
//  UserInfo.h
//  iPhoneGLASS
//
//  Created by    Vanessa on 2017/9/7.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define admin_tel @"13852689266"

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *tel;

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSString *icon;

@property (assign, nonatomic, getter=isAdmin) BOOL admin;

+ (instancetype)shareInstance;

@end
