//
//  ListTVC.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/17.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "ListTVC.h"
#import "PrefixHeader.pch"
#import "AppDelegate.h"
#import "WWLoadVC.h"
#import "ListHeadView.h"
#import "ListTableViewCell.h"
#import "NSDictionary+PropertyCode.h"
#import "ListModel.h"
#import "SearchTVC.h"
#import "ScanViewController.h"
#import "MJRefresh.h"


@interface ListTVC ()<SearchTVCDelegate>

@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation ListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    //列表数据初始化
    NSArray *array = [NSArray array];
    self.itemArray = [NSMutableArray array];
    array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"List.plist" ofType:nil]];
    for (NSDictionary *dict in array) {
        ListModel *model = [ListModel modelWithDict:dict];
        [self.itemArray addObject:model];
    }
    //tableview设置
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listcellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    [self.tableView.mj_header beginRefreshing];
   
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    if (self.firstIn) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNav {
    
    self.title = @"列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
//    if ([HP_Delegate.name isEqualToString:@"和平钢化"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"scan.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
//    }
}

-(void)beginRefresh {
    
    self.firstIn = NO;
    //列表数据初始化
    NSArray *array = [NSArray array];
    self.itemArray = [NSMutableArray array];
    array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"List.plist" ofType:nil]];
    [self.itemArray removeAllObjects];
    for (NSDictionary *dict in array) {
        ListModel *model = [ListModel modelWithDict:dict];
        [self.itemArray addObject:model];
    }

    //列表数据初始化
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    });
    
}

#pragma mark - event

-(void)search {
    
    SearchTVC *searchTVC = [[UIStoryboard storyboardWithName:@"SearchTVC" bundle:nil] instantiateInitialViewController];
    searchTVC.delegate = self;
    [self.navigationController pushViewController:searchTVC animated:YES];
}

-(void)scan {
    
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
}

#pragma mark - SearchTVCDelegate

-(void)SearchTVC:(SearchTVC *)VC searchSuccess:(NSArray *)array {
    
    self.itemArray = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ListHeadView *view = [ListHeadView headView];
    view.frame = CGRectMake(0, 0, 100, 35);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listcellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.listModel = self.itemArray[indexPath.row];
    
    return cell;
}

@end
