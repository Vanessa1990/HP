//
//  MainTabBarController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/17.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "WriteInViewController.h"
#import "HomeViewController.h"
#import "MoreTVC.h"
#import "JSViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

+ (void)load
{
    [[UINavigationBar appearance] setTintColor:YZ_ThemeColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addChildVCs];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([UserInfo shareInstance].admin) {
        self.selectedIndex = 1;
    }else{
        self.selectedIndex = 0;
    }
}

- (void)addChildVCs
{
    NSMutableArray *array = [NSMutableArray array];

    if ([UserInfo shareInstance].admin) {
        WriteInViewController *vc = [[WriteInViewController alloc] init];
        [self setupChildVC:vc title:@"管理" imageName:@"tab_write.png" selectedImageName:@"tab_write_s.png" array:array];
        self.selectedIndex = 1;
    }else{
        self.selectedIndex = 0;
    }
    HomeViewController *listVC = [[HomeViewController alloc] init];
    [self setupChildVC:listVC title:@"列表" imageName:@"tab_home.png" selectedImageName:@"tab_home_s.png" array:array];
    if ([UserInfo shareInstance].JSPermission) {
        JSViewController *vc = [[JSViewController alloc] init];
        [self setupChildVC:vc title:@"计算" imageName:@"tab_write.png" selectedImageName:@"tab_write_s.png" array:array];
    }
    MoreTVC *moreVC = [[MoreTVC alloc] init];
    [self setupChildVC:moreVC title:@"更多" imageName:@"tab_home.png" selectedImageName:@"tab_home_s.png" array:array];
    
    self.viewControllers = array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupChildVC:(UIViewController *)VC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName array:(NSMutableArray *)array
{
    MainNavigationController *mainnc = [[MainNavigationController alloc] initWithRootViewController:VC];
    
    VC.title = title;
    UIImage *maImage1 = [UIImage imageNamed:imageName];
    UIImage *maImage2 = [UIImage imageNamed:selectedImageName];
    VC.tabBarItem.image = [maImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.selectedImage = [maImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: YZ_GrayColor9B, NSFontAttributeName: YZ_Font(13)} forState:UIControlStateNormal];
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: YZ_ThemeColor, NSFontAttributeName: YZ_Font(13)} forState:UIControlStateSelected];
    [array addObject:mainnc];
}


@end
