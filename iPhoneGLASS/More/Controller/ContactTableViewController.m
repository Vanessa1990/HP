//
//  ContactTableViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/21.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "ContactTableViewController.h"
#import "UserModel.h"
#import "BimService.h"

@interface ContactTableViewController ()

@property(nonatomic, strong) NSArray *contacts;
@property(nonatomic, strong) NSArray *indexs;

@end

@implementation ContactTableViewController
- (NSArray *)contacts {
    if (!_contacts) {
        _contacts = [NSArray array];
    }
    return _contacts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有客户";
    self.tableView.tableFooterView = [UIView new];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"contactCellID"];
    [[[BimService instance] getAllUsers] onFulfilled:^id(id value) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in value) {
            UserModel *model = [UserModel new];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
        }
        self.contacts = [self sortObjectsAccordingToInitialWith:array];
        [self.tableView reloadData];

        return value;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
