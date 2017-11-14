//
//  MainTabBarController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/17.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "MainTabBarController.h"
#import "WriteInViewController.h"
#import "MainNavigationController.h"
#import "HomeViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

+ (void)load
{
    [[UINavigationBar appearance] setTintColor:YZ_ThemeColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addChildVCs];
    
    self.selectedIndex = 1;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![[UserInfo shareInstance].tel isEqualToString:@"13852689266"]) {
        self.tabBar.hidden = YES;
    }
}

- (void)addChildVCs
{
    NSMutableArray *array = [NSMutableArray array];
    
    if ([UserInfo shareInstance].isAdmin) {
        WriteInViewController *HomeVC = [[WriteInViewController alloc] init];
        [self setupChildVC:HomeVC title:@"入库" imageName:@"tab_write.png" selectedImageName:@"tab_write_s.png" array:array];
    }
    
    HomeViewController *addressVC = [[HomeViewController alloc] init];
    addressVC.view.backgroundColor = YZ_ThemeGrayColor;
    [self setupChildVC:addressVC title:@"主页" imageName:@"tab_home.png" selectedImageName:@"tab_home_s.png" array:array];
    
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
