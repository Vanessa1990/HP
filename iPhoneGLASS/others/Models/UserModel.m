//
//  UserModel.m
//  iPhoneGLASS
//
//  Created by    Vanessa on 2017/9/7.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"_id"]) {
        self.userID = value;
    }
    NSLog(@"%@",key);
}

//+ (instancetype)userWithDict:(NSDictionary *)dict {
//
//}

@end
