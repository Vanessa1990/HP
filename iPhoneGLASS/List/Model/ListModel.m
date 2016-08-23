//
//  ListModel.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/31.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel


+(ListModel *)modelWithDict:(NSDictionary *)dict {
    
    ListModel *model = [[ListModel alloc]init];
    model.name = dict[@"name"];
    model.thick = dict[@"thick"];
    model.number = dict[@"number"];
    model.totalNumber = dict[@"totalNumber"];
    model.date = dict[@"date"];
    model.width = dict[@"width"];
    model.height = dict[@"height"];
    model.isFinish = [dict[@"isFinish"] boolValue];
    model.wind = [dict[@"wind"] boolValue];
    model.color = [dict[@"color"] integerValue];
    model.glassID = dict[@"glassID"];
    
    return model;
}

@end
