//
//  MasterViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2018/3/13.
//  Copyright © 2018年 Yizhu. All rights reserved.
//

#import "MasterViewController.h"
#import "ListCell.h"
#import "HPRefreshHeader.h"

@interface MasterViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    //tableview设置
    [self.tableView registerClass:[ListCell class] forCellReuseIdentifier:@"ListCellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            model.openList = NO;
            [res addObject:model];
        }
    }
    return res;
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

- (NSArray *)items {
    if (!_items) {
        _items = [NSArray array];
    }
    return _items;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return 44;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    UserListModel *model = self.items[section];
    if (!model.openList) {
        return model.listArray.count;
    }else{
        return 0;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.items.count;

}
@end
