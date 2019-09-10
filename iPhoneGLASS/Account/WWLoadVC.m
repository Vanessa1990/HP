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
    self.navigationController.navigationBar.hidden = YES;
    // 获取本地数据
//    NSData *data = HS_PERSISTENT_GET_OBJECT(USER_INFO);
//    if (data) {
//        NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        if (userDict && userDict[LOAD_DATE]) {
//            NSDate *loadDate = userDict[LOAD_DATE];
//            NSTimeInterval time = -[loadDate timeIntervalSinceDate:[NSDate date]];
//            if (time < 60 * 60 * 24 * 3) {
//                // 进去主页面
//                UserModel *model = [UserModel mj_objectWithKeyValues:userDict];
//                [[UserInfo shareInstance] setUserInfoWithModel:model];
//                [self pushInHomeVC];
//                return;
//            }
//        }
//    }
    
    self.navigationItem.title = @"登录";
    [self initViewSurface];
    [self initHead];
    // test
    self.phoneTextField.text = @"13852689266";
    self.pwdTextField.text = @"409724";
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)initHead {
    UIView *headView = [[UIView alloc] init];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.phoneTextField.mas_top).mas_equalTo(-20);
    }];
    [self createCircleColor:YZ_PinkColor endColor:YZ_Color(255, 240, 245, 1) radius:50 center:CGPointMake(0, 150) parentView:headView];
    [self createCircleColor:YZ_Color(255, 182, 193, 1) endColor:YZ_Color(171, 130, 255, 1) radius:25 center:CGPointMake(kScreenWidth*0.3, 70) parentView:headView];
    [self createCircleColor:YZ_Color(255, 20, 147, 1) endColor:YZ_Color(238, 130, 238, 1) radius:20 center:CGPointMake(kScreenWidth*0.7, 150) parentView:headView];
    [self createCircleColor:YZ_Color(245, 222, 179, 1) endColor:YZ_Color(255, 165, 0, 1) radius:35 center:CGPointMake(kScreenWidth, 200) parentView:headView];
}

- (void)createCircleColor:(UIColor *)color endColor:(UIColor *)endColor radius:(CGFloat)radius center:(CGPoint)center parentView:(UIView *)parentView{
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius*2,  radius*2)];
    [parentView addSubview:circleView];
    
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = circleView.bounds;
    gradientLayer.colors = @[(__bridge id)color.CGColor,(__bridge id)endColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0,@1];
    [circleView.layer addSublayer:gradientLayer];
    
    CAShapeLayer *mask = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:circleView.bounds cornerRadius:radius];
    mask.path = path.CGPath;
    circleView.layer.mask = mask;
   
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(parentView.mas_left).mas_offset(center.x);
        make.centerY.mas_equalTo(parentView.mas_top).mas_offset(center.y);
        make.width.height.mas_equalTo(radius*2);
    }];
    
}

- (void)initViewSurface {
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置文本和按钮的圆角
    self.loadBtn.layer.cornerRadius = 22;
    self.loadBtn.clipsToBounds = YES;
    self.loadBtn.backgroundColor = YZ_ThemeColor;
    NSString *title = @"登  录";
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:title];
    [attriString addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:22]
                        range:NSMakeRange(0, title.length)];
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:YZ_WhiteColor
                        range:NSMakeRange(0, title.length)];
    [self.loadBtn setAttributedTitle:attriString forState:UIControlStateNormal];

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
        [self pushInHomeVC];
        
        return value;
    }rejected:^id(NSError *reason) {
        _hud.label.text = @"登录失败";
        [_hud hideAnimated:YES afterDelay:0.5];
        return reason;
    }];
}

- (void)pushInHomeVC {
    
    //        MainTabBarController *mainVC = [[MainTabBarController alloc] init];
    //        HP_Delegate.window.rootViewController = mainVC;
    MainHomeViewController *homeVC = [[MainHomeViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:homeVC];
    HP_Delegate.window.rootViewController = navc;
}


- (IBAction)registClick:(id)sender {
    
    RegistViewController *VC = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
