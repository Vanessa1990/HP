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

@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setModel:(ListModel *)model {
    _model = model;
    self.name.text = [NSString stringWithFormat:@"%@%@",model.name,model.mark];
    self.size.text = [NSString stringWithFormat:@"%@:%@ * %@",model.thick,model.height,model.width];
    self.totle.text = [NSString stringWithFormat:@"%zd",model.totalNumber];
    self.exsit.text = [NSString stringWithFormat:@"%zd",model.number];
    self.date.text = [[NSDate dateFromISOString:model.date] formatOnlyDay];
    NSMutableString *delivery = [NSMutableString string];
    for (NSString *d in model.deliverymans) {
        [delivery appendString:d];
    }
    self.send.text = delivery.length > 0?delivery:@"暂无";
}

@end
