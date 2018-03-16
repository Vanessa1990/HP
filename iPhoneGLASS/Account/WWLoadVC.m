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
    
    // 获取本地数据
    NSData *data = HS_PERSISTENT_GET_OBJECT(USER_INFO);
    if (data) {
        NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (userDict && userDict[LOAD_DATE]) {
            NSDate *loadDate = userDict[LOAD_DATE];
            NSTimeInterval time = -[loadDate timeIntervalSinceDate:[NSDate date]];
            if (time < 60 * 60 * 24 * 3) {
                // 进去主页面
                UserModel *model = [UserModel mj_objectWithKeyValues:userDict];
                [[UserInfo shareInstance] setUserInfoWithModel:model];
                MainTabBarController *mainVC = [[MainTabBarController alloc] init];
                HP_Delegate.window.rootViewController = mainVC;
                return;
            }
        }
    }
    
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置文本和按钮的圆角
    self.loadBtn.layer.cornerRadius = 10;
    self.loadBtn.clipsToBounds = YES;

//    // test
//    self.phoneTextField.text = @"13852689266";
//    self.pwdTextField.text = @"888888";
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}


- (IBAction)loadClick:(id)sender {
    [self load];
}

- (void)load {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.phoneTextField.text.length == 0 || self.pwdTextField.text.length == 0) {
        return;
    }
    [[[BimService instance] load:self.phoneTextField.text pwd:self.pwdTextField.text] onFulfilled:^id(id value) {
       
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:value];
        UserModel *model = [UserModel mj_objectWithKeyValues:dict];
        [[UserInfo shareInstance] setUserInfoWithModel:model];
        
         // 保存数据
        [dict setValue:[NSDate date] forKey:LOAD_DATE];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        HS_PERSISTENT_SET_OBJECT(data, USER_INFO);
        
        //进入主界面
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
