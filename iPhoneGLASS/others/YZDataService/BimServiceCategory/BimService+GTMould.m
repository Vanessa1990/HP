//
//  BimService+GTMould.m
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService+GTMould.h"

@implementation BimService (GTMould)

#pragma mark GTMould

- (SHXPromise *)getGTMouldModels:(NSString *)projectId {
    NSString *url = [NSString stringWithFormat:@"%@projects/%@/models", self.baseAPI, projectId];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

@end
