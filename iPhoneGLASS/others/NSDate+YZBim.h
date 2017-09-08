//
//  NSDate+YZBim.h
//  BIM
//
//  Created by Dion Chen on 15/5/22.
//  Copyright (c) 2015年 Pu Mai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YZBim)

- (NSString *)formatISO;
- (NSString *)format;
- (NSString *)formatWithoutSec;
- (NSString *)formatOnlyDay;
- (NSString *)formatOnlyTime;
- (NSString *)formatMonthAndDay;
- (float)calculateDays;
- (BOOL)equalWith:(NSDate *)date;

+ (NSDate *)dateFromISOString:(NSString *)dateString;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSDate *)dateFormDayString:(NSString *)dateString;

@end
