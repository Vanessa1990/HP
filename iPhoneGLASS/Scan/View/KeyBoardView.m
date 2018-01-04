//
//  KeyBoardView.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/30.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "KeyBoardView.h"

@implementation KeyBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = YZ_GrayColorDE;
    CGFloat margin = 1;
    CGFloat width = (kScreenWidth - margin *4)/3;
    CGFloat width2 = (kScreenWidth - margin *5)/4;
    CGFloat height = (self.frame.size.height - margin *4)/4;
    CGFloat x = margin;
    CGFloat y = margin;
    for (int i = 0; i < 13; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i < 9) {
            x = margin + (margin + width)*(i % 3);
            y = margin + (margin + height)*(i / 3);
            [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        }else{
            y = margin * 4 + height * 3;
            x = margin + (margin + width2) * (i - 9);
            if (i == 9) {
                [button setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
            }else if (i == 10) {
                [button setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
            }else if (i == 11) {
                [button setTitle:[NSString stringWithFormat:@"*"] forState:UIControlStateNormal];
            }else if (i == 12) {
                [button setTitle:[NSString stringWithFormat:@"搜索"] forState:UIControlStateNormal];
            }
        }
        button.tag = i;
        [button setTitleColor:YZ_GrayColor26 forState:UIControlStateNormal];
        if (i < 9) {
            button.frame = CGRectMake(x, y, width, height);
            button.titleLabel.font = YZ_Font(24);
        } else {
            button.frame = CGRectMake(x, y, width2, height);
            if (i == 11) {
                button.titleLabel.font = YZ_Font(24);
            }else{
                button.titleLabel.font = YZ_Font(22);
            }
        }
        button.backgroundColor = YZ_WhiteColor;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    
}

- (void)btnClick:(UIButton *)button {
    if (button.tag < 9) {
        if ([(id)self.delegate respondsToSelector:@selector(chooseNumber:)]) {
            [self.delegate chooseNumber:button.tag+1];
        }
    }else if (button.tag == 9) {
        if ([(id)self.delegate respondsToSelector:@selector(deleteNumber)]) {
            [self.delegate deleteNumber];
        }
    }else if (button.tag == 10) {
        if ([(id)self.delegate respondsToSelector:@selector(chooseNumber:)]) {
            [self.delegate chooseNumber:0];
        }
    }else if (button.tag == 11) {
        if ([(id)self.delegate respondsToSelector:@selector(addSeparator)]) {
            [self.delegate addSeparator];
        }
    }else if (button.tag == 12) {
        if ([(id)self.delegate respondsToSelector:@selector(searchFunc)]) {
            [self.delegate searchFunc];
        }
    }
}

@end
