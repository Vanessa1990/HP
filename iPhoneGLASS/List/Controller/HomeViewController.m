//
//  HomeViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/7/31.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionCell.h"
#import "SearchTVC.h"
#import "MoreTVC.h"
#import "NSDate+YZBim.h"
#import "BimService.h"
#import "UserListModel.h"
#import "ListNavView.h"
#import "ListCell.h"
#import "Utils.h"

@interface HomeViewController ()<SearchTVCDelegate,UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *allDates;

@property (nonatomic, strong) NSMutableDictionary *dateItems;

@property(nonatomic, strong) NSDate *currentDate;

@property(nonatomic, strong) ListNavView *navView;

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    self.allDates = [NSArray array];
    self.dateItems = [NSMutableDictionary dictionary];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //tableview设置
    //    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listcellID"];
    [self.tableView registerClass:[ListCell class] forCellReuseIdentifier:@"ListCellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    [[[BimService instance] getAllDate:[UserInfo shareInstance].userID] onFulfilled:^id(NSArray *value) {
        self.allDates = [NSArray arrayWithArray:value];
        // 取出最近的时间赋值给 currentDate
        self.currentDate = [NSDate dateWithTimeIntervalSinceNow:-secondsPerDay];
        [self getDateItems:self.currentDate];
        return self.allDates;
    }];
    
}

-(void)initNav {
    
    self.navigationItem.titleView = self.navView;
    self.navView.currenDateLabel.text = @"2017-12-18";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SHXPromise *)getDateItems:(NSDate *)date
{
    SHXPromise *promise = [SHXPromise new];
    if (![self.dateItems objectForKey:[date formatOnlyDay]]) {
        
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSDate *tomorrow = [date dateByAddingTimeInterval:secondsPerDay];
        NSString *todayString = [date formatOnlyDay];
        NSString *tomorrowString = [tomorrow formatOnlyDay];
        [[[BimService instance] getListAttach:nil searchDict:@{@"createdAt":@{@"$gte":todayString,@"$lt":tomorrowString}}] onFulfilled:^id(id value) {
            
            NSMutableArray *itemArray = [NSMutableArray array];
            for (NSDictionary *dict in value) {
                ListModel *model = [ListModel modelWithDict:dict];
                [itemArray addObject:model];
            }
            [self.dateItems setObject:[self dealItems:itemArray] forKey:todayString];
            [self.tableView reloadData];
            
            return value;
        } rejected:^id(NSError *reason) {
            return reason;
        }];
    }
    [promise resolve:self.dateItems];
    
    return promise;
    
}

- (NSDate *)dateFromString:(NSString *)dateString
{
    if (!dateString) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date= [formatter dateFromString:dateString];
    return date;
}


- (NSArray *)dealItems:(NSArray *)items
{
    NSMutableArray *res = [NSMutableArray array];
    NSArray *ids = [items valueForKey:@"name"];
    NSMutableArray *resIDs = [NSMutableArray array];
    for (NSString *ID in ids) {
        if (![resIDs containsObject:ID]) {
            [resIDs addObject:ID];
        }
    }
    
    for (NSString *name in resIDs) {
        UserListModel *model = [UserListModel new];
        model.name = name;
        NSUInteger totle = 0;
        NSMutableArray *lists = [NSMutableArray array];
        for (ListModel *m in items) {
            if ([m.name isEqualToString:name]) {
                totle += m.totalNumber;
                [lists addObject:m];
            }
        }
        model.totle = [NSString stringWithFormat:@"%zd",totle];
        model.listArray = lists;
        [res addObject:model];
    }
    return res;
}


#pragma mark - event
-(void)search {
    
    SearchTVC *searchTVC = [[UIStoryboard storyboardWithName:@"SearchTVC" bundle:nil] instantiateInitialViewController];
    searchTVC.delegate = self;
    [self.navigationController pushViewController:searchTVC animated:YES];
}

#pragma mark - SearchTVCDelegate
-(void)SearchTVC:(SearchTVC *)VC searchSuccess:(NSArray *)array {
    
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    UserListModel *model = [self currentDateItems][section];
    NSString *string = [NSString stringWithFormat:@"%@(共%@块)",model.name,model.totle];
    return string;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self currentDateItems].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    UserListModel *model = [self currentDateItems][section];
    return model.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserListModel *model = [self currentDateItems][indexPath.section];
    cell.listModel = model.listArray[indexPath.row];
    return cell;
}

- (NSArray *)currentDateItems {
    NSString *string = [self.currentDate formatOnlyDay];
    if (self.dateItems[string] && [self.dateItems[string] isKindOfClass:[NSArray class]]) {
        return self.dateItems[string];
    }
    return @[];
}

- (ListNavView *)navView {
    if (!_navView) {
        _navView = [[ListNavView alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    }
    return _navView;
}


@end
