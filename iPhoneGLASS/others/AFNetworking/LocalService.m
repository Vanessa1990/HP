//
//  LocalService.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/8/23.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "LocalService.h"
#import "YTKKeyValueStore.h"
#import "ListModel.h"

@interface LocalService()

@property(nonatomic,strong) YTKKeyValueStore *store;

@end

@implementation LocalService

-(instancetype)init {
    
    if (self = [super init]) {
        _store = [[YTKKeyValueStore alloc] initDBWithName:@"hp_glass.db"];
    }
    return self;
}

-(NSArray *)getLocalListArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    NSString *tableName = @"hp_glass_table";
    // 获得所有数据
    NSArray *array = [_store getAllItemsFromTable:tableName];
    if (array.count != 0) {
        NSLog(@"有数据");
        for (YTKKeyValueItem * item in array) {
            ListModel *model = [ListModel modelWithDict:item.itemObject];
            [resultArray addObject:model];
        }
    }
    return resultArray;
}


-(void)clearAllData {
    
    [_store clearTable:@"hp_glass_table"];
}

@end
