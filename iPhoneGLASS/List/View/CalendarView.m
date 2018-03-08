//
//  CalendarView.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2018/2/7.
//  Copyright © 2018年 Yizhu. All rights reserved.
//

#import "CalendarView.h"
#import "NSDate+YZBim.h"

@interface CalendarView()
{
    //有事件的时间数组，我暂时没用到
    NSMutableDictionary *_eventsByDate;
    //选中的时间数组，添加时间到这个数组里则可以显示红圈，也就是选中状态
    NSMutableArray *_datesSelected;
    //设置选中的模式，YES是选中模式，NO是全部不选中。
    BOOL _selectionMode;
}

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property(nonatomic, strong) NSDate *relaodDate;
@property (weak, nonatomic) IBOutlet UIButton *nextMounthBtn;
@property (assign, nonatomic) BOOL muti;

@end

@implementation CalendarView

- (instancetype)initWithDelegate:(id<CalendarViewDelegate>)delegate muti:(BOOL)muti {
    CalendarView *view = [CalendarView calendarView];
    view.delegate = delegate;
    view.muti = muti;
    return view;
}

- (instancetype)initWithDelegate:(id<CalendarViewDelegate>)delegate {
    return [self initWithDelegate:delegate muti:NO];
}

- (JTCalendarManager *)calendarManager
{
    if (!_calendarManager) {
        _calendarManager = [[JTCalendarManager alloc] init];
    }
    return _calendarManager;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.calendarManager setMenuView:self.calendarMenuView];
    [self.calendarManager setContentView:self.calendarContentView];
    self.calendarContentView.scrollEnabled = NO;
    self.calendarManager.delegate = self;
    [self.calendarManager setDate:[NSDate date]];
    _currentDate = _currentDate?_currentDate:[NSDate new];
    _datesSelected = [NSMutableArray array];
}

+ (instancetype)calendarView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CalendarView" owner:0 options:nil] lastObject];
}

- (void)relaodMenu {
    if ([_calendarManager.dateHelper date:self.relaodDate isTheSameMonthThan:[NSDate new]]) {
        [self.nextMounthBtn setTitleColor:YZ_GrayColor9B forState:UIControlStateNormal];
        self.nextMounthBtn.userInteractionEnabled = NO;
    }else{
        [self.nextMounthBtn setTitleColor:YZ_ThemeColor forState:UIControlStateNormal];
        self.nextMounthBtn.userInteractionEnabled = YES;
    }
}

- (IBAction)preMonthClick:(id)sender {
    [self changeDate:YES];
}
- (IBAction)nextMonthClick:(id)sender {
    [self changeDate:NO];
}

- (void)changeDate:(BOOL)pre {
    //通过系统的日历类来计算时间
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    //设置需要变更的时间，年，月，日，
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.currentDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    //因为我们只需要切换月份，所有直接把月数+1就可，其他为0
    [adcomps setYear:0];
    [adcomps setMonth:pre?-1:+1];
    [adcomps setDay:0];
    //获得增加后的时间并记录起来
    self.relaodDate = [calendar dateByAddingComponents:adcomps toDate:self.relaodDate options:0];
    //设置日历当前显示的时间
    [self.calendarManager setDate:self.relaodDate];//self.relaodDate
    [self relaodMenu];
}

- (BOOL)isInDatesSelected:(NSDate *)date {
    if ([_datesSelected containsObject:date]) {
        return YES;
    }
    return NO;
}

- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    self.relaodDate = currentDate;
    //设置日历当前显示的时间
    [self.calendarManager setDate:self.currentDate];
}

- (void)setDates:(NSArray *)dates {
    _dates = dates;
    [self relaodMenu];
    [self.calendarManager reload];
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(UIView<JTCalendarDay> *)dayView {
    NSString *dateString = [dayView.date formatOnlyDay];
    if ([_calendarManager.dateHelper date:[NSDate date] isEqualOrBefore:dayView.date] && ![_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
        return;
    }
    if ((self.dates && [self.dates containsObject:dateString]) || !self.dates) {
        if (self.muti) {
            [_datesSelected addObject:dayView.date];
            [self.calendarManager reload];
        }else{
            _datesSelected = [NSMutableArray arrayWithObject:dayView.date];
            [self.calendarManager reload];
            if ([(id)self.delegate respondsToSelector:@selector(calendarView:didTouchDate:)]) {
                [self.delegate calendarView:self didTouchDate:dayView.date];
            }
        }
    }
}
//改变日历的代理方法
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.textLabel.font = YZ_Font_L;
    dayView.dotView.hidden = YES;
    //日期为今天的样式
    if ([dayView.date isKindOfClass:[NSDate class]]) {
        if ([_calendarManager.dateHelper date:[NSDate date] isEqualOrBefore:dayView.date] && ![_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
            dayView.circleView.hidden = YES;
            dayView.textLabel.textColor = YZ_Color(155, 155, 155, 0.6);
        }else{
            if([_calendarManager.dateHelper date:self.currentDate isTheSameDayThan:dayView.date]){
                dayView.circleView.hidden = NO;
                dayView.circleView.backgroundColor = YZ_ThemeColor;
                dayView.textLabel.textColor = [UIColor whiteColor];
            }
            //日期为选中模式的样式
            else if([self isInDatesSelected:dayView.date]){
                dayView.circleView.hidden = NO;
                dayView.circleView.backgroundColor = YZ_PinkColor;
                dayView.textLabel.textColor = [UIColor whiteColor];
            }
            else {
                //        //这个为本月内第一个星期里上月日期的样式
                //         if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
                //        }
                //    // 这个为下月内第一个星期里今天的样式
                //    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
                //    }
                NSString *dateString = [dayView.date formatOnlyDay];
                if ((self.dates && [self.dates containsObject:dateString]) || !self.dates) {
                    dayView.circleView.hidden = YES;
                    dayView.textLabel.textColor = [UIColor blackColor];
                }else{
                    dayView.circleView.hidden = YES;
                    dayView.textLabel.textColor = YZ_Color(155, 155, 155, 0.6);
                }
            }
            
        }
    }
}
@end
