//
//  HomeViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/7/31.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "HomeViewController.h"
#import "OrderInfoViewController.h"
#import "CalendarView.h"
#import <JTCalendar/JTCalendar.h>
#import "HPRefreshHeader.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource,ListNavViewDelegate,JTCalendarDelegate,CalendarViewDelegate,ListHeadViewDelegate>
// 普通用户用到
@property (nonatomic, strong) NSArray *allDates;
@property (assign, nonatomic) NSUInteger index;
// 普通用户用到

@property (nonatomic, strong) NSMutableDictionary *dateItems;

@property(nonatomic, strong) NSDate *currentDate;

@property(nonatomic, strong) ListNavView *navView;

@property (assign, nonatomic) BOOL preClick;

@property (assign, nonatomic) BOOL reGetData;
@property(nonatomic, strong) UIButton *reloadButton;

// 日历
@property(nonatomic, strong) CalendarView *calendarView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (strong, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) JTHorizontalCalendarView *calendarContentView;
@property(nonatomic, strong) UIView *bgView;


@end

static NSUInteger const secondsPerDay = 24 * 60 * 60;
static NSUInteger const calendarH = 320;

@implementation HomeViewController

- (JTCalendarMenuView *)calendarMenuView {
    if (!_calendarMenuView) {
        _calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    }
    return _calendarMenuView;
}

- (JTHorizontalCalendarView *)calendarContentView
{
    if (!_calendarContentView) {
        _calendarContentView = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    }
    return _calendarContentView;
}

- (JTCalendarManager *)calendarManager
{
    if (!_calendarManager) {
        _calendarManager = [[JTCalendarManager alloc] init];
        [_calendarManager setMenuView:self.calendarMenuView];
        [_calendarManager setContentView:self.calendarContentView];
        _calendarManager.delegate = self;
    }
    return _calendarManager;
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadButton setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
        _reloadButton.backgroundColor = [UIColor clearColor];
        [_reloadButton addTarget:self action:@selector(upAndReload) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self initNav];
    self.allDates = [NSArray array];
    self.dateItems = [NSMutableDictionary dictionary];
    self.currentDate = [NSDate date];
    [self initView];
    self.preClick = YES;
    if ([UserInfo shareInstance].admin) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        [[self getAllDates] onFulfilled:^id(id value) {
            NSString *dateString = self.allDates[self.index];
            self.currentDate = [NSDate dateFormDayString:dateString];
            [self.tableView.mj_header beginRefreshing];
            return value;
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabBarController setTabBarVisible:NO animated:YES completion:nil];
    });
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
    HPRefreshHeader *header =  [HPRefreshHeader headerWithRefreshingBlock:^{
        [self getNewData];
    }];
    
    self.tableView.mj_header = header;
    
    [self.view addSubview:self.reloadButton];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-60);
        make.width.height.mas_equalTo(50);
    }];
}

- (void)initNav {
    self.navigationItem.titleView = self.navView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    [self setShowTabItem];
}

- (void)upAndReload {
    [self.tableView.mj_header beginRefreshing];
}

- (SHXPromise *)getAllDates {
    return [[[BimService instance] getAllDate:[UserInfo shareInstance].name] onFulfilled:^id(id value) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *dateString in value) {
            NSDate *date = [NSDate dateFromISOString:dateString];
            NSString *newDateString = [date formatOnlyDay];
            if (![array containsObject:newDateString]) {
                [array addObject:newDateString];
            }
        }
        self.allDates = [NSArray arrayWithArray:array];
        self.index = self.allDates.count - 1;
        return value;
    }];
}

- (void)getNewData {
    self.skip = 0;
    self.reGetData = YES;
    [self getTableViewData];
}

- (void)getTableViewData {
    self.navView.currenDateLabel.text = [self.currentDate formatOnlyDay];
    [[self getDateItems:self.currentDate] onFulfilled:^id(id value) {
        [self reloadDataAndUI];
        [self.tableView.mj_header endRefreshing];
        return value;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.tabBarController tabBarIsVisible]) {
        [self.tabBarController setTabBarVisible:NO animated:YES completion:nil];
    }
    [self chooseDate:NO];
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
    if (![self.dateItems objectForKey:[date formatOnlyDay]] || self.reGetData) {
        self.reGetData = NO;
        NSMutableDictionary *searchDict = [NSMutableDictionary dictionary];
        
        NSDate *tomorrow = [date dateByAddingTimeInterval:secondsPerDay];
        NSString *todayString = [date formatOnlyDay];
        NSString *tomorrowString = [tomorrow formatOnlyDay];
        [searchDict setObject:@{@"$gte":todayString,@"$lt":tomorrowString} forKey:@"createdAt"];

        if (![UserInfo shareInstance].admin) {
            [searchDict setObject:[UserInfo shareInstance].name forKey:@"name"];
        }
        return [[[BimService instance] getListSkip:0 limit:0 searchDict:searchDict] onFulfilled:^id(id value) {
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
        int arrivedGlassCount = 0;
        for (ListModel *m in items) {
            NSString *middle = m.mark?[NSMutableString stringWithFormat:@"%@+%@",m.name,m.mark]:m.name;
            if ([section isEqualToString:middle]) {
                totle += m.totalNumber;
                [lists addObject:m];
                if (m.deliverymans && m.deliverymans.count > 0) {
                    arrivedGlassCount++;
                }
            }
        }
        if (totle > 0){
            model.totle = [NSString stringWithFormat:@"%zd",totle];
            model.listArray = lists;
            model.arrived = arrivedGlassCount > 0;
            model.openList = NO;
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
    
//    SearchTVC *searchTVC = [[UIStoryboard storyboardWithName:@"SearchTVC" bundle:nil] instantiateInitialViewController];
    self.calendarView = nil;
    SearchTVC *searchTVC = [[SearchTVC alloc] init];
    [self.navigationController pushViewController:searchTVC animated:YES];
}

#pragma mark - ListHeadViewDelegate
- (void)listHeadView:(ListHeadView *)view model:(UserListModel *)model open:(BOOL)open {
    for (int i = 0; i < self.items.count; i++) {
        UserListModel *oldModel = self.items[i];
        if ([oldModel.name isEqualToString:model.name]) {
            model.openList = open;
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
            [array replaceObjectAtIndex:i withObject:model];
            self.items = [NSArray arrayWithArray:array];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
    }
}

#pragma mark - ListNavViewDelegate
- (void)getNewDateGlassDataWithPre:(BOOL)preDay {
    self.preClick = preDay;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, 44 ) animated:NO];
    });
    NSDate *newDay;
    if (preDay) {
        if ([UserInfo shareInstance].admin) {
            newDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:self.currentDate];
        }else{
            if (self.index > 0) {
                self.index--;
                newDay = [NSDate dateFormDayString:self.allDates[self.index]];
            }else{
                return;
            }
        }
    }else{
        if ([UserInfo shareInstance].admin) {
            newDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:self.currentDate];
            if ([newDay timeIntervalSinceNow] > 0) {
                return;
            }
        }else{
            if (self.index < self.allDates.count - 1) {
                self.index++;
                newDay = [NSDate dateFormDayString:self.allDates[self.index]];
            }else{
                return;
            }
        }
    }
    self.currentDate = newDay;
    self.skip = 0;
    [self getTableViewData];
}

- (void)chooseDate:(BOOL)open {
    CGFloat top = IOS11_OR_LATER?0:64;
    if (!self.calendarView) {
        self.calendarView = [[CalendarView alloc] initWithDelegate:self];
        [self.view addSubview:self.calendarView];
        [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(-calendarH);
            make.height.mas_equalTo(calendarH);
        }];
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.bgView.backgroundColor = YZ_Color(33, 33, 33, 0.3);
        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCalendar)];
        [self.bgView addGestureRecognizer:tapges];
    }
    [self.calendarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(open?top:-calendarH);
    }];
    if (open) {
        self.calendarView.currentDate = self.currentDate;
        self.calendarView.dates = [UserInfo shareInstance].admin?nil:self.allDates;
        [self.view insertSubview:self.bgView belowSubview:self.calendarView];
    }else{
        [self.bgView removeFromSuperview];
    }
}

- (void)closeCalendar {
    [self.navView closeCalendar];
}

#pragma mark - CalendarViewDelegate
- (void)calendarView:(CalendarView *)view didTouchDate:(NSDate *)date {
    [self chooseDate:NO];
    self.currentDate = date;
    self.skip = 0;
    [self getTableViewData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UserListModel *model = self.items[section];
    ListHeadView *headView = [[ListHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) ];
    headView.model = model;
    headView.delgate = self;
    return headView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    UserListModel *model = self.items[section];
    if (!model.openList) {
        return model.listArray.count;
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserListModel *model = self.items[indexPath.section];
    cell.listModel = model.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserListModel *model = self.items[indexPath.section];
    ListModel *listModel = model.listArray[indexPath.row];
    OrderInfoViewController *vc = [[OrderInfoViewController alloc] init];
    vc.model = listModel;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
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
