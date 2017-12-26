//
//  UserModel.h
//  iPhoneGLASS
//
//  Created by    Vanessa on 2017/9/7.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *createdAt;

 -(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
