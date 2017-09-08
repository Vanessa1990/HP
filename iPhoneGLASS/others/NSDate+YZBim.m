//
//  NSDate+YZBim.m
//  BIM
//
//  Created by Dion Chen on 15/5/22.
//  Copyright (c) 2015年 Pu Mai. All rights reserved.
//

#import "NSDate+YZBim.h"

@implementation NSDate (YZBim)

+ (NSDate*)dateFromISOString:(NSString*)dateString {
    if (!dateString || (NSNull *)dateString == [NSNull null]) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    if (!dateString || (NSNull *)dateString == [NSNull null]) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date= [formatter dateFromString:dateString];
    return date;
}

+ (NSDate *)dateFormDayString:(NSString *)dateString
{
    if (!dateString || (NSNull *)dateString == [NSNull null]) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date= [formatter dateFromString:dateString];
    return date;
}

- (NSString *)formatISO
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    return [formatter stringFromDate:self];
}

- (NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:self];
}

- (NSString *)formatWithoutSec
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yy-MM-dd HH:mm";
    return [formatter stringFromDate:self];
}

- (NSString *)formatOnlyDay
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:self];
}

- (NSString *)formatOnlyTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    return [formatter stringFromDate:self];
}

- (NSString *)formatMonthAndDay
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月dd日";
    return [formatter stringFromDate:self];
}

- (BOOL)equalWith:(NSDate *)date
{
    return ([self compare:date] == NSOrderedSame);
}

- (float)calculateDays
{
    NSTimeInterval before = [self timeIntervalSince1970] * 1;
    NSDate * localDate = [NSDate date];
    NSTimeInterval now = [localDate timeIntervalSince1970] * 1;
    NSTimeInterval seconds = now - before;
    NSInteger days = seconds / 24 / 60 / 60.0;
    return days;
}

@end
