//
//  HPChooseView.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2018/3/5.
//  Copyright © 2018年 Yizhu. All rights reserved.
//

#import "HPChooseView.h"
#import "NSDate+YZBim.h"

@implementation HPChooseView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = YZ_GrayColorDE;
}

- (void)setName:(NSString *)name {
    _name = name;
    if (name) {
        [self.nameBtn setTitle:name forState:UIControlStateNormal];
        [self.nameBtn setTitle:name forState:UIControlStateSelected];
    }else{
        [self.nameBtn setTitle:@"姓名" forState:UIControlStateNormal];
        [self.nameBtn setTitle:@"姓名" forState:UIControlStateSelected];
    }
}

- (void)setFinish:(BOOL)finish {
    _finish = finish;
    if (finish) {
        [self.finishBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [self.finishBtn setTitle:@"已完成" forState:UIControlStateSelected];
    }else{
        [self.finishBtn setTitle:@"未完成" forState:UIControlStateNormal];
        [self.finishBtn setTitle:@"未完成" forState:UIControlStateSelected];
    }
}

- (void)setYear:(NSString *)year {
    _year = year;
    if (year) {
        NSDate *date = [NSDate dateFormDayString:year];
        [self.yearBtn setTitle:[date formatMonthAndDay] forState:UIControlStateNormal];
        [self.yearBtn setTitle:[date formatMonthAndDay] forState:UIControlStateSelected];
    }else{
        [self.yearBtn setTitle:@"全部" forState:UIControlStateNormal];
        [self.yearBtn setTitle:@"全部" forState:UIControlStateSelected];
    }
}

- (void)setMonth:(NSString *)month {
    _month = month;
    if (month) {
        [self.monthBtn setTitle:month forState:UIControlStateNormal];
        [self.monthBtn setTitle:month forState:UIControlStateSelected];
    }else{
        [self.monthBtn setTitle:@"全部" forState:UIControlStateNormal];
        [self.monthBtn setTitle:@"全部" forState:UIControlStateSelected];
    }
}

- (IBAction)chooseName:(id)sender {
    [self.delegate chooseViewChooseName];
}
- (IBAction)chooseState:(id)sender {
    [self.delegate chooseViewChooseState];
}

- (IBAction)chooseMonth:(id)sender {
    [self.delegate chooseViewChooseYear];
}
- (IBAction)chooseDate:(id)sender {
    [self.delegate chooseViewChooseMonth];
}
- (IBAction)clearClick:(id)sender {
    [self.delegate chooseViewClear];
}

@end

@implementation HPChooseViewButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setTitleColor:YZ_ThemeColor forState:UIControlStateNormal];
    [self setTitleColor:YZ_ThemeColor forState:UIControlStateNormal];
    self.titleLabel.font = YZ_Font(14);
    self.backgroundColor = YZ_WhiteColor;
    [self setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width * 0.7, self.bounds.size.height);
    self.imageView.frame = CGRectMake(self.bounds.size.width * 0.7, 0, self.bounds.size.width * 0.2, self.bounds.size.height);
}


@end
