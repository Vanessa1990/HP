//
//  UITabBarController+YZBim.h
//  iPhoneBIM
//
//  Created by luhai on 15/11/9.
//  Copyright © 2015年 Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (YZBim)
- (BOOL)tabBarIsVisible;
- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL))completion;
@end
