//
//  ListHeadView.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/31.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "ListHeadView.h"
#import <Masonry.h>

@interface  ListHeadView()
@property(nonatomic, strong) UIButton *chooseButton;
@property(nonatomic, strong) ChooseBlock blcok;

@property (strong, nonatomic) UILabel *nameLable;

@property (strong, nonatomic) UILabel *totleLable;

@property (strong, nonatomic) UILabel *dateLable;

@end

@implementation ListHeadView
- (instancetype)initWithFrame:(CGRect)frame chooseClick:(ChooseBlock)chooseClick {
    if (self = [self initWithFrame:frame]) {
        self.blcok = chooseClick;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = YZ_ThemeGrayColor;
        self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.chooseButton setTitle:@"全选" forState:UIControlStateNormal];
        [self.chooseButton setTitleColor:YZ_ThemeColor forState:UIControlStateNormal];
        self.chooseButton.titleLabel.font = YZ_Font_M;
        [self.chooseButton addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.chooseButton];
        [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(0);
        }];
        
        self.nameLable = [[UILabel alloc] init];
        [self addSubview:self.nameLable];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.chooseButton.mas_right);
            make.centerY.mas_equalTo(0);
        }];
        
        self.totleLable= [[UILabel alloc] init];
        [self addSubview:self.totleLable];
        [self.totleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setModel:(UserListModel *)model {
    _model = model;
    self.nameLable.text = model.name;
    self.totleLable.text = [NSString stringWithFormat:@"(共%@块)",model.totle];
}

- (void)setEdit:(BOOL)edit {
    _edit = edit;
    self.chooseButton.selected = NO;
    [self.chooseButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(edit?64:0);
    }];
}

- (void)setChoosed:(BOOL)choosed {
    _choosed = choosed;
    self.chooseButton.selected = choosed;
}

- (void)chooseClick:(id)button {
    if (self.blcok) {
        self.blcok(self.model,YES);
    }
}

@end
