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
#import "NSDate+YZBim.h"

@interface SendOrderViewController ()<UITableViewDelegate,UITableViewDataSource,SendOrderCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextField *sendPLabel;
@property (weak, nonatomic) IBOutlet UITextField *billPLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property(nonatomic, strong) NSMutableDictionary *sendItems;
@property (assign, nonatomic) NSUInteger allcount;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation SendOrderViewController

- (instancetype)initWithModels:(NSArray *)models {
    if (self = [super init]) {
        NSMutableArray *array = [NSMutableArray array];
        for (ListModel *model in models) {
            model.sendCount = model.totalNumber;
            [array addObject:model];
        }
        self.models = [NSArray arrayWithArray:array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发货详情";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"SendOrderCell" bundle:nil] forCellReuseIdentifier:@"SendCellID"];
    ListModel *model = self.models[0];
    NSUInteger count = 0;
    for (ListModel *lm in self.models) {
        count += lm.sendCount?lm.sendCount:0;
    }
    self.allcount = count;
    self.nameLabel.text = model.name;
    self.dateLabel.text = [[NSDate dateFromISOString:model.date] formatOnlyDay];
    self.countLabel.text = [NSString stringWithFormat:@"%zd",count];
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(sure)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)sure {
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary: @{@"deliveryman":@[self.sendPLabel.text],@"billnumber":self.billPLabel.text}];
    NSMutableArray *ps = [NSMutableArray array];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在上传";
    hud.mode = MBProgressHUDModeIndeterminate;
    for (ListModel *model in self.models) {
        if (model.sendCount > 0) {
            if (!model.deliverymans || model.deliverymans.count == 0) {
                [sendDict setObject:@[[NSString stringWithFormat:@"%@:%zd",self.sendPLabel.text,model.sendCount]] forKey:@"deliveryman"];
            }else{
                NSMutableArray *ds = [NSMutableArray arrayWithArray:model.deliverymans];
                [ds addObject:[NSString stringWithFormat:@"%@:%zd",self.sendPLabel.text,model.sendCount]];
                [sendDict setObject:ds forKey:@"deliveryman"];
            }
            [ps addObject:[[BimService instance] updateGlassInfo:model.glassID newDict:sendDict]];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.models[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - SendOrderCellDelegate
- (void)sendOrderCellCountClick:(ListModel *)model count:(NSInteger)count {
    self.allcount -= model.sendCount;
    self.allcount += count;
    model.sendCount = count;
    [self.tableView reloadData];
    self.countLabel.text = [NSString stringWithFormat:@"%zd",self.allcount];
}




@end
