//
//  ContactTableViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/21.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "ContactTableViewController.h"
#import "RegistViewController.h"
#import "UserModel.h"
#import "BimService.h"
#import "MBProgressHUD.h"
#import "HPRefreshHeader.h"


@interface ContactTableViewController ()<UITableViewDelegate, UITableViewDataSource,RegistViewControllerDelegate,UITextFieldDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *indexs;
@property(nonatomic, strong) UserModel *resetModel;
@property(nonatomic, copy) SelecteBlock block;
@property (assign, nonatomic) BOOL addEnable;

@end

@implementation ContactTableViewController
- (NSArray *)contacts {
    if (!_contacts) {
        _contacts = [NSArray array];
    }
    return _contacts;
}

- (instancetype)initWithSelectedBlock:(void (^)(UserModel *model))selecteBlock {
    return [self initWithSelectedBlock:selecteBlock add:YES];
}

- (instancetype)initWithSelectedBlock:(SelecteBlock)selecteBlock add:(BOOL)addEnable {
    if (self = [super init]) {
        self.block = selecteBlock;
        self.addEnable = addEnable;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户列表";
    [self setBackItem];
    if (self.addEnable) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelection = YES;

    HPRefreshHeader *header =  [HPRefreshHeader headerWithRefreshingBlock:^{
        if (!self.contacts || self.contacts.count == 0) {
            [self getData];
        }else{
            NSMutableArray *newContacts = [NSMutableArray array];
            for (NSString *name in self.contacts) {
                UserModel *model = [UserModel new];
                model.name = name;
                [newContacts addObject:model];
            }
            self.contacts = [self sortObjectsAccordingToInitialWith:newContacts];
            [self.tableView reloadData];
        }
    }];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)add:(id)sender {
    RegistViewController *registVC = [[RegistViewController alloc] init];
    registVC.delegate = self;
    [self.navigationController pushViewController:registVC animated:YES];
}

- (SHXPromise *)getData {
    if (self.addEnable) {
        return [[[BimService instance] getAllUsers] onFulfilled:^id(id value) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in value) {
                UserModel *model = [UserModel new];
                [model setValuesForKeysWithDictionary:dict];
                [array addObject:model];
            }
            self.contacts = [self sortObjectsAccordingToInitialWith:array];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            return value;
        }];
    }else{
        return [[[BimService instance] getAllClient] onFulfilled:^id(id value) {
            NSMutableArray *newContacts = [NSMutableArray array];
            if ([value isKindOfClass:[NSArray class]]) {
                for (NSString *name in value) {
                    UserModel *model = [UserModel new];
                    model.name = name;
                    [newContacts addObject:model];
                }
                self.contacts = [self sortObjectsAccordingToInitialWith:newContacts];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }
            return value;
        }];
    }
    
}

// 按首字母分组排序数组
-(NSMutableArray *)sortObjectsAccordingToInitialWith:(NSArray *)arr {
    
    // 初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    NSArray *allIndexs = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    NSMutableArray *indexs = [[NSMutableArray alloc] init];
    
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    //将每个名字分到某个section下
    for (UserModel *personModel in arr) {
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector:@selector(name)];
        //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:personModel];
    }
    
    //对每个section中的数组按照name属性排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(name)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    //删除空的数组
    NSMutableArray *finalArr = [NSMutableArray new];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
            [finalArr addObject:newSectionsArray[index]];
            [indexs addObject:allIndexs[index]];
        }
    }
    self.indexs = [NSArray arrayWithArray:indexs];
    return finalArr;
}

- (void)registSuccess {
    [self getData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (textField.tag / 100 == 1) {
            self.resetModel.name = textField.text;
        } else if (textField.tag / 100 == 2) {
            self.resetModel.phone = textField.text;
        } else {
            self.resetModel.password = textField.text;
        }
    });
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.contacts[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.indexs[section]?self.indexs[section]:@"#";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"contactCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = YZ_ThemeColor;
    }
    NSArray *arr = self.contacts[indexPath.section];
    UserModel *model = arr[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.phone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.block) {
        NSArray *arr = self.contacts[indexPath.section];
        UserModel *model = arr[indexPath.row];
        self.block(model);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.addEnable) {
        NSArray *arr = self.contacts[indexPath.section];
        UserModel *model = arr[indexPath.row];
        
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            [self reset:model];
        }];
        UITableViewRowAction *deletedAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [[[BimService instance] deleteUser:model.userID] onFulfilled:^id(id value) {
                [self getData];
                return value;
            }];
        }];
        
        return @[deletedAction,action];
    }else{
        return @[];
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexs;
}

- (void)reset:(UserModel *)model {
    RegistViewController *registVC = [[RegistViewController alloc] init];
    registVC.delegate = self;
    registVC.user = model;
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)addTextFieldWith:(NSInteger)tag text:(NSString *)text vc:(UIAlertController *)vc {
    [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.tag = tag;
        textField.font = YZ_Font_XL;
        textField.text = text;
    }];
}



@end
