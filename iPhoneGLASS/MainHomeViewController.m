//
//  MainHomeViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/10/15.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "MainHomeViewController.h"
#import "WriteInViewController.h"
#import "HomeViewController.h"
#import "MoreTVC.h"
#import "RegistViewController.h"
#import "JSViewController.h"

typedef enum : NSUInteger {
    ButtonMe = 0,
    ButtonList,
    ButtonWrite,
    ButtonRegist,
    ButtonJS,
} ButtonType;

@interface MainHomeViewController ()

@end

@implementation MainHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"主页";
    NSArray *titles = @[@"关于我们", @"订单列表", @"入库", @"注册", @"计算"];
    int maxRow = 3;
    CGFloat x = 15;
    CGFloat y = 15 + 64;
    CGFloat wh = ([UIScreen mainScreen].bounds.size.width - 2*x - (maxRow-1) * 15)/maxRow;
    int section = 0;
    int row = 0;
    for (NSString *item in titles) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:item forState:UIControlStateNormal];
        [button setBackgroundColor:ThemeColor];
        if (row > 2) {
            section += 1;
            row = 0;
        }
        button.frame = CGRectMake(x + (wh + 15) * row, y + (wh + 15) * section, wh, wh);
        [self.view addSubview:button];
        button.tag = section * maxRow + row;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        row++;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)btnClick:(UIButton *)button {
    if (button.tag == ButtonMe) {
        MoreTVC *vc = [[MoreTVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (button.tag == ButtonList) {
        HomeViewController *addressVC = [[HomeViewController alloc] init];
        addressVC.view.backgroundColor = YZ_ThemeGrayColor;
        [self.navigationController pushViewController:addressVC animated:YES];
    } else if (button.tag == ButtonWrite) {
        WriteInViewController *vc = [[WriteInViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (button.tag == ButtonRegist) {
        RegistViewController *registVC = [[RegistViewController alloc]init];
        [self.navigationController pushViewController:registVC animated:YES];
    } else if (button.tag == ButtonJS) {
        JSViewController *vc = [[JSViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
