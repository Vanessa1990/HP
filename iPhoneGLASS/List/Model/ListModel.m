//
//  ListModel.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/31.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

/*
 2016-05-31 14:47:48.242 iPhoneGLASS[24110:3347258] color __NSCFNumber
 2016-05-31 14:47:48.242 iPhoneGLASS[24110:3347258] wind __NSCFBoolean
 2016-05-31 14:47:48.242 iPhoneGLASS[24110:3347258] isFinish __NSCFBoolean
 */

+(ListModel *)modelWithDict:(NSDictionary *)dict {
    
    ListModel *model = [[ListModel alloc]init];
    model.name = dict[@"name"];
    model.thick = dict[@"thick"];
    model.number = dict[@"number"];
    model.date = dict[@"date"];
    model.width = dict[@"width"];
    model.height = dict[@"height"];
    model.isFinish = [dict[@"isFinish"] boolValue];
    model.wind = [dict[@"wind"] boolValue];
    model.color = [dict[@"color"] integerValue];
    
    return model;
}

@end
