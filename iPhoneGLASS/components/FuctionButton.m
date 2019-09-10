//
//  FuctionButton.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2019/9/9.
//  Copyright © 2019年 Yizhu. All rights reserved.
//

#import "FuctionButton.h"

@interface FuctionButton ()


@end

@implementation FuctionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 高亮的时候不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 背景
        [self setTitleColor:YZ_GrayColor61 forState:UIControlStateNormal];
    }
    return self;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 33;
    CGFloat imageH = contentRect.size.height*0.6;
    CGFloat imageY = 0;
    CGFloat imageX = (contentRect.size.width - 33)/2;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height*0.6;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleX = 0;
    CGFloat titleH = contentRect.size.height*0.4;
    return CGRectMake(titleX, titleY, titleW, titleH);
}


@end
