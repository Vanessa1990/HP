//
//  CalendarView.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2018/2/7.
//  Copyright © 2018年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>
@class CalendarView;

@protocol CalendarViewDelegate

- (void)calendarView:(CalendarView *)view didTouchDate:(NSDate *)date;

@end

@interface CalendarView : UIView<JTCalendarDelegate>

+ (instancetype)calendarView;
- (instancetype)initWithDelegate:(id<CalendarViewDelegate>)delegate;
- (instancetype)initWithDelegate:(id<CalendarViewDelegate>)delegate muti:(BOOL)muti;
@property(nonatomic, strong) id<CalendarViewDelegate> delegate;

@property (assign, nonatomic) NSDate *currentDate;
@property(nonatomic, strong) NSArray *dates;

@end
