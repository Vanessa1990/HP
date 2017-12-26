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

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.registButton setBackgroundColor:YZ_ThemeColor];
    self.registButton.clipsToBounds = YES;
    self.registButton.layer.cornerRadius = 6;
    
    self.navigationItem.title = @"注册";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registClick:(id)sender {
    
    NSString *phone = self.phone.text;
    NSString *name = self.name.text;
    NSString *pwd = self.pwd.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在注册...";
    // 先验证是否有重复的号码存储
    [[[BimService instance] registNewUser:name phone:phone pwd:pwd] onFulfilled:^id(id value) {
        if (value) {
            hud.label.text = @"注册成功";
            hud.mode = MBProgressHUDModeText;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:0];
                [self.navigationController popViewControllerAnimated:YES];
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

@end
