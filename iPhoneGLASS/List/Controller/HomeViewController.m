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
#import "ChooseDateViewController.h"
#import "SendOrderViewController.h"
#import "BasicTableController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource,ListNavViewDelegate,JTCalendarDelegate,ChooseDateViewControllerDelegate,ListHeadViewDelegate,BasicTableControllerDelegate>

@property (assign, nonatomic) NSUInteger skip;
// 普通用户用到
@property (nonatomic, strong) NSArray *allDates;
@property (assign, nonatomic) NSUInteger index;

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
@property(nonatomic, strong) ChooseDateViewController *chooseVC;

@property(nonatomic, strong) NSMutableDictionary *nameIndexs;// 索引

@end

static NSUInteger const secondsPerDay = 24 * 60 * 60;

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.nameIndexs = [NSMutableDictionary dictionary];
    
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
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [swipeGes setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeGes setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.tableView addGestureRecognizer:swipeGes];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabBarController setTabBarVisible:NO animated:YES completion:nil];
    });
}

- (void)initView {

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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
    NSArray *items;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    items = @[item1];
    if ([UserInfo shareInstance].admin) {
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"发货" style:UIBarButtonItemStylePlain target:self action:@selector(sendClick)];
        items = @[item1,item2];
    }
    self.navigationItem.rightBarButtonItems = items;
    [self setShowTabItem];
}

- (void)upAndReload {
    [self.tableView.mj_header beginRefreshing];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)sender {
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            
            break;
        case UISwipeGestureRecognizerDirectionRight:
            
            break;
            
        default:
            break;
    }
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
            NSMutableArray *nameIndexs = [NSMutableArray array];
            for (NSDictionary *dict in value) {
                ListModel *model = [ListModel modelWithDict:dict];
                [itemArray addObject:model];
            }
            NSArray *array = [self dealItems:itemArray];
            for (UserListModel *um in array) {
                [nameIndexs addObject:[um.name substringToIndex:1]];
            }
            [self.dateItems setObject:array forKey:todayString];
            [self.nameIndexs setObject:nameIndexs forKey:todayString];
            return self.dateItems;
        } rejected:^id(NSError *reason) {
            return reason;
        }];
    }else{
       [promise resolve:self.dateItems];
        return promise;
    }
}


- (void)reloadDataAndUI {
    NSString *dayString = [self.currentDate formatOnlyDay];
    self.navView.currenDateLabel.text = dayString;
    self.items = [NSArray arrayWithArray:[self currentDateItems]];
    [self.tableView reloadData];
}

#pragma mark - BasicTableControllerDelegate
- (void)basicTableController:(BasicTableController *)vc chooseItem:(NSString *)item {
    for (UserListModel *model in self.items) {
        if ([item isEqualToString:model.name]) {
            SendOrderViewController *sendVC = [[SendOrderViewController alloc] initWithModels:[NSArray arrayWithArray:model.listArray]];
            [self.navigationController popViewControllerAnimated:NO];
            [self.navigationController pushViewController:sendVC animated:NO];
            break;
        }
    }
}

#pragma mark - event
-(void)search {
    self.calendarView = nil;
    SearchTVC *searchTVC = [[SearchTVC alloc] init];
    [self.navigationController pushViewController:searchTVC animated:YES];
}

- (void)sendClick {
    BasicTableController *vc = [[BasicTableController alloc] init];
    NSMutableArray *names = [NSMutableArray array];
    for (UserListModel *model in self.items) {
        [names addObject:model.name];
    }
    if (names.count > 0) {
        vc.items = names;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:NO];
    }
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

- (void)listHeadViewSendOrders:(ListHeadView *)view model:(UserListModel *)model {
    SendOrderViewController *sendVC = [[SendOrderViewController alloc] initWithModels:[NSArray arrayWithArray:model.listArray]];
    [self.navigationController pushViewController:sendVC animated:YES];
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
    if (open) {
        ChooseDateViewController *chooseVC = [[ChooseDateViewController alloc] init];
        chooseVC.currentDate = [NSDate date];
        chooseVC.muti = NO;
        chooseVC.delegate = self;
        if (![UserInfo shareInstance].admin) {
            chooseVC.dates = self.allDates;
        }
        self.chooseVC = chooseVC;
        chooseVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:chooseVC animated:NO completion:nil];
        
    }else{
        if (self.chooseVC) {
            [self.chooseVC dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

- (void)closeCalendar {
    [self.navView closeCalendar];
}

#pragma mark - ChooseDateViewControllerDelegate
- (void)chooseDateViewController:(ChooseDateViewController *)vc chooseDate:(NSDate *)date {
    if (date) {
        [self chooseDate:NO];
        self.currentDate = date;
        self.skip = 0;
        [self getTableViewData];
    }
}

#pragma mark - CalendarViewDelegate
- (void)calendarView:(CalendarView *)view didTouchDate:(NSDate *)date {
    [self chooseDate:NO];
    self.currentDate = date;
    self.skip = 0;
    [self getTableViewData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UserListModel *model = self.items[section];
    ListHeadView *headView = [[ListHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) ];
    headView.model = model;
    headView.delgate = self;
    return headView;
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

#pragma mark - set && get
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




@end
