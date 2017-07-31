//
//  LocalBimService+Synchronization.m
//  GTiPhone
//
//  Created by 尤维维 on 2017/7/12.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService+Synchronization.h"

@implementation LocalBimService (Synchronization)

- (void)updateTimeForSynchronization:(SynchronizationType)type modelID:(NSString *)modelID
{
    NSDictionary * dict = [[LocalBimService instance] getObjectWithProjectId:YZ_CURRENT_PROJECTID userId:[UserService instance].user.userId fileName:@"Synchronization_Date"];
    NSString *oneKey;
    if (type == SynchronizationTypeModel) {
        oneKey = @"模型";
        
    }else if (type == SynchronizationTypeProblem) {
        oneKey = @"问题";
    }else if (type == SynchronizationTypeDraw) {
        oneKey = @"索引图纸";
    }
    NSMutableDictionary *modelDict;
    if (dict && dict && [dict isKindOfClass:[NSDictionary class]] ) {
        modelDict = dict[oneKey]?[NSMutableDictionary dictionaryWithDictionary:dict[oneKey]]:[NSMutableDictionary dictionary];
        [modelDict removeObjectForKey:modelID];
    }else{
        dict = [NSMutableDictionary dictionary];
        modelDict = [NSMutableDictionary dictionary];
    }
    
    [modelDict setObject:[NSDate new] forKey:modelID];
    
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [newDict removeObjectForKey:oneKey];
    [newDict setObject:modelDict forKey:oneKey];
    [[LocalBimService instance] setObject:newDict projectId:YZ_CURRENT_PROJECTID userId:[UserService instance].user.userId fileName:@"Synchronization_Date"];
}


- (NSDate *)getTimeForSynchronization:(SynchronizationType)type modelID:(NSString *)modelID
{
    NSDictionary * dict = [[LocalBimService instance] getObjectWithProjectId:YZ_CURRENT_PROJECTID userId:[UserService instance].user.userId fileName:@"Synchronization_Date"];
    
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSDictionary *modelDict;
        if (type == SynchronizationTypeModel) {
            if (dict[@"模型"]){
                modelDict = [NSDictionary dictionaryWithDictionary:dict[@"模型"]];
            }
        }else if (type == SynchronizationTypeProblem) {
            if (dict[@"问题"]){
                modelDict = [NSDictionary dictionaryWithDictionary:dict[@"问题"]];
            }
        }else if (type == SynchronizationTypeDraw) {
            if (dict[@"索引图纸"]){
                modelDict = [NSDictionary dictionaryWithDictionary:dict[@"索引图纸"]];
            }
        }
        
        if ([modelDict objectForKey:modelID]) {
            return [modelDict objectForKey:modelID];
        }
    }
    
    return nil;
}

@end
