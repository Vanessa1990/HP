//
//  BimService+Document.h
//  GTiPhone
//
//  Created by 尤维维 on 2017/7/5.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "BimService.h"

@interface BimService (Document)

/**获取所有的资料文件*/
- (SHXPromise *)getAllDocument:(NSString *)projectId parentId:(NSString *)parentId;

/**
 获取设计图纸资料
*/
- (SHXPromise *)getAllDrawDocument:(NSString *)projectId parentId:(NSString *)parentId;

@end
