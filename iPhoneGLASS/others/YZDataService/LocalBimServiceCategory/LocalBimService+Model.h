//
//  LocalBimService+Model.h
//  GTiPhone
//
//  Created by 尤维维 on 2017/6/30.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService.h"

@interface LocalBimService (Model)

/**同步所有模型*/
- (SHXPromise *)setAllModel:(NSArray *)modelArray;
/**获取本地所有模型*/
- (SHXPromise *)getAllLocalModel:(NSString *)projectId;
/**获取某条模型*/
- (SHXPromise *)getLocalModel:(NSString *)modelId;


@end
