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

@property(nonatomic, strong) UIImageView *arrivedImageView;

@property(nonatomic, strong) UIButton *openButton;

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
        
        self.openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.openButton setImage:[UIImage imageNamed:@"list_hidden"] forState:UIControlStateNormal];
        [self.openButton setImage:[UIImage imageNamed:@"list_open"] forState:UIControlStateSelected];
        [self addSubview:self.openButton];
        [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.top.mas_equalTo(0);
            make.width.mas_equalTo(44);
        }];
        [self.openButton addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.totleLable= [[UILabel alloc] init];
        [self addSubview:self.totleLable];
        [self.totleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.openButton.mas_left).offset(0);
            make.centerY.mas_equalTo(0);
        }];
        
        self.arrivedImageView = [[UIImageView alloc] init];
        self.arrivedImageView.image = [UIImage imageNamed:@"arrive"];
        [self addSubview:self.arrivedImageView];
        [self.arrivedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.totleLable.mas_left).offset(-10);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)setModel:(UserListModel *)model {
    _model = model;
    self.nameLable.text = model.name;
    self.totleLable.text = [NSString stringWithFormat:@"(%@)",model.totle];
    self.arrivedImageView.hidden = !model.arrived;
    self.openButton.selected = model.openList;
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

- (void)openClick:(UIButton *)button {
    button.selected = !button.selected;
    if ([(id)self.delgate respondsToSelector:@selector(listHeadView:model:open:)]) {
        [self.delgate listHeadView:self model:self.model open:button.selected];
    }
}

@end
