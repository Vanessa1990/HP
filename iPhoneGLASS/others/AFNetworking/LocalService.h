//
//  LocalService.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/8/23.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalService : NSObject

//获取本地所有列表的数据
-(NSArray *)getLocalListArray;


//清除数据库所有数据
-(void)clearAllData;

@end
