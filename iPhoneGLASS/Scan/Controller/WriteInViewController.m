//
//  WriteInViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/7/30.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "WriteInViewController.h"
#import "SearchListViewController.h"
#import "ResultCell.h"
#import "MBProgressHUD.h"
#import "BimService.h"
#import "ListModel.h"
#import "KeyBoardView.h"

#define KeyboardHeight 260

@interface WriteInViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, ResultCellDelegate,KeyBoardViewDelegate>

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *searchItems;

@property(nonatomic, strong) NSMutableArray *finishItems;

@property(nonatomic, strong) ListModel *writeInModel;

@property(nonatomic, strong) KeyBoardView *keyBoard;

@end

@implementation WriteInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"入库";

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 44)];
    [self.view addSubview:self.searchBar];
    self.searchBar.placeholder = @"请输入搜索条件,以 * 连接";
    self.searchBar.delegate = self;
//    self.searchBar.keyboardType = UIKeyboardTypeNumberPad;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, kScreenWidth, kScreenHeight - 108 - 49)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellReuseIdentifier:@"ResultCellID"];
    
    self.searchItems = [NSMutableArray array];
    [self.view addSubview:self.keyBoard];
    [self keyBoard:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看订单" style:UIBarButtonItemStylePlain target:self action:@selector(seeMore:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.searchBar.text = @"505+1448";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyBoard:(BOOL)show {
    CGRect frame = show ? CGRectMake(0, kScreenHeight - KeyboardHeight, kScreenWidth, KeyboardHeight) : CGRectMake(0, kScreenHeight, kScreenWidth, KeyboardHeight);
    [UIView animateWithDuration:0.3 animations:^{
        self.keyBoard.frame = frame;
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self keyBoard:YES];
    return NO;
}

#pragma mark - KeyBoardViewDelegate
- (void)chooseNumber:(int)number {
    NSString *string = self.searchBar.text?self.searchBar.text:@"";
    self.searchBar.text = [NSString stringWithFormat:@"%@%d",string,number];
}

- (void)deleteNumber {
    if (self.searchBar.text && self.searchBar.text.length > 0) {
        NSString *string = self.searchBar.text;
        NSString *newStr = [string substringToIndex:string.length - 1];
        self.searchBar.text = newStr;
    }
}

- (void)searchFunc {
    [self.view endEditing:YES];
    [self keyBoard:NO];
    if (!self.searchBar.text || self.searchBar.text.length == 0) return;
    NSArray *allValue = [self.searchBar.text componentsSeparatedByString:@"*"];
    if (allValue.count < 1 || allValue.count > 2) return;
    // 暂不考虑姓名
    //searchDict = @{@"length":allValue[0],@"width":allValue[1]};
    __block NSDictionary *searchDict;
    self.searchItems = [NSMutableArray array];
    self.finishItems = [NSMutableArray array];
    if (allValue.count == 1) {
        // 搜索长度
        searchDict = @{@"length":allValue[0]};
    }else if (allValue.count == 2){
        // 搜索长+宽
        searchDict = @{@"length":allValue[0],@"width":allValue[1]};
    }
    [[self searchWithDict:searchDict seeSame:NO] onFulfilled:^id(id value) {
        if (allValue.count == 1) {
            // 搜索宽度
            searchDict = @{@"width":allValue[0]};
        }else if (allValue.count == 2) {
            // 搜索宽+长
            searchDict = @{@"width":allValue[0],@"length":allValue[1]};
        }
        return [[self searchWithDict:searchDict seeSame:YES] onFulfilled:^id(id value) {
            [self.tableView reloadData];
            return value;
        }];
    }];
}

- (void)addSeparator {
    NSString *string = self.searchBar.text?self.searchBar.text:@"";
    self.searchBar.text = [NSString stringWithFormat:@"%@*",string];
}

- (SHXPromise *)searchWithDict:(NSDictionary *)searchDict seeSame:(BOOL)see {
    return [[[BimService instance] getListAttach:nil searchDict:searchDict] onFulfilled:^id(NSArray *value) {
        if (value && value.count > 0) {
            NSArray *ones = [self dealWithResultDicts:value seeSame:see][@"unfinish"];
            NSArray *twos = [self dealWithResultDicts:value seeSame:see][@"finish"];
            [self.searchItems addObjectsFromArray:ones];
            [self.finishItems addObjectsFromArray:twos];
        }
        return value;
    }];
}

- (NSDictionary *)dealWithResultDicts:(NSArray *)dicts seeSame:(BOOL)see{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *finish = [NSMutableArray array];
    for (NSDictionary *dict in dicts) {
        if (see) {
            if (![[self.searchItems valueForKeyPath:@"glassID"] containsObject:dict[@"_id"]] &&
                ![[self.finishItems valueForKeyPath:@"glassID"] containsObject:dict[@"_id"]]) {
                
                ListModel *model = [ListModel modelWithDict:dict];
                if (model.number == model.totalNumber) {
                    [finish addObject:model];
                }else{
                    [array addObject:model];
                }
            }
        }else{
            ListModel *model = [ListModel modelWithDict:dict];
            if (model.number == model.totalNumber) {
                [finish addObject:model];
            }else{
                [array addObject:model];
            }
        }
    }
    return @{@"finish":finish,@"unfinish":array};
}

- (void)seeMore:(id)sender {
    
    HomeViewController *VC;
    if (self.writeInModel) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.writeInModel.name forKey:@"name"];
//        [dict setValue:self.writeInModel.name forKey:@"name"];
        VC = [[SearchListViewController alloc] initWithSearchDict:dict sort:YES];
    }else{
        VC = [[HomeViewController alloc] init];
    }
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - ResultCellDelegate
- (void)ResultCell:(UITableViewCell *)cell didPutaway:(NSInteger)row
{
    if (row >= self.searchItems.count) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"已全!!!不可重复入库!!!";
        [hud hideAnimated:YES afterDelay:0.5];
    }else{
        ListModel *model = self.searchItems[row];
        self.writeInModel = model;
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //上传数据
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"正在入库";
            //成功之后退出
            NSUInteger newStockin = model.number?model.number:0;
            if (newStockin < model.totalNumber) {
                newStockin+=1;
                NSMutableDictionary *writeInDict = [NSMutableDictionary dictionaryWithObject:@(newStockin) forKey:@"stockIn"];
                if (newStockin == model.totalNumber) {
                    [writeInDict setObject:@(YES) forKey:@"finish"];
                }
                [[[BimService instance] updateGlassInfo:model.glassID newDict:writeInDict] onFulfilled:^id(id value) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:value options:kNilOptions error:nil];
                    if (dict) {
                        hud.label.text = @"入库成功";
                        [hud hideAnimated:YES afterDelay:0.5];
                        // 修改当前数据
                        ListModel *newmodel = [ListModel modelWithDict:dict];
                        [self reloadData:newmodel index:row];
                    }else{
                        hud.label.text = @"入库失败,请稍后重试";
                        [hud hideAnimated:YES afterDelay:0.5];
                    }
                    
                    return value;
                }];
            }else{
                hud.label.text = @"已全!!!不可重复入库!!!";
                [hud hideAnimated:YES afterDelay:0.5];
            }
        }];
        NSString *message = [NSString stringWithFormat:@"%@  %@\n%@*%@\n",model.name,model.thick,model.height,model.width];
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"确定入库?" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertvc addAction:action];
        [alertvc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertvc animated:YES completion:nil];
    }
}


- (void)reloadData:(ListModel *)newModel index:(NSUInteger)index{
    [self.searchItems replaceObjectAtIndex:index withObject:newModel];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchItems.count + self.finishItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (self.searchItems.count == 0 || indexPath.row > self.searchItems.count - 1) {
        cell.model = self.finishItems[indexPath.row - self.searchItems.count];
    }else{
        cell.model = self.searchItems[indexPath.row];
    }
    cell.row = indexPath.row;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}

- (KeyBoardView *)keyBoard
{
    if (!_keyBoard) {
        _keyBoard = [[KeyBoardView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, KeyboardHeight)];
        _keyBoard.delegate = self;
    }
    return _keyBoard;
}

@end
