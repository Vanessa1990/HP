//
//  ListNavView.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/18.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "ListNavView.h"


@implementation ListNavView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate {
    if (self = [self initWithFrame:frame]) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.currenDateLabel = [[UILabel alloc] init];
    [self addSubview:self.currenDateLabel];
    self.currenDateLabel.font = YZ_Font(18);
    self.currenDateLabel.textAlignment = NSTextAlignmentCenter;
    [self.currenDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.top.bottom.mas_equalTo(0);
        make.center.mas_equalTo(self);
    }];
    
    self.preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.preBtn setImage:[UIImage imageNamed:@"list_pre"] forState:UIControlStateNormal];
    self.preBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.preBtn setTitleColor:YZ_ThemeColor forState:UIControlStateNormal];
    [self addSubview:self.preBtn];
    [self.preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.currenDateLabel.mas_left).offset(0);
    }];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextBtn setImage:[UIImage imageNamed:@"list_next"] forState:UIControlStateNormal];
    self.nextBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.nextBtn setTitleColor:YZ_ThemeColor forState:UIControlStateNormal];
    [self addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.currenDateLabel.mas_right).offset(0);
    }];
    
    [self.preBtn addTarget:self action:@selector(preClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)preClick:(id)sender {
    [self changeDate:YES];
}

- (void)nextClick:(id)sender {
    [self changeDate:NO];
}

- (void)changeDate:(BOOL)pre {
    if ([(id)self.delegate respondsToSelector:@selector(getNewDateGlassDataWithPre:)]) {
        [self.delegate getNewDateGlassDataWithPre:pre];
    }
}

@end
