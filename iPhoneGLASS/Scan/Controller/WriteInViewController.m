//
//  WriteInViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/7/30.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "WriteInViewController.h"
#import "HomeViewController.h"
#import "ResultCell.h"
#import "MBProgressHUD.h"
#import "BimService.h"
#import "ListModel.h"

@interface WriteInViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, ResultCellDelegate>

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *searchItems;

@end

@implementation WriteInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 44)];
    [self.view addSubview:self.searchBar];
    self.searchBar.placeholder = @"请输入姓名+长+宽+数量";
    self.searchBar.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, kScreenWidth, kScreenHeight - 108 - 49)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellReuseIdentifier:@"ResultCellID"];
    
    self.searchItems = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看订单" style:UIBarButtonItemStylePlain target:self action:@selector(seeMore:)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    NSArray *allValue = [searchBar.text componentsSeparatedByString:@"+"];
    // 暂不考虑姓名
    NSDictionary *searchDict = @{@"length":allValue[0],@"width":allValue[1]};
    [[[BimService instance] getListAttach:nil searchDict:searchDict] onFulfilled:^id(id value) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in value) {
            ListModel *model = [ListModel modelWithDict:dict];
            [array addObject:model];
        }
        self.searchItems = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
        
        return value;
    } rejected:^id(NSError *reason) {
        return reason;
    }];
    
}

- (void)seeMore:(id)sender {
    HomeViewController *vc = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ResultCellDelegate
- (void)ResultCell:(UITableViewCell *)cell didPutaway:(ListModel *)model
{
    //上传数据
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在入库";
    //成功之后退出
    NSUInteger newStockin = model.number?model.number:0;
    if (newStockin < model.totalNumber) {
        newStockin+=1;
        [[[BimService instance] updateGlassInfo:model.glassID newDict:@{@"stockIn":@(newStockin)}] onFulfilled:^id(id value) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:value options:kNilOptions error:nil];
            if (dict) {
                hud.label.text = @"入库成功";
                [hud hideAnimated:YES afterDelay:0.5];
                // 修改当前数据
                ListModel *newmodel = [ListModel modelWithDict:dict];
                [self reloadData:newmodel old:model];
            }else{
                hud.label.text = @"入库失败,请稍后重试";
                [hud hideAnimated:YES afterDelay:0.5];
            }
            
            return value;
        }];
    }else{
        hud.label.text = @"已全!!!不可重复入库!!!";
        [hud hideAnimated:YES afterDelay:0.5];
    }
}

- (void)reloadData:(ListModel *)newModel old:(ListModel *)oldModel{
    for (ListModel *model in self.searchItems) {
        if ([oldModel isEqual:model]) {
            NSInteger index = [self.searchItems indexOfObject:oldModel];
            [self.searchItems removeObject:oldModel];
            [self.searchItems insertObject:newModel atIndex:index];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.model = self.searchItems[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}

@end
