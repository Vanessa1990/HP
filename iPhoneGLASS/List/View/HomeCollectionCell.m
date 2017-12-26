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
#import "ListCell.h"

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
    CGFloat headY = self.contentView.bounds.size.height - (kScreenHeight - 64);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, self.bounds.size.height - 44)];
    [self addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //tableview设置
//    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listcellID"];
    [self.tableView registerClass:[ListCell class] forCellReuseIdentifier:@"ListCellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.items = [NSArray array];
    
    ListHeadView *view = [ListHeadView headViewWithSeeMoreInfoBlock:^{
        
    }];
    view.frame = CGRectMake(0, 0, kScreenWidth, 44);
    view.dateLable.text = [self.date formatOnlyDay];
    [self addSubview:view];
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
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    UserListModel *model = self.items[section];
    NSString *string = [NSString stringWithFormat:@"%@\t\t\t\t\t%@",model.name,model.totle];
    return string;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    ListHeadView *view = [[[NSBundle mainBundle] loadNibNamed:@"ListHeadView" owner:0 options:0] lastObject];
//    UserListModel *model = self.items[section];
//    view.nameLable.text = model.userID;
//    view.totleLable.text = model.totle;
//    return view;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
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


@end
