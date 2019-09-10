//
//  UIViewController+HP.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2018/1/26.
//  Copyright © 2018年 Yizhu. All rights reserved.
//

#import "UIViewController+HP.h"

@implementation UIViewController (HP)

- (void)setBackItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}

- (void)setShowTabItem {
    [self setBackItem];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab_show"] style:UIBarButtonItemStyleDone target:self action:@selector(showTab)];
//    self.navigationItem.leftBarButtonItem = item;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showTab {
    if (![self.tabBarController tabBarIsVisible]) {
        [self.tabBarController setTabBarVisible:YES animated:YES completion:nil];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tabBarController setTabBarVisible:NO animated:YES completion:nil];
//        });
    }
}


@end
