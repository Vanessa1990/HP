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
#import "HPChooseView.h"
#import "ContactTableViewController.h"
#import "STPickerDate.h"
#import <Masonry.h>

#define KeyboardHeight 300

@interface WriteInViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, ResultCellDelegate,KeyBoardViewDelegate,UITextFieldDelegate,HPChooseViewDelegate>

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *searchItems;

@property(nonatomic, strong) NSMutableArray *finishItems;

@property(nonatomic, strong) ListModel *writeInModel;

@property(nonatomic, strong) KeyBoardView *keyBoard;

@property (assign, nonatomic) NSInteger addCount;
// 搜索条件
@property(nonatomic, strong) HPChooseView *chooseView;
@property(nonatomic, strong) NSString *name;
@property (assign, nonatomic) BOOL finishState;
@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) NSString *month;
@property(nonatomic, strong) UIButton *searchButton;

@end

@implementation WriteInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"入库";
    [self initView];
    [self keyBoard:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看订单" style:UIBarButtonItemStylePlain target:self action:@selector(seeMore:)];
    [self setShowTabItem];
}

- (void)initView {
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth-100, 44)];
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(44);
    }];
    self.searchBar.placeholder = @"请输入搜索条件,以 * 连接";
    self.searchBar.delegate = self;
    //    self.searchBar.keyboardType = UIKeyboardTypeNumberPad;
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [self.searchButton setTitleColor:YZ_GrayColor61 forState:UIControlStateNormal];
    self.searchButton.backgroundColor = YZ_ThemeGrayColor;
    self.searchButton.titleLabel.font = YZ_Font(15);
    [self.searchButton addTarget:self action:@selector(searchFunc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(self.searchBar);
        make.width.mas_equalTo(60);
        make.left.mas_equalTo(self.searchBar.mas_right);
    }];
    
    
    HPChooseView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"HPChooseView" owner:0 options:nil] lastObject];
    chooseView.delegate = self;
    self.chooseView = chooseView;
    [self.view addSubview:chooseView];
    [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(self.searchBar.mas_bottom);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, kScreenWidth, kScreenHeight - 108 - 49)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(chooseView.mas_bottom);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellReuseIdentifier:@"ResultCellID"];
    
    self.searchItems = [NSMutableArray array];
    [self.view addSubview:self.keyBoard];
    [self.keyBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(KeyboardHeight);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.searchBar.text = @"505+1448";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabBarController setTabBarVisible:NO animated:YES completion:nil];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyBoard:(BOOL)show {
    CGFloat bottom = show?0:KeyboardHeight;
    [UIView animateWithDuration:0.3 animations:^{
        [self.keyBoard mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(bottom);
        }];
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if ([self.tabBarController tabBarIsVisible]) {
        [self.tabBarController setTabBarVisible:NO animated:YES completion:nil];
    }
    [self keyBoard:YES];
    return NO;
}

#pragma mark - HPChooseViewDelegate
- (void)chooseViewClear {
    self.name = nil;
    self.finishState = NO;
    self.year = nil;
    self.month = nil;
    self.chooseView.name = nil;
    self.chooseView.finish = NO;
    self.chooseView.year = nil;
    self.chooseView.month = nil;
}

-  (void)chooseViewChooseState {
    [self.searchBar resignFirstResponder];
    STPickerDate *pickView = [[STPickerDate alloc] initWithType:PickerTypeFinishTwo];
    pickView.finishBlock = ^(NSString *date){
        if (!date) {
            self.finishState = NO;
        }else {
            if ([date isEqualToString:@"已完成"]) {
                self.finishState = YES;
            }else {
                self.finishState = NO;
            }
        }
        self.chooseView.finish = self.finishState;
        [self searchFunc];
    };
    [pickView show];
}

- (void)chooseViewChooseYear {
    [self.searchBar resignFirstResponder];
    STPickerDate *pickView = [[STPickerDate alloc] initWithType:PickerTypeDate];
    pickView.finishBlock = ^(NSString *date){
        self.year = date;
        self.chooseView.year = date;
        [self searchFunc];
    };
    [pickView show];
}

- (void)chooseViewChooseName {
    ContactTableViewController *vc = [[ContactTableViewController alloc] initWithSelectedBlock:^(UserModel *model) {
        self.name = model.name;
        self.chooseView.name = model.name;
        [self.navigationController popViewControllerAnimated:YES];
        [self searchFunc];
    }];
    [self.navigationController pushViewController:vc animated:YES];
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
    NSArray *allValue;
    if (self.searchBar.text && self.searchBar.text.length > 0) {
        allValue = [self.searchBar.text componentsSeparatedByString:@"*"];
    }
    
    BOOL canSearch = NO;
    if (allValue.count > 0 && allValue.count <= 2) {
        canSearch = YES;
    }else {
        if (self.name) {
            canSearch = YES;
        }
    }
    
    if (!canSearch) {
        return;
    }

    __block NSMutableDictionary *searchDict;
    self.searchItems = [NSMutableArray array];
    self.finishItems = [NSMutableArray array];
    searchDict = [NSMutableDictionary dictionary];
    if (allValue.count == 1) {
        // 搜索长度
        searchDict = [NSMutableDictionary dictionaryWithDictionary:@{@"length":allValue[0]}];
    }else if (allValue.count == 2){
        // 搜索长+宽
        searchDict = [NSMutableDictionary dictionaryWithDictionary:@{@"length":allValue[0],@"width":allValue[1]}];
    }

    if (!self.finishState) {
        [searchDict setObject:@(NO) forKey:@"finish"];
    }else {
        [searchDict setObject:@(YES) forKey:@"finish"];
    }
    if (self.name) {
        [searchDict setValue:self.name forKey:@"name"];
    }
    if (self.year) {
        NSMutableDictionary *timedict = [NSMutableDictionary dictionary];
        [timedict setValue:self.year forKey:@"$gte"];
        NSDate *date = [NSDate dateFormDayString:self.year];
        NSDate *endDate = [date dateByAddingTimeInterval:24*60*60];
        [timedict setValue:[endDate formatOnlyDay] forKey:@"$lt"];
        if (timedict.count > 0) {
            [searchDict setObject:timedict forKey:@"createdAt"];
        }
    }
    
    [[self searchWithDict:searchDict seeSame:NO] onFulfilled:^id(id value) {
        searchDict = [NSMutableDictionary dictionary];
        if (allValue.count == 1) {
            // 搜索宽度
            searchDict = [NSMutableDictionary dictionaryWithDictionary:@{@"width":allValue[0]}];
        }else if (allValue.count == 2) {
            // 搜索宽+长
            searchDict = [NSMutableDictionary dictionaryWithDictionary:@{@"width":allValue[0],@"length":allValue[1]}];
        }
        if (!self.finishState) {
            [searchDict setObject:@(NO) forKey:@"finish"];
        }else {
            [searchDict setObject:@(YES) forKey:@"finish"];
        }
        if (self.name) {
            [searchDict setValue:self.name forKey:@"name"];
        }
        if (self.year) {
            NSMutableDictionary *timedict = [NSMutableDictionary dictionary];
            [timedict setValue:self.year forKey:@"$gte"];
            NSDate *date = [NSDate dateFormDayString:self.year];
            NSDate *endDate = [date dateByAddingTimeInterval:24*60*60];
            [timedict setValue:[endDate formatOnlyDay] forKey:@"$lt"];
            if (timedict.count > 0) {
                [searchDict setObject:timedict forKey:@"createdAt"];
            }
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
    return [[[BimService instance] getListSkip:0 limit:200 searchDict:searchDict] onFulfilled:^id(NSArray *value) {
        if (value && value.count > 0) {
            NSArray *ones = [self dealWithResultDicts:value seeSame:see];
//            NSArray *twos = [self dealWithResultDicts:value seeSame:see][@"finish"];
            [self.searchItems addObjectsFromArray:ones];
//            [self.finishItems addObjectsFromArray:twos];
        }
        return value;
    }];
}

- (NSArray *)dealWithResultDicts:(NSArray *)dicts seeSame:(BOOL)see{
    NSMutableArray *array = [NSMutableArray array];
//    NSMutableArray *finish = [NSMutableArray array];
    for (NSDictionary *dict in dicts) {
        if (see) {
            if (![[self.searchItems valueForKeyPath:@"glassID"] containsObject:dict[@"_id"]] &&
                ![[self.finishItems valueForKeyPath:@"glassID"] containsObject:dict[@"_id"]]) {
                
                ListModel *model = [ListModel modelWithDict:dict];
                [array addObject:model];
            }
        }else{
            ListModel *model = [ListModel modelWithDict:dict];
            [array addObject:model];
        }
    }
    return array;
}

- (void)seeMore:(id)sender {
    
    HomeViewController *VC;
    if (self.writeInModel) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.writeInModel.name forKey:@"name"];
        VC = [[SearchListViewController alloc] initWithSearchDict:dict sort:YES];
        [self.navigationController pushViewController:VC animated:YES];
    }
}


#pragma mark - ResultCellDelegate
- (void)writeInForRow:(NSInteger)row {
    ListModel *model = self.searchItems[row];
    self.writeInModel = model;
    
    UIAlertController *alertvc = [self alertVCWithModel:model addOrderCount:YES handler:^(UIAlertAction *action) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在入库";
        //成功之后退出
        NSUInteger newStockin = model.number?model.number:0;
        newStockin+=self.addCount;
        
        NSMutableDictionary *writeInDict = [NSMutableDictionary dictionaryWithObject:@(newStockin) forKey:@"stockIn"];
        if (newStockin >= model.totalNumber) {
            [writeInDict setObject:@(YES) forKey:@"finish"];
        }else{
            [writeInDict setObject:@(NO) forKey:@"finish"];
        }
        [writeInDict setObject:[UserInfo shareInstance].name forKey:@"operator"];
        
        [[[BimService instance] updateGlassInfo:model.glassID newDict:writeInDict] onFulfilled:^id(id value) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:value options:kNilOptions error:nil];
            if (dict) {
                hud.label.text = @"入库成功";
                [hud hideAnimated:YES afterDelay:0.3];
                // 修改当前数据
                ListModel *newmodel = [ListModel modelWithDict:dict];
                [self reloadData:newmodel index:row];
            }else{
                hud.label.text = @"入库失败,请稍后重试";
                [hud hideAnimated:YES afterDelay:0.5];
            }
            
            return value;
        }];
    }];
    [self presentViewController:alertvc animated:YES completion:nil];
}
- (void)ResultCell:(UITableViewCell *)cell didPutaway:(NSInteger)row
{
    [self writeInForRow:row];
}

- (UIAlertController *)alertVCWithModel:(ListModel *)model addOrderCount:(BOOL)addOrderCount handler:(void (^)(UIAlertAction *action))handler {
    // init message
    NSString *message = [NSString stringWithFormat:@"\n%@  %@\n%@*%@\n",model.name,model.thick,model.height,model.width];
    NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] initWithString:message];
    [messageStr addAttributes:@{NSForegroundColorAttributeName:YZ_ThemeColor,
                                NSFontAttributeName:YZ_Font_XL
                                } range:NSMakeRange(0, message.length)];
    // init alert vc
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:addOrderCount?@"确定入库?":@"确定撤销" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertvc setValue:messageStr forKey:@"attributedMessage"];
    // init actions
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        handler(action);
    }];
    [alertvc addAction:action];
    [alertvc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    if (addOrderCount) {
        [alertvc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.delegate = self;
            textField.text = @"1";
            self.addCount = 1;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.font = YZ_Font_XL;
        }];
    }
    
    return alertvc;
}


- (void)reloadData:(ListModel *)newModel index:(NSUInteger)index{
    [self.searchItems replaceObjectAtIndex:index withObject:newModel];
    [self.tableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.addCount = [textField.text integerValue];
    });
    return YES;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self keyBoard:NO];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self keyBoard:NO];
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self writeInForRow:indexPath.row];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"撤销" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        ListModel *model = self.searchItems[indexPath.row];
        self.writeInModel = model;
        UIAlertController *alertvc = [self alertVCWithModel:model addOrderCount:NO handler:^(UIAlertAction *action) {
            //上传数据
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"正在撤销";
            //成功之后退出
            NSUInteger newStockin = model.number?model.number:0;
            if (newStockin >0) {
                newStockin--;
                NSMutableDictionary *writeInDict = [NSMutableDictionary dictionaryWithObject:@(newStockin) forKey:@"stockIn"];
                if (newStockin >= model.totalNumber) {
                    [writeInDict setObject:@(YES) forKey:@"finish"];
                }else{
                    [writeInDict setObject:@(NO) forKey:@"finish"];
                }
                [writeInDict setObject:[UserInfo shareInstance].name forKey:@"operator"];
                
                [[[BimService instance] updateGlassInfo:model.glassID newDict:writeInDict] onFulfilled:^id(id value) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:value options:kNilOptions error:nil];
                    if (dict) {
                        hud.label.text = @"撤销成功";
                        [hud hideAnimated:YES afterDelay:0.3];
                        // 修改当前数据
                        ListModel *newmodel = [ListModel modelWithDict:dict];
                        [self reloadData:newmodel index:indexPath.row];
                    }else{
                        hud.label.text = @"撤销失败,请稍后重试";
                        [hud hideAnimated:YES afterDelay:0.5];
                    }
                    
                    return value;
                }];
            }else{
                hud.label.text = @"不可撤销!!!";
                [hud hideAnimated:YES afterDelay:0.5];
            }
        }];
        [self presentViewController:alertvc animated:YES completion:nil];
    }];
    return @[action];
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
