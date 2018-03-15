//
//  OrderInfoViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/30.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "NSDate+YZBim.h"

@interface OrderInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UILabel *totle;
@property (weak, nonatomic) IBOutlet UILabel *exsit;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *send;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;

@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = YZ_Color(155, 155, 155, 0.5);
    self.bgView.layer.cornerRadius = 6;
    self.bgView.clipsToBounds = YES;
    
    self.name.text = [NSString stringWithFormat:@"%@%@",self.model.name,self.model.mark?self.model.mark:@""];
    self.size.text = [NSString stringWithFormat:@"%@ : %@ * %@",self.model.thick,self.model.height,self.model.width];
    self.totle.text = [NSString stringWithFormat:@"总数 : %zd",self.model.totalNumber];
    self.exsit.text = [NSString stringWithFormat:@"产出 : %zd",self.model.number];
    self.date.text = [NSString stringWithFormat:@"日期 : %@",[[NSDate dateFromISOString:self.model.date] formatOnlyDay]];
    NSString *delivery = [self.model.deliverymans componentsJoinedByString:@","];
    self.send.text = [NSString stringWithFormat:@"配送 : %@",delivery.length > 0?delivery:@"暂无"];
    self.orderNumber.text = [NSString stringWithFormat:@"订单号 : %@",self.model.billnumber];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
