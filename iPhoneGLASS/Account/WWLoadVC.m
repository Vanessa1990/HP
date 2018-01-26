//
//  WWLoadVC.m
//  12.11百思不得姐
//
//  Created by 尤维维 on 15/12/13.
//  Copyright © 2015年 youweiwei. All rights reserved.
//

#import "WWLoadVC.h"
#import "PrefixHeader.pch"
#import "WWLoadTextField.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "MainTabBarController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "BimService.h"
#import "RegistViewController.h"
#import "HomeViewController.h"
#import "MainHomeViewController.h"
#import <MJExtension.h>

@interface WWLoadVC ()

@property (weak, nonatomic) IBOutlet UIButton *loadBtn;//登录按钮
@property (weak, nonatomic) IBOutlet WWLoadTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet WWLoadTextField *pwdTextField;
@property(nonatomic,strong) MBProgressHUD *hud;



@end

@implementation WWLoadVC


-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置文本和按钮的圆角
    self.loadBtn.layer.cornerRadius = 10;
    self.loadBtn.clipsToBounds = YES;

    // test
    self.phoneTextField.text = @"13852689266";
    self.pwdTextField.text = @"888888";
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}


- (IBAction)loadClick:(id)sender {
    [self load];
}

- (void)load {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[[BimService instance] load:self.phoneTextField.text pwd:self.pwdTextField.text] onFulfilled:^id(id value) {
        // 保存数据
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
        HS_PERSISTENT_SET_OBJECT(data, USER_INFO);
        UserModel *model = [UserModel mj_objectWithKeyValues:value];
        [UserInfo shareInstance].userID = model.userID;
        [UserInfo shareInstance].name = model.name;
        [UserInfo shareInstance].phone = model.phone;
        [UserInfo shareInstance].tel = model.phone;
        [UserInfo shareInstance].password = model.password;
        [UserInfo shareInstance].admin = model.admin;
        [UserInfo shareInstance].JSPermission = model.JSPermission;
        
        //进入主界面
//        MainHomeViewController *mainTVC = [[MainHomeViewController alloc] init];
//        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:mainTVC];
        MainTabBarController *mainVC = [[MainTabBarController alloc] init];
        HP_Delegate.window.rootViewController = mainVC;
        
        return value;
    }rejected:^id(NSError *reason) {
        _hud.label.text = @"登录失败";
        [_hud hideAnimated:YES afterDelay:0.5];
        return reason;
    }];
}


- (IBAction)registClick:(id)sender {
    
    RegistViewController *VC = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
