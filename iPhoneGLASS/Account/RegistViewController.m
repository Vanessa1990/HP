//
//  RegistViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/7/31.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "RegistViewController.h"
#import "BimService.h"
#import "MBProgressHUD.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
// 管理员
@property (weak, nonatomic) IBOutlet UIButton *adminY;
@property (weak, nonatomic) IBOutlet UIButton *adminN;
// 计算权限
@property (weak, nonatomic) IBOutlet UIButton *jsY;
@property (weak, nonatomic) IBOutlet UIButton *jsN;


@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.registButton setBackgroundColor:YZ_ThemeColor];
    self.registButton.clipsToBounds = YES;
    self.registButton.layer.cornerRadius = 6;
    
    self.navigationItem.title = @"添加新用户";
    self.pwd.text = @"123456";
    
    if (self.user) {
        self.name.text = self.user.name;
        self.phone.text = self.user.phone;
        self.pwd.text = self.user.password;
        self.adminY.selected = self.user.admin;
        self.adminN.selected = !self.user.admin;
        self.jsY.selected = self.user.JSPermission;
        self.jsN.selected = !self.user.JSPermission;
        [self.registButton setTitle:@"修改" forState:UIControlStateNormal];
        self.navigationItem.title = @"修改用户信息";
    }
    [self setBackItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)adminYesClick:(UIButton *)sender {
    NSUInteger index = sender.tag / 100;
    if (index == 1 || index == 2) {
        self.adminY.selected = index == 1;
        self.adminN.selected = index == 2;
    }else {
        self.jsY.selected = index == 3;
        self.jsN.selected = index == 4;
    }
}

- (void)regist {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在注册...";
    // 先验证是否有重复的号码存储
    [[[BimService instance] registNewUser:self.name.text phone:self.phone.text pwd:self.pwd.text admin:self.adminY.selected jsPermission:self.jsY.selected] onFulfilled:^id(id value) {
        if (value) {
            hud.label.text = @"注册成功";
            hud.mode = MBProgressHUDModeText;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:0];
                [self.navigationController popViewControllerAnimated:YES];
                if ([(id)self.delegate respondsToSelector:@selector(registSuccess)]) {
                    [self.delegate registSuccess];
                }
            });
        }else{
            hud.label.text = @"此号码已经注册过!";
            hud.mode = MBProgressHUDModeText;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:0];
            });
        }
        return value;
    }rejected:^id(NSError *reason) {
        hud.label.text = @"注册失败";
        hud.mode = MBProgressHUDModeText;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:0];
        });
        return reason;
    }];
}

- (void)reset {
    NSDictionary *dict = @{@"name":self.name.text,
                           @"phone":self.phone.text,
                           @"password":self.pwd.text,
                           @"admin":@(self.adminY.selected),
                           @"JSPermission":@(self.jsY.selected)
                           };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在修改...";
    [[[BimService instance] updateUser:self.user.userID newDict:dict] onFulfilled:^id(id value) {
        [self.navigationController popViewControllerAnimated:YES];
        if ([(id)self.delegate respondsToSelector:@selector(registSuccess)]) {
            [self.delegate registSuccess];
        }
        return value;
    } rejected:^id(NSError *reason) {
        hud.label.text = @"修改失败✘";
        [hud hideAnimated:YES afterDelay:0.6];
        return reason;
    }];
}

- (IBAction)registClick:(id)sender {
    
    if (self.user){
        [self reset];
    }else{
        [self regist];
    }
}

@end
