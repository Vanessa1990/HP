//
//  LocalBimService+Synchronization.h
//  GTiPhone
//
//  Created by 尤维维 on 2017/7/12.
//  Copyright © 2017年 尤维维. All rights reserved.
//

#import "LocalBimService.h"

typedef enum : NSUInteger {
    SynchronizationTypeModel,
    SynchronizationTypeDraw,
    SynchronizationTypeProblem,
} SynchronizationType;

@interface LocalBimService (Synchronization)

- (void)updateTimeForSynchronization:(SynchronizationType)type modelID:(NSString *)modelID;

- (NSDate *)getTimeForSynchronization:(SynchronizationType)type modelID:(NSString *)modelID;

@end
