//
//  HomeViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/7/31.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "HomeViewController.h"
#import "ListHeadView.h"


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource,ListNavViewDelegate>

@property (nonatomic, strong) NSArray *allDates;

@property (nonatomic, strong) NSMutableDictionary *dateItems;

@property(nonatomic, strong) NSDate *currentDate;

@property(nonatomic, strong) ListNavView *navView;



@end

static NSUInteger const secondsPerDay = 24 * 60 * 60;

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self initNav];
    self.allDates = [NSArray array];
    self.dateItems = [NSMutableDictionary dictionary];
    [self initView];
    [self getTableViewData];
}

- (void)initView {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //tableview设置
    [self.tableView registerClass:[ListCell class] forCellReuseIdentifier:@"ListCellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initNav {
    self.navigationItem.titleView = self.navView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
}

- (void)getTableViewData {
    if ([UserInfo shareInstance].isAdmin) {
        self.currentDate = [NSDate date];
        self.navView.currenDateLabel.text = [self.currentDate formatOnlyDay];
        [[self getDateItems:self.currentDate] onFulfilled:^id(id value) {
            [self reloadDataAndUI];
            return value;
        }];
    }else{
        [[[BimService instance] getAllDate:[UserInfo shareInstance].userID] onFulfilled:^id(NSArray *value) {
            self.allDates = [NSArray arrayWithArray:value];
            // 取出最近的时间赋值给 currentDate
            self.currentDate = [NSDate date];
            self.navView.currenDateLabel.text = [self.currentDate formatOnlyDay];
            [[self getDateItems:self.currentDate] onFulfilled:^id(id value) {
                [self reloadDataAndUI];
                return value;
            }];
            return self.allDates;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 取出所有的分组
- (NSArray *)getAllSections:(NSArray *)items {
    NSMutableArray *resIDs = [NSMutableArray array];
    // 取出组
    for (ListModel *m in items) {
        NSMutableString *section = [NSMutableString stringWithFormat:@"%@",m.name];
        if (m.mark) {
            [section appendFormat:@"+%@",m.mark];
        }
        if (![resIDs containsObject:section]) {
            [resIDs addObject:section];
        }
    }
    return resIDs;
}

- (SHXPromise *)getDateItems:(NSDate *)date
{
    SHXPromise *promise = [SHXPromise new];
    if (![self.dateItems objectForKey:[date formatOnlyDay]]) {
        NSMutableDictionary *searchDict = [NSMutableDictionary dictionary];
        
        NSDate *tomorrow = [date dateByAddingTimeInterval:secondsPerDay];
        NSString *todayString = [date formatOnlyDay];
        NSString *tomorrowString = [tomorrow formatOnlyDay];
        [searchDict setObject:@{@"$gte":todayString,@"$lt":tomorrowString} forKey:@"createdAt"];
        if (![UserInfo shareInstance].isAdmin) {
            [searchDict setObject:[UserInfo shareInstance].name forKey:@"name"];
        }
       return [[[BimService instance] getListAttach:nil searchDict:searchDict] onFulfilled:^id(id value) {
            
            NSMutableArray *itemArray = [NSMutableArray array];
            for (NSDictionary *dict in value) {
                ListModel *model = [ListModel modelWithDict:dict];
                [itemArray addObject:model];
            }
            [self.dateItems setObject:[self dealItems:itemArray] forKey:todayString];
            return self.dateItems;
        } rejected:^id(NSError *reason) {
            return reason;
        }];
    }else{
       [promise resolve:self.dateItems];
        return promise;
    }
}


- (NSArray *)dealItems:(NSArray *)items
{
    NSMutableArray *res = [NSMutableArray array];
    NSArray *resIDs = [NSArray arrayWithArray:[self getAllSections:items]];
    // 分组
    for (NSString *section in resIDs) {
        UserListModel *model = [UserListModel new];
        model.name = section;
        NSUInteger totle = 0;
        NSMutableArray *lists = [NSMutableArray array];
        for (ListModel *m in items) {
            NSString *middle = m.mark?[NSMutableString stringWithFormat:@"%@+%@",m.name,m.mark]:m.name;
            if ([section isEqualToString:middle]) {
                totle += m.totalNumber;
                [lists addObject:m];
            }
        }
        if (totle > 0){
            model.totle = [NSString stringWithFormat:@"%zd",totle];
            model.listArray = lists;
            [res addObject:model];
        }
        
    }
    return res;
}

- (void)reloadDataAndUI {
    NSString *dayString = [self.currentDate formatOnlyDay];
    self.navView.currenDateLabel.text = dayString;
    self.items = [NSArray arrayWithArray:[self currentDateItems]];
    [self.tableView reloadData];
}

#pragma mark - event
-(void)search {
    
    SearchTVC *searchTVC = [[UIStoryboard storyboardWithName:@"SearchTVC" bundle:nil] instantiateInitialViewController];
    searchTVC.delegate = self;
    [self.navigationController pushViewController:searchTVC animated:YES];
}

#pragma mark - ListNavViewDelegate
- (void)getNewDateGlassDataWithPre:(BOOL)preDay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, 44 ) animated:YES];
    });
    NSDate *newDay;
    if (preDay) {
        newDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:self.currentDate];
    }else{
        newDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:self.currentDate];
        if ([newDay timeIntervalSinceNow] > 0) {
            return;
        }
    }
    self.currentDate = newDay;
    [[self getDateItems:newDay] onFulfilled:^id(id value) {
        [self reloadDataAndUI];
        return value;
    }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UserListModel *model = self.items[section];
    ListHeadView *headView = [ListHeadView headViewWithSeeMoreInfoBlock:^{
        NSLog(@"%@",model);
    }];
    headView.nameLable.text = model.name;
    headView.totleLable.text = [NSString stringWithFormat:@"(共%@块)",model.totle];
    return headView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    UserListModel *model = self.items[section];
    NSString *string = [NSString stringWithFormat:@"%@(共%@块)",model.name,model.totle];
    return string;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    UserListModel *model = self.items[section];
    return model.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserListModel *model = self.items[indexPath.section];
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
        _navView = [[ListNavView alloc] initWithFrame:CGRectMake(0, 0, 220, 44) delegate:self];
    }
    return _navView;
}

- (NSArray *)items {
    if (!_items) {
        _items = [NSArray array];
    }
    return _items;
}



@end
