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
#import "YTKKeyValueStore.h"
#import "ListHeadModel.h"

@interface ListTVC ()<SearchTVCDelegate>

@property (nonatomic, strong) NSMutableArray <ListHeadModel *>*itemArray;
@property(nonatomic,assign) int pullNum;

@end

@implementation ListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];

    //tableview设置
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listcellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pullNum = 0;
        [self beginRefresh];
    }];
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    self.itemArray = [NSMutableArray array];
    

    MJRefreshAutoNormalFooter *footer= [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self beginRefresh];
    }];
    [footer setTitle:@"点击或者上拉加载更多" forState:MJRefreshStateIdle];
    self.tableView.mj_footer = footer;
   
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
//    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNav {
    
    self.title = @"列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iconButton.frame = CGRectMake(0, 0, 30, 30);
    iconButton.imageView.layer.cornerRadius = 15;
    iconButton.imageView.clipsToBounds = YES;
    [iconButton setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:iconButton];
}

-(void)beginRefresh {

    self.pullNum ++;
    self.firstIn = NO;

    NSArray *array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"List.plist" ofType:nil]];
    if (self.pullNum == 1) {
        [self.itemArray removeAllObjects];
    }
    for (NSDictionary *dict in array) {
        ListHeadModel *model = [[ListHeadModel alloc] init];
        model.name = dict[@"name"];
        model.date = dict[@"date"];
        model.totle = dict[@"totle"];
        NSMutableArray *lists = [NSMutableArray array];
        for (NSDictionary *childModel in dict[@"data"]) {
            NSLog(@"%@",childModel);
            ListModel *m = [ListModel modelWithDict:childModel];
            [lists addObject:m];
        }
        model.listArray = [NSArray arrayWithArray:lists];
        [self.itemArray addObject:model];
    }

    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];

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
    view.nameLable.text = self.itemArray[section].name;
    view.totleLable.text = self.itemArray[section].totle;
    view.dateLable.text = self.itemArray[section].date;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.itemArray[section].listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listcellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.itemArray[indexPath.section].listArray.count) {
        cell.listModel = self.itemArray[indexPath.section].listArray[indexPath.row];
    }
    return cell;
}

@end
