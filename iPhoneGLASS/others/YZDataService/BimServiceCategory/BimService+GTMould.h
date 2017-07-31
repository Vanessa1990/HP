//
//  BimService+GTMould.h
//  GTiPhone
//
//  Created by cyhll on 2017/6/23.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService.h"

@interface BimService (GTMould)

#pragma mark GTMould
- (SHXPromise *)getGTMouldModels:(NSString *)projectId;

@end
