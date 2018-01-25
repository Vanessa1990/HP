//
//  SearchListViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/9/8.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "SearchListViewController.h"
#import "ListModel.h"
#import "ListTableViewCell.h"
#import "NSDate+YZBim.h"
#import "SendOrderViewController.h"
#import "MBProgressHUD.h"

typedef enum : NSUInteger {
    All,
    UnFinish,
    Finish,
} FinishType;

@interface SearchListViewController ()<UITableViewDelegate>
// 搜索状态下的搜索值
@property(nonatomic, strong) NSDictionary *searchDict;

@property(nonatomic, strong) UIBarButtonItem *editbuttonItem;

@property (assign, nonatomic,getter=isEdit) BOOL edit;

@property (assign, nonatomic) FinishType type;

@property(nonatomic, strong) NSMutableArray *chooseItems;

@property(nonatomic, strong) UIButton *deleteButton;

@property(nonatomic, strong) UIButton *sendButton;

@property (assign, nonatomic) BOOL sort;

@property(nonatomic, strong) NSArray *colors;

@property (assign, nonatomic) int colorEven;


@end

@implementation SearchListViewController

- (instancetype)initWithSearchDict:(NSDictionary *)searchDict sort:(BOOL)sort {
    if (self = [self initWithSearchDict:searchDict]) {
        self.sort = sort;
    }
    return self;
}

- (instancetype)initWithSearchDict:(NSDictionary *)searchDict {
    if (self = [super init]) {
        self.searchDict = searchDict;
    }
    return self;
}

- (void)initNav{
    self.navigationItem.title = @"搜索结果";
    self.navigationItem.titleView = nil;
    if ([UserInfo shareInstance].admin) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        self.edit = NO;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.deleteButton];
    [self.view addSubview:self.sendButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(49);
        make.height.mas_equalTo(49);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(self.deleteButton.mas_right);
        make.width.bottom.mas_equalTo(self.deleteButton);
    }];
    self.colors = @[YZ_WhiteColor, YZ_ThemeAlphaC];
    
}

- (void)getTableViewData {
    // 最多搜索200条数据
    [[[BimService instance] getListSkip:0 limit:200 searchDict:self.searchDict] onFulfilled:^id(id value) {
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSDictionary *dict in value) {
            ListModel *model = [ListModel modelWithDict:dict];
            [itemArray addObject:model];
        }
        self.items = [self dealItems:itemArray];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        return value;
    } rejected:^id(NSError *reason) {
        return reason;
    }];
}

- (void)sendClick:(UIButton *)button {
    // 同一用户下发货
    NSString *userName;
    BOOL moreP = NO;
    for (ListModel *model in self.chooseItems) {
        if (!userName) {
            userName = model.name;
        }else{
            if (![model.name isEqualToString:userName]) {
                moreP = YES;
                break;
            }
        }
    }
    if (moreP) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"只能选择一位用户订单";
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.0];
        return;
    }
    
    SendOrderViewController *sendVC = [[SendOrderViewController alloc] initWithModels:[NSArray arrayWithArray:self.chooseItems]];
    [self.navigationController pushViewController:sendVC animated:YES];
}

- (void)deleteClick:(UIButton *)button {
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *glasses = [self.chooseItems valueForKeyPath:@"glassID"];
        [[[BimService instance] deleteGlasses:glasses] onFulfilled:^id(id value) {
            [self.chooseItems removeAllObjects];
            [self getTableViewData];
            return value;
        }];
    }];
    
    NSString *message = [NSString stringWithFormat:@"确定删除%zd条数据\n共%zd块玻璃?",self.chooseItems.count,[self getAllGlassCount]];
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertvc addAction:action];
    [alertvc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertvc animated:YES completion:nil];
}

- (NSInteger)getAllGlassCount {
    NSUInteger count = 0;
    for (ListModel *model in self.chooseItems) {
        count += model.totalNumber;
    }
    return count;
}


- (void)editClick:(UIBarButtonItem *)button {
    if (self.isEdit) {
        self.edit = NO;
        self.editButtonItem.title = @"编辑";
        self.navigationItem.rightBarButtonItems = @[self.editButtonItem];
    }else{
        self.edit = YES;
        self.editButtonItem.title = @"取消";
        UIBarButtonItem *allItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(selectedAll:)];
        self.navigationItem.rightBarButtonItems = @[self.editButtonItem,allItem];
    }
    [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.isEdit?0:49);
    }];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.isEdit?-49:0);
    }];
    
    [self.chooseItems removeAllObjects];
    [self.tableView reloadData];
}

- (void)selectedAll:(UIBarButtonItem *)allItem {
    [self.chooseItems removeAllObjects];
    for (UserListModel *um in self.items) {
        NSArray *models = um.listArray;
        [self.chooseItems addObjectsFromArray:models];
    }
    [self.tableView reloadData];
}

- (UIBarButtonItem *)editButtonItem {
    if (!_editbuttonItem) {
        _editbuttonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editClick:)];
        self.edit = YES;
    }
    return _editbuttonItem;
}

- (NSMutableArray *)chooseItems {
    if (!_chooseItems) {
        _chooseItems = [NSMutableArray array];
    }
    return _chooseItems;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.backgroundColor = YZ_PinkColor;
        [_deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发货" forState:UIControlStateNormal];
        _sendButton.backgroundColor = YZ_ThemeColor;
        [_sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserListModel *model = self.items[indexPath.section];
    ListModel *listModel = model.listArray[indexPath.row];
    cell.listModel = listModel;
    cell.edit = self.isEdit;
    cell.choose = [self.chooseItems containsObject:listModel];
    if (indexPath.row > 0) {
        ListModel *preListModel = model.listArray[indexPath.row - 1];
        NSString *date1 = [[NSDate dateFromISOString:preListModel.date] formatOnlyDay];
        NSString *date2 = [[NSDate dateFromISOString:listModel.date] formatOnlyDay];
        if (![date1 isEqualToString:date2]) {
            self.colorEven = (self.colorEven + 1) % 2;
        }
    }else{
        self.colorEven = 0;
    }
    cell.backgroundColor = self.colors[self.colorEven % 2];
    if (self.sort) {// 入库后查看当前用户所有订单(显示日期)
        cell.showDate = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserListModel *model = self.items[indexPath.section];
    ListModel *listModel = model.listArray[indexPath.row];
    if ([self.chooseItems containsObject:listModel]) {
        [self.chooseItems removeObject:listModel];
    }else{
        [self.chooseItems addObject:listModel];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UserListModel *model = self.items[section];
    ListHeadView *headView = [[ListHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) chooseClick:^(UserListModel *model, BOOL choose) {
        for (ListModel *listModel in model.listArray) {
            if (choose) {
                if (![self.chooseItems containsObject:listModel]) {
                    [self.chooseItems addObject:listModel];
                }
            }else{
                if ([self.chooseItems containsObject:listModel]) {
                    [self.chooseItems removeObject:listModel];
                }
            }
        }
        [self.tableView reloadData];
    }];
    headView.model = model;
    headView.edit = self.isEdit;
    return headView;
}

@end
