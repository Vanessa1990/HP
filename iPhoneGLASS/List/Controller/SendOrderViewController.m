//
//  SendOrderViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/25.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "SendOrderViewController.h"
#import "SendOrderCell.h"
#import "BimService.h"
#import "MBProgressHUD.h"

@interface SendOrderViewController ()<UITableViewDelegate,UITableViewDataSource,SendOrderCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextField *sendPLabel;
@property (weak, nonatomic) IBOutlet UITextField *billPLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableDictionary *sendItems;
@property (assign, nonatomic) NSUInteger allcount;

@end

@implementation SendOrderViewController

- (instancetype)initWithModels:(NSArray *)models {
    if (self = [super init]) {
        self.models = models;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.sendItems = [NSMutableDictionary dictionary];
    [self.tableView registerNib:[UINib nibWithNibName:@"SendOrderCell" bundle:nil] forCellReuseIdentifier:@"SendCellID"];
    ListModel *model = self.models[0];
    NSUInteger count = 0;
    for (ListModel *lm in self.models) {
        count += lm.number?lm.number:0;
        [self.sendItems setValue:@(lm.number) forKey:lm.glassID];
    }
    self.allcount = count;
    self.nameLabel.text = model.name;
    self.countLabel.text = [NSString stringWithFormat:@"%zd",count];
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(sure)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sure {
    NSDictionary *sendDict = @{@"deliveryman":@[self.sendPLabel.text],@"billnumber":self.billPLabel.text};
    NSMutableArray *ps = [NSMutableArray array];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在上传";
    hud.mode = MBProgressHUDModeIndeterminate;
    for (NSString *key in self.sendItems) {
        NSInteger count = [self.sendItems[key] integerValue];
        if (count > 0) {
            [ps addObject:[[BimService instance] updateGlassInfo:key newDict:sendDict]];
        }
    }
    [[SHXPromise all:ps] onFulfilled:^id(id value) {
        hud.label.text = @"上传成功";
        [hud hideAnimated:YES afterDelay:0.5];
        [self.navigationController popViewControllerAnimated:YES];
        return value;
    } rejected:^id(NSError *reason) {
        hud.label.text = @"上传失败,请查看当前网络,稍后尝试!";
        [hud hideAnimated:YES afterDelay:0.5];
        return reason;
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SendOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendCellID"];
    cell.model = self.models[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - SendOrderCellDelegate
- (void)sendOrderCellCountClick:(ListModel *)model count:(NSInteger)count {
    NSNumber *oldCount = [self.sendItems valueForKey:model.glassID];
    NSUInteger oldC = [oldCount integerValue];
    self.allcount -= oldC;
    self.allcount += count;
    self.sendItems[model.glassID] = @(count);
    self.countLabel.text = [NSString stringWithFormat:@"%zd",self.allcount];
}




@end
