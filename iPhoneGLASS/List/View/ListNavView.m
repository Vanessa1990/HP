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
    
    self.dataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dataBtn setImage:[UIImage imageNamed:@"list_date"] forState:UIControlStateNormal];
    [self.dataBtn setImage:[UIImage imageNamed:@"list_date"] forState:UIControlStateSelected];
    self.dataBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.dataBtn];
    [self.dataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.currenDateLabel.mas_right).offset(0);
    }];
    [self.dataBtn addTarget:self action:@selector(chooseData:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)chooseData:(UIButton *)sender {
    if ([(id)self.delegate respondsToSelector:@selector(chooseDate:)]) {
        sender.selected = !sender.selected;
        [self.delegate chooseDate:sender.selected];
    }
}

//- (void)changeDate:(BOOL)pre {
//    if ([(id)self.delegate respondsToSelector:@selector(getNewDateGlassDataWithPre:)]) {
//        [self.delegate getNewDateGlassDataWithPre:pre];
//    }
//}

@end
