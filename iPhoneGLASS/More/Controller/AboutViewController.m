//
//  AboutViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/7/28.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "AboutViewController.h"
#import "PrefixHeader.pch"

@interface AboutViewController ()

@property(nonatomic,strong) UIScrollView *scrollView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = @"关于我们";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, HP_Screen_Width, HP_Screen_Height - 64)];
    [self.view addSubview:_scrollView];
    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, HP_Screen_Height - 64 - 100, HP_Screen_Width, 100)];
//    imageView.image = [UIImage imageNamed:@"buttomBG.jpg"];
//    [_scrollView addSubview:imageView];
    
    UILabel *contentLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, HP_Screen_Width, 100)];
    contentLable.numberOfLines = 0;
    NSString *contentString = @"        泰州市和平钢化玻璃有限公司成立于2011年7月，生产设备齐全，销量领先。坐落在江苏省泰州市兴化经济开发区纬三路23号。";
    contentLable.text =contentString;
    contentLable.font = [UIFont systemFontOfSize:17];
    [contentLable sizeToFit];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:17]};
    CGSize stringSize = [contentString boundingRectWithSize:CGSizeMake(HP_Screen_Width - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    contentLable.frame = CGRectMake(20, 30, stringSize.width, stringSize.height + 2);
    [_scrollView addSubview:contentLable];
    
    UILabel *contentLable2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, HP_Screen_Width, 100)];
    contentLable2.numberOfLines = 0;
    NSString *contentString2 = @"        我公司专业生产5-15mm钢化玻璃、中空玻璃夹胶玻璃、喷砂玻璃、沐浴房玻璃及型材批发业务。";
    contentLable2.text =contentString2;
    contentLable2.font = [UIFont systemFontOfSize:17];
    [contentLable2 sizeToFit];
    CGSize stringSize2 = [contentString2 boundingRectWithSize:CGSizeMake(HP_Screen_Width - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    contentLable2.frame = CGRectMake(20, CGRectGetMaxY(contentLable.frame) + 20, stringSize2.width, stringSize2.height + 2);
    [_scrollView addSubview:contentLable2];
    
    UILabel *contentLable3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, HP_Screen_Width, 100)];
    contentLable3.numberOfLines = 0;
    NSString *contentString3 = @"        我们秉承“质量保证 信誉第一 顾客至上 服位”的信念。欢迎新老客户前来洽谈！";
    contentLable3.text =contentString3;
    contentLable3.font = [UIFont systemFontOfSize:17];
    [contentLable3 sizeToFit];
    CGSize stringSize3 = [contentString3 boundingRectWithSize:CGSizeMake(HP_Screen_Width - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    contentLable3.frame = CGRectMake(20, CGRectGetMaxY(contentLable2.frame) + 20, stringSize3.width, stringSize3.height + 2);
    [_scrollView addSubview:contentLable3];
    
    
    UILabel *callLable = [[UILabel alloc]init];
    callLable.text = @"联系我们:";
    callLable.font = [UIFont boldSystemFontOfSize:17];
    [callLable sizeToFit];
    CGRect frame = callLable.frame;
    frame.origin.x = 20;
    frame.origin.y = CGRectGetMaxY(contentLable3.frame) + 50;
    callLable.frame = frame;
    [_scrollView addSubview:callLable];
    
    UIButton *phoneButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [phoneButton1 setTitle:@"0523-83105908" forState:UIControlStateNormal];
    phoneButton1.titleLabel.font = [UIFont systemFontOfSize:20];
    [phoneButton1 sizeToFit];
    phoneButton1.frame = CGRectMake(20 + frame.size.width + 10, CGRectGetMaxY(callLable.frame) + 15, phoneButton1.frame.size.width, frame.size.height);
    [phoneButton1 addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:phoneButton1];
    
    UIButton *phoneButton2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [phoneButton2 setTitle:@"0523-83105906" forState:UIControlStateNormal];
    phoneButton2.titleLabel.font = [UIFont systemFontOfSize:20];
    [phoneButton2 sizeToFit];
    phoneButton2.frame = CGRectMake(20 + frame.size.width + 10, CGRectGetMaxY(phoneButton1.frame) + 10, phoneButton2.frame.size.width, frame.size.height);
    [phoneButton2 addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:phoneButton2];
   
    UILabel *lable = [[UILabel alloc]init];
    lable.text = @"@泰州市和平钢化玻璃有限公司";
    lable.font = [UIFont systemFontOfSize:15];
//    lable.textColor = [UIColor whiteColor];
    [lable sizeToFit];
    lable.center = CGPointMake(HP_Screen_Width * 0.5, _scrollView.bounds.size.height - 35);
    [_scrollView addSubview:lable];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)call:(UIButton *)button {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",button.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
