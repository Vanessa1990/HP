//
//  WriteInViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/7/30.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "WriteInViewController.h"
#import "ResultCell.h"
#import "MBProgressHUD.h"

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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    NSArray *array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"List.plist" ofType:nil]];
    [self.searchItems addObject:array[0]];
    [self.tableView reloadData];
    
}

#pragma mark - ResultCellDelegate
- (void)ResultCell:(UITableViewCell *)cell didPutaway:(NSDictionary *)glassDictionary
{
    //上传数据
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在入库";
    //成功之后退出
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hud.label.text = @"入库成功";
        [hud hideAnimated:YES afterDelay:0.5];
        //更新当前搜索数据
    });
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
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}

@end
