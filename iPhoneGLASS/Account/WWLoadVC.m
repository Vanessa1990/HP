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
    
    // 自动登录
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userdict = [user objectForKey:@"user"];
//    if ([userdict objectForKey:@"name"]) {
//        //进入主界面
//        MainTabBarController *mainTVC = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
//        HP_Delegate.window.rootViewController = mainTVC;
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //1.设置文本和按钮的圆角
    self.loadBtn.layer.cornerRadius = 10;
    self.loadBtn.clipsToBounds = YES;
    
    // test
    self.phoneTextField.text = admin_tel;
    self.pwdTextField.text = @"123456";
}


- (IBAction)loadClick:(id)sender {

    // test
    //进入主界面
    MainHomeViewController *mainTVC = [[MainHomeViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:mainTVC];
    HP_Delegate.window.rootViewController = navc;
    
    [UserInfo shareInstance].name = self.phoneTextField.text;
    [UserInfo shareInstance].tel = self.phoneTextField.text;
    
//    [self load];
}

- (void)load {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[[BimService instance] load:self.phoneTextField.text pwd:self.pwdTextField.text] onFulfilled:^id(id value) {
        // 保存数据
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
        HS_PERSISTENT_SET_OBJECT(data, USER_INFO);
        
        [UserInfo shareInstance].name = value[@"name"];
        [UserInfo shareInstance].tel = value[@"phone"];
        [UserInfo shareInstance].userID = value[@"_id"];
        
        //进入主界面
        MainHomeViewController *mainTVC = [[MainHomeViewController alloc] init];
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:mainTVC];
        HP_Delegate.window.rootViewController = navc;
        
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
