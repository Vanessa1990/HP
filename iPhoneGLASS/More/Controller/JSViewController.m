//
//  JSViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/10/15.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "JSViewController.h"

@interface JSViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *hcTextField;

@property(nonatomic, strong) UITextField *gTextField;

@property(nonatomic, strong) UITextField *xcTextField;

@property(nonatomic, strong) UILabel *rLable;

@property(nonatomic, strong) UILabel *duLable;

@end

@implementation JSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"计算半径";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat y = 30 + 64;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"jsBG.png"];
    imageView.frame = CGRectMake((kScreenWidth - 300) / 2, 30 + 64, 300, 300);
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    self.hcTextField = [self getTextFieldWithX:40 y:20];
    self.hcTextField.delegate = self;
    [imageView addSubview:self.hcTextField];
    self.gTextField = [self getTextFieldWithX:194 y:64];
    [imageView addSubview:self.gTextField];
    self.xcTextField = [self getTextFieldWithX:111 y:161];
    self.xcTextField.delegate = self;
    [imageView addSubview:self.xcTextField];
    
    y += 300 + 15;
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 300) / 2, y, 300, kScreenHeight - y)];
    [self.view addSubview:resultView];
    
    y = 0;
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 100, 44)];
    tip.font = [UIFont boldSystemFontOfSize:19];
    tip.text = @"更多结果 :";
    [resultView addSubview:tip];
    y += 44;
    self.rLable = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 300, 44)];
    [resultView addSubview:self.rLable];
    y += 44;
    self.duLable = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 300, 44)];
    [resultView addSubview:self.duLable];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"计算" style:UIBarButtonItemStyleDone target:self action:@selector(jsClick:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextField *)getTextFieldWithX:(CGFloat)x y:(CGFloat)y {
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(x, y, 100, 30)];
    text.font = [UIFont systemFontOfSize:17];
    text.keyboardType = UIKeyboardTypeNumberPad;
    return text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)jsClick:(id)sender {
    [self.view endEditing:YES];
    double x = [self.xcTextField.text doubleValue];//弦长
    double h = [self.gTextField.text doubleValue];//高度
    double l = [self.hcTextField.text doubleValue];//弧长
    
    if ( x && x > 0){
        
        //根据弦长得半径
        double r = (h / 2) + ((x * x) / (8 * h));
        double jd = asin(x /(2 * r));
        double T = 2 * asin(1.00);
        double _jd = jd * 360 / 2 / T;
        double hu = 2 * jd * r;
        
        self.rLable.text = [NSString stringWithFormat:@"半径 :  %.3f  cm",r];
        self.duLable.text = [NSString stringWithFormat:@"角度 :  %.3f  cm",_jd * 2];
        self.hcTextField.text = [NSString stringWithFormat:@"%.3f",hu];
        
    }else {
        
        //根据弧长的半径
        double T = 2 * asin(1.00);
        double left = h;
        double right = l;
        double middle = (right + left)/2;
        double result1, result2, resultMiddle;
        double _jd = 0;
        double r = 0;
        
        r = (h / 2) + ((l * l) / (8 * h));
        double jd = asin(l /(2 * r));
        _jd = jd * 360 / 2 / T;
        result1 = [self huResult:left];
        result2 = [self huResult:right];
        
        while (fabs(result1 - l)>=0.001 || fabs(result2 - l)>=0.001) {
            
            resultMiddle = [self huResult:middle];
            if (resultMiddle < l) {
                left = middle;
                result1 = resultMiddle;
            } else {
                right = middle;
                result2 = resultMiddle;
            }
            middle = (right + left)/2;
        }
        
        //根据弦长得半径
        r = (h / 2) + ((middle * middle) / (8 * h));
        jd = asin(middle /(2 * r));
        _jd = jd * 360 / 2 / T;
        
        self.rLable.text = [NSString stringWithFormat:@"半径 :  %.3f  cm",r];
        self.duLable.text = [NSString stringWithFormat:@"角度 :  %.3f  cm",_jd * 2];
        self.xcTextField.text = [NSString stringWithFormat:@"%.3f",middle];
    }
}

//计算弧长
-(double)huResult:(double)x {
    double h = [self.gTextField.text doubleValue];//高度
    //根据弦长得半径
    double r = (h / 2) + ((x * x) / (8 * h));
    double jd = asin(x /(2 * r));
    double hu = 2 * jd * r;
    return hu;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.hcTextField.text = @"";
    self.xcTextField.text = @"";
}

@end
