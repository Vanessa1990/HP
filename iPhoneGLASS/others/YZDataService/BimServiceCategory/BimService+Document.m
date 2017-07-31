//
//  BimService+Document.m
//  GTiPhone
//
//  Created by 尤维维 on 2017/7/5.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService+Document.h"

@implementation BimService (Document)

/**获取所有的资料文件*/
- (SHXPromise *)getAllDocument:(NSString *)projectId parentId:(NSString *)parentId
{
    NSDictionary *dict = @{@"parent": VALID_STRING(parentId)?parentId:[NSNull null]};
    NSString *string = [Utils jsonString:dict];
    NSString *url = [NSString stringWithFormat:@"%@documents?projectid=%@&where=%@", self.baseAPI, projectId, string];
    return [AFNetworkingHelper getResource:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil];
}


/**
 获取设计图纸资料

 @param projectId <#projectId description#>
 @param parentId <#parentId description#>
 @return <#return value description#>
 */
- (SHXPromise *)getAllDrawDocument:(NSString *)projectId parentId:(NSString *)parentId
{
    NSDictionary *dict = @{@"parent": VALID_STRING(parentId)?parentId:[NSNull null],@"fileType":@"drawing"};
    NSString *string = [Utils jsonString:dict];
    NSString *url = [NSString stringWithFormat:@"%@documents?projectid=%@&where=%@", self.baseAPI, projectId, string];
    return [AFNetworkingHelper getResource:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil];
}

@end
