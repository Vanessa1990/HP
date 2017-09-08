//
//  HomeCollectionCell.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/7/31.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "HomeCollectionCell.h"
#import "ListHeadView.h"
#import "ListTableViewCell.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "BimService.h"
#import "NSDate+YZBim.h"
#import "UserListModel.h"

@interface HomeCollectionCell()

@property (assign, nonatomic) NSUInteger page;

@property (nonatomic, strong) ListHeadView *headView;

@end

@implementation HomeCollectionCell

- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.page = 0;
    self.backgroundColor = YZ_WhiteColor;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 64, kScreenWidth, self.bounds.size.height - 64 - 44)];
    [self.contentView addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //tableview设置
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listcellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.items = [NSArray array];
    
    ListHeadView *view = [ListHeadView headView];
    view.frame = CGRectMake(0, 64, kScreenWidth, 44);
    view.dateLable.text = [self.date formatOnlyDay];
    [self.contentView addSubview:view];
    self.headView = view;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    self.headView.dateLable.text = [self.date formatOnlyDay];
}

- (NSDictionary *)getCuttentDayPeriod {
    NSDate *date = self.date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components: NSEraCalendarUnit |NSYearCalendarUnit | NSMonthCalendarUnit| NSDayCalendarUnit| NSHourCalendarUnit  fromDate: date];
    [comps setHour:8];
    NSDate *beginDate = [calendar dateFromComponents:comps];
    NSDate *endDate = [beginDate dateByAddingTimeInterval:3600*24];
    NSDictionary *dct = [[NSDictionary alloc] initWithObjects:@[beginDate, endDate] forKeys:@[@"$gte", @"$lt"]];
    return dct;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    UserListModel *model = self.items[section];
    return model.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listcellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserListModel *model = self.items[indexPath.section];
    cell.listModel = model.listArray[indexPath.row];
    return cell;
}


@end
