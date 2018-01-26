//
//  UITabBarController+YZBim.m
//  iPhoneBIM
//
//  Created by luhai on 15/11/9.
//  Copyright © 2015年 Dev. All rights reserved.
//

#import "UITabBarController+YZBim.h"

@implementation UITabBarController (YZBim)

- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    
    // 默认不需要动画
//    animated = NO;
    
    if ([self tabBarIsVisible] == visible) return;
    
    CGRect frame = self.tabBar.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = (visible)? -height : height;
    
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBar.frame = CGRectOffset(frame, 0, offsetY);
        [self.view layoutIfNeeded];
    } completion:completion];
}

- (BOOL)tabBarIsVisible {
    return self.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

@end
