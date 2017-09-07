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

@interface HomeCollectionCell()

@property (assign, nonatomic) NSUInteger page;

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
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //tableview设置
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listcellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self beginRefresh];
    }];
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    self.items = [NSMutableArray array];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)beginRefresh {
    
//    NSArray *array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"List.plist" ofType:nil]];
//    
//    ListHeadModel *model = [[ListHeadModel alloc] init];
//    model.name = @"赵二";
//    model.date = @"2016-5-31";
//    model.totle = @"100";
//    NSMutableArray *lists = [NSMutableArray array];
//    for (NSDictionary *dict in array) {
//        ListModel *m = [ListModel modelWithDict:dict];
//        [lists addObject:m];
//        model.listArray = [NSArray arrayWithArray:lists];
//    }
//    [self.items addObject:model];
    
    NSString *company = [UserInfo shareInstance].name;
    
    NSDictionary *dict = @{
                           @"company":company,
//                           @"createdAt":[self getCuttentDayPeriod]
                           };
    
    self.page = self.page + 1;
    NSString *attach = [NSString stringWithFormat:@"skip=%zd&limit=%d",  100 * (1), 100];

    [[[BimService instance] getListAttach:attach searchDict:dict] onFulfilled:^id(NSArray *value) {
        if (value.count > 0) {
            if (self.page == 1) {
                self.items = [NSMutableArray arrayWithArray:value];
            }else{
                [self.items addObjectsFromArray:value];
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return value;
    }rejected:^id(NSError *reason) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return reason;
    }];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
    
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


#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ListHeadView *view = [ListHeadView headView];
    view.frame = CGRectMake(0, 0, 100, 44);
//    view.nameLable.text = self.items[section].name;
//    view.totleLable.text = self.items[section].totle;
    view.dateLable.text = [self.date formatOnlyDay];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listcellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (indexPath.row < self.items[indexPath.section].listArray.count) {
//        cell.listModel = self.items[indexPath.section].listArray[indexPath.row];
//    }
    return cell;
}


@end
