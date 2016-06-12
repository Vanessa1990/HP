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

@interface WWLoadVC ()


@property (weak, nonatomic) IBOutlet UIButton *loadBtn;//登录按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadTrailing;
@property (weak, nonatomic) IBOutlet WWLoadTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet WWLoadTextField *pwdTextField;

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
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //1.设置文本和按钮的圆角
    self.loadBtn.layer.cornerRadius = 10;
    self.loadBtn.clipsToBounds = YES;
}

- (IBAction)loadClick:(id)sender {
    
    //登录
    
    //成功保存数据
    NSString *name = @"龙腾";
    NSString *pwd = self.pwdTextField.text;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:YES forKey:@"logged"];
    [user setValue:name forKey:@"name"];
    [user setValue:pwd forKey:@"pwd"];
    
    HP_Delegate.name = name;
    HP_Delegate.pwd = pwd;
    //进入主界面
    MainTabBarController *mainTVC = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    HP_Delegate.window.rootViewController = mainTVC;
}

@end
