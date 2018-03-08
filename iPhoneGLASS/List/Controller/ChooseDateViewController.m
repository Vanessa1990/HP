//
//  ChooseDateViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2018/3/8.
//  Copyright © 2018年 Yizhu. All rights reserved.
//

#import "ChooseDateViewController.h"
#import <JTCalendar/JTCalendar.h>
#import "NSDate+YZBim.h"

@interface ChooseDateViewController ()<JTCalendarDelegate>
{
    NSDate *_beginDate;
    NSDate *_endDate;
    NSDate *_reloadDate;
}

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *CalendarMenuView;

@end

@implementation ChooseDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = YZ_Color(157, 157, 157, 0.5);
    self.calendarManager = [JTCalendarManager new];
    self.calendarManager.delegate = self;
    [self.calendarManager setMenuView:self.CalendarMenuView];
    [self.calendarManager setContentView:self.calendarContentView];
    [self.calendarManager setDate:[NSDate date]];
    
    _reloadDate = self.currentDate;
    self.monthLabel.text = [_reloadDate formatOnlyMonth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)locationInChoose:(NSDate *)date {
    if (!_beginDate && !_endDate) {
        return NO;
    }
    if ([_calendarManager.dateHelper date:date isEqualOrAfter:_beginDate] &&
        [_calendarManager.dateHelper date:date isEqualOrBefore:_endDate]) {
        return YES;
    }
    return NO;
}

//改变日历的代理方法
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.dotView.hidden = YES;
    if ([_calendarManager.dateHelper date:dayView.date isEqualOrAfter:[NSDate date]] && ![_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = YZ_Color(155, 155, 155, 0.6);
    }else{
        if (!self.muti) {
            if([_calendarManager.dateHelper date:self.currentDate isTheSameDayThan:dayView.date]){
                dayView.circleView.hidden = NO;
                dayView.circleView.backgroundColor = YZ_ThemeColor;
                dayView.textLabel.textColor = YZ_WhiteColor;
            }else{
                NSString *dateString = [dayView.date formatOnlyDay];
                if ((self.dates && [self.dates containsObject:dateString]) || !self.dates) {
                    dayView.circleView.hidden = YES;
                    dayView.textLabel.textColor = [UIColor blackColor];
                }else{
                    dayView.circleView.hidden = YES;
                    dayView.textLabel.textColor = YZ_Color(155, 155, 155, 0.6);
                }
            }
        }else{
            if([self locationInChoose:dayView.date]){
                dayView.circleView.hidden = NO;
                dayView.circleView.backgroundColor = YZ_ThemeColor;
                dayView.textLabel.textColor = YZ_WhiteColor;
            }else{
                dayView.circleView.hidden = YES;
                NSString *dateString = [dayView.date formatOnlyDay];
                if ((self.dates && [self.dates containsObject:dateString]) || !self.dates) {
                    dayView.textLabel.textColor = [UIColor blackColor];
                }else{
                    dayView.textLabel.textColor = YZ_Color(155, 155, 155, 0.6);
                }
            }
        }
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(UIView<JTCalendarDay> *)dayView {
    if ([_calendarManager.dateHelper date:dayView.date isEqualOrBefore:[NSDate date]]) {
        if (self.muti) {
            if (!_beginDate && !_endDate) {
                _beginDate = dayView.date;
                _endDate = dayView.date;
            }else{
                if([_calendarManager.dateHelper date:dayView.date isEqualOrBefore:_beginDate]){
                    _beginDate = dayView.date;
                }else if ([_calendarManager.dateHelper date:dayView.date isEqualOrAfter:_endDate]) {
                    _endDate = dayView.date;
                }else if ([self locationInChoose:dayView.date]) {
                    _beginDate = dayView.date;
                }
            }
            _reloadDate = _beginDate;
            [self.calendarManager setDate:_reloadDate];
            self.monthLabel.text = [_reloadDate formatOnlyMonth];
        }else {
            NSString *dateString = [dayView.date formatOnlyDay];
            if ((self.dates && [self.dates containsObject:dateString]) || !self.dates) {
                _reloadDate = dayView.date;
                self.currentDate = dayView.date;
                [self.calendarManager setDate:self.currentDate];
                self.monthLabel.text = [_reloadDate formatOnlyMonth];
            }
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self cancelClick:nil];
}

- (IBAction)sureClick:(id)sender {
    if ([(id)self.delegate respondsToSelector:@selector(chooseDateViewController:chooseDate:)]) {
        if (self.muti) {
            [self.delegate chooseDateViewController:self chooseDate:@[_beginDate,_endDate]];
        }else{
            [self.delegate chooseDateViewController:self chooseDate:self.currentDate];
        }
        [self cancelClick:nil];
    }
}
- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
