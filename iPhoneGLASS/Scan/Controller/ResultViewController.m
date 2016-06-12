//
//  ResultViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/6/1.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultCell.h"
#import "MBProgressHUD.h"

@interface ResultViewController ()<ResultCellDelegate>

@property(nonatomic,strong) NSString *code;
@property(nonatomic,strong) NSArray *cellItems;

@end

@implementation ResultViewController

-(instancetype)initWithCode:(NSString *)code {
    
    if (self = [super init]) {
        self.code = code;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellReuseIdentifier:@"ResultCellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //查询数据
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;//self.cellItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
}

-(void)ResultCell:(UITableViewCell *)cell didPutaway:(NSDictionary *)glassDictionary {
    
    //上传数据
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在入库";
    //成功之后退出
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hud.label.text = @"入库成功";
        [hud hideAnimated:YES afterDelay:0.5];
        [self.navigationController popViewControllerAnimated:YES];
    });
//    hud.label.text = @"入库失败";
//    [hud hideAnimated:YES afterDelay:0.5];
}


@end
