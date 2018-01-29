//
//  JSViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/10/15.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "JSViewController.h"

typedef enum : NSUInteger {
    TextFieldTypeHeight = 1000,
    TextFieldTypeHu,
    TextFieldTypeXuan,
} TextFieldType;

@interface JSViewController ()<UITextFieldDelegate, UIScrollViewDelegate>

@property(nonatomic, strong) UITextField *hcTextField;

@property(nonatomic, strong) UITextField *gTextField;

@property(nonatomic, strong) UITextField *xcTextField;

@property(nonatomic, strong) UILabel *rLable;

@property(nonatomic, strong) UILabel *duLable;

@property (assign, nonatomic) BOOL jsWithH;

@end

@implementation JSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self initNav];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNav {
    self.title = @"计算半径";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清零" style:UIBarButtonItemStyleDone target:self action:@selector(clearClick:)];
    [self setShowTabItem];
}

- (void)initView {
    UIScrollView *mainView = [[UIScrollView alloc] init];
    mainView.delegate = self;
    [self.view addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"jsBG.png"];
    imageView.userInteractionEnabled = YES;
    [mainView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(300);
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(self.view).offset((kScreenWidth - 300) / 2);
        make.right.mas_equalTo(self.view).offset(-(kScreenWidth - 300) / 2);
        make.left.mas_equalTo(mainView).offset((kScreenWidth - 300) / 2);
        make.right.mas_equalTo(mainView).offset(-(kScreenWidth - 300) / 2);
    }];
    
    self.hcTextField = [self getTextFieldWithX:40 y:20];
    self.hcTextField.delegate = self;
    self.hcTextField.tag = TextFieldTypeHu;
    [imageView addSubview:self.hcTextField];
    self.gTextField = [self getTextFieldWithX:194 y:64];
    self.gTextField.delegate = self;
    self.gTextField.tag = TextFieldTypeHeight;
    [imageView addSubview:self.gTextField];
    self.xcTextField = [self getTextFieldWithX:111 y:161];
    self.xcTextField.delegate = self;
    self.xcTextField.tag = TextFieldTypeXuan;
    [imageView addSubview:self.xcTextField];
    
    UIView *resultView = [[UIView alloc] init];
    [mainView addSubview:resultView];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.font = [UIFont boldSystemFontOfSize:19];
    tip.text = @"更多结果 :";
    [resultView addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
   
    self.rLable = [[UILabel alloc] init];
    [resultView addSubview:self.rLable];
    [self.rLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(tip.mas_bottom).offset(20);
    }];
   
    self.duLable = [[UILabel alloc] init];
    [resultView addSubview:self.duLable];
    [self.duLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.rLable.mas_bottom).offset(20);
    }];
    
    [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(imageView);
        make.top.mas_equalTo(imageView.mas_bottom).offset(15);
        make.height.mas_equalTo(kScreenHeight - 364);
        make.bottom.mas_equalTo(0);
    }];

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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)jsClick:(UITextField *)sender {
    double x = [self.xcTextField.text doubleValue];//弦长
    double h = [self.gTextField.text doubleValue];//高度
    double l = [self.hcTextField.text doubleValue];//弧长
    
    if (x < h && !self.jsWithH) return;
    if (l < h && self.jsWithH) return;
    
    if (!self.jsWithH){
        
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

- (void)clearClick:(id)sender {
    self.hcTextField.text = @"";
    self.xcTextField.text = @"";
    self.gTextField.text = @"";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (textField.tag == TextFieldTypeHu) {
            self.jsWithH = YES;
        }else if (textField.tag == TextFieldTypeXuan) {
            self.jsWithH = NO;
        }
        [self jsClick:nil];
    });
    return YES;
}


@end
