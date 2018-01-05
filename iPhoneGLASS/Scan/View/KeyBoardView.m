//
//  KeyBoardView.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/30.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "KeyBoardView.h"

@implementation KeyBoardButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = YZ_ThemeAlphaC;
    }else{
        self.backgroundColor = YZ_WhiteColor;
    }
}

@end

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
    CGFloat width = (kScreenWidth - margin *5)/4;
    CGFloat width2 = (kScreenWidth - margin *2)/1;
    CGFloat height = (self.frame.size.height - margin *4)/4;
    CGFloat x = margin;
    CGFloat y = margin;
    for (int i = 0; i < 13; i ++) {
        KeyBoardButton *button = [KeyBoardButton buttonWithType:UIButtonTypeCustom];
        if (i < 9) {
            x = margin + (margin + width)*(i % 3);
            y = margin + (margin + height)*(i / 3);
            [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateSelected];
        }else{
            y = margin * 4 + height * 3;
            x = margin + (margin + width) * 3;
            if (i == 9) {
                y = margin;
                x = margin + (margin + width) * 3;
                [button setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateSelected];
            }else if (i == 10) {
                y = margin * 2 + height;
                [button setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateSelected];
            }else if (i == 11) {
                y = margin * 3 + height * 2;
                [button setTitle:[NSString stringWithFormat:@"*"] forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"*"] forState:UIControlStateSelected];
            }else if (i == 12) {
                y = margin * 4 + height * 3;
                x = margin;
                [button setTitle:[NSString stringWithFormat:@"搜索"] forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"搜索"] forState:UIControlStateSelected];
            }
        }
        button.tag = i;
        [button setTitleColor:YZ_GrayColor26 forState:UIControlStateNormal];
        [button setTitleColor:YZ_WhiteColor forState:UIControlStateHighlighted];
        if (i < 12) {
            button.frame = CGRectMake(x, y, width, height);
            button.titleLabel.font = YZ_Font(24);
        } else {
            button.frame = CGRectMake(x, y, width2, height);
            button.titleLabel.font = YZ_Font(22);
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
