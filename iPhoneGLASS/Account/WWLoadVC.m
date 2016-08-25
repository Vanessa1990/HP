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
#import "ListTVC.h"
#import "MJRefresh.h"
#import "MainTabBarController.h"
#import "AFNetworking.h"
#import "HPNetworkingTool.h"
#import "MBProgressHUD.h"

@interface WWLoadVC ()


@property (weak, nonatomic) IBOutlet UIButton *loadBtn;//登录按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadTrailing;
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
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdict = [user objectForKey:@"user"];
    if ([userdict objectForKey:@"name"]) {
        //进入主界面
        MainTabBarController *mainTVC = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
        HP_Delegate.window.rootViewController = mainTVC;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //1.设置文本和按钮的圆角
    self.loadBtn.layer.cornerRadius = 10;
    self.loadBtn.clipsToBounds = YES;
}

- (IBAction)loadClick:(id)sender {
    
    NSDictionary *dict = @{
                           @"phoneNumber":self.phoneTextField.text,
                           @"password":self.pwdTextField.text
                           };
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    [[HPNetworkingTool shareNetworkingTool] getlogin:@"glassApp/login" parameters:dict finish:^(NSDictionary *dict) {
//        if ([[dict objectForKey:@"status" ] isEqualToString:@"OK"]) {
//            //成功保存数据
//            NSDictionary *data = [dict objectForKey:@"data"];
//            NSString *name = [data objectForKey:@"name"];
//            NSString *pwd = [data objectForKey:@"pwd"];
//            
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//            [user setValue:data forKey:@"user"];
//            
//            HP_Delegate.name = name;
//            HP_Delegate.pwd = pwd;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _hud.labelText = @"登陆成功";
                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                //进入主界面
                MainTabBarController *mainTVC = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
                HP_Delegate.window.rootViewController = mainTVC;
//            });
//        }
//    } failure:^{
//        _hud.labelText = @"账号或密码错误!请重新输入!!!";
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        });
//    }];
//    
   
    
 
}

@end
