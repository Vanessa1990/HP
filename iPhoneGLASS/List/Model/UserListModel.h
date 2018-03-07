//
//  UserListModel.h
//  iPhoneGLASS
//
//  Created by    Vanessa on 2017/9/7.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListModel.h"

@interface UserListModel : NSObject

@property(nonatomic,strong) NSString *name;

@property(nonatomic,strong) NSString *totle;

@property(nonatomic,strong) NSArray <ListModel *>*listArray;

@property (assign, nonatomic) BOOL arrived;

@end
