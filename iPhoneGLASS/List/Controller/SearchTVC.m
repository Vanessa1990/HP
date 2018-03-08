//
//  SearchTVC.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/31.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "SearchTVC.h"
#import "PrefixHeader.pch"
#import "AppDelegate.h"
#import "STPickerDate.h"
#import "ListModel.h"
#import "ScanViewController.h"
#import "SearchListViewController.h"
#import "ContactTableViewController.h"
#import "ChooseDateViewController.h"
#import "UserInfo.h"
#import "UserModel.h"
#import "MBProgressHUD.h"

@interface SearchTVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ChooseDateViewControllerDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic)  UITextField *beginDate;
@property (strong, nonatomic)  UITextField *endDate;
@property (strong, nonatomic)  UITextField *thick;
@property (strong, nonatomic)  UITextField *width;
@property (strong, nonatomic)  UITextField *height;
@property (strong, nonatomic)  UIButton *fuzzyBtn;
@property (strong, nonatomic)  UITextField *name;
@property(nonatomic, strong) UITextField *finish;

@property(nonatomic,strong) NSMutableDictionary *searchDic;
@property (assign, nonatomic) BOOL fuzzySearch;
@property(nonatomic, strong) UITextField *fuzzy;

//@property(nonatomic, strong) CalendarView *calendarView;
//@property(nonatomic, strong) UIView *bgView;

@end

@implementation SearchTVC

-(NSMutableDictionary *)searchDic {
    
    if (_searchDic == nil) {
        _searchDic = [NSMutableDictionary dictionary];
    }
    return _searchDic;
}

- (void)initView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *footView = [[UIView alloc] init];
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setBackgroundColor:YZ_PinkColor];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:YZ_ThemeColor];
    [footView addSubview:resetBtn];
    [footView addSubview:sureBtn];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(resetBtn);
        make.left.mas_equalTo(resetBtn.mas_right);
    }];
    [resetBtn addTarget:self action:@selector(resetSearchDict:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
    
    [self initView];
    
    if (![UserInfo shareInstance].admin) {
        self.name.text = [UserInfo shareInstance].name;
        self.name.userInteractionEnabled = NO;
    }
    [self setBackItem];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event
-(void)changeState:(UISegmentedControl *)seg {
    
    [self.searchDic setValue:@(seg.selectedSegmentIndex) forKey:@"isFinish"];
    
}
- (void)resetSearchDict:(id)sender {
    self.beginDate.text = @"";
    self.endDate.text = @"";
    self.thick.text = @"";
    self.width.text = @"";
    self.height.text = @"";
    self.finish.text = @"";
    self.fuzzySearch = NO;
    self.fuzzy.text = @"";
    if ([UserInfo shareInstance].admin){
        self.name.text = @"";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (BOOL)textIsNotNull:(UITextField *)textField {
    if ([@"全部" isEqualToString:textField.text]) {
        return NO;
    }
    return textField.text && textField.text.length > 0;
}

- (BOOL)lessThenSevenDay:(NSString *)begin end:(NSString *)end {
    NSDate *bd = [NSDate dateFormDayString:begin];
    NSDate *ed = [NSDate dateFormDayString:end];
    NSTimeInterval time = [ed timeIntervalSinceDate:bd];
    if (time <= 7 * 24 * 60 * 60) {
        return YES;
    }
    return NO;
}

- (void)showHudWithTitle:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = title;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:1.0];
}

-(void)sure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if ([self textIsNotNull:self.height]) {
        if (self.fuzzySearch && self.fuzzy.text) {
            int fn = [self.fuzzy.text intValue];
            int hn = [self.height.text intValue];
            NSString *hgte = [NSString stringWithFormat:@"%d",hn-fn];
            NSString *hlt = [NSString stringWithFormat:@"%d",hn+fn];
            [dict setValue:@{@"$gte":hgte,@"$lt":hlt} forKey:@"length"];
        }else{
            [dict setValue:self.height.text forKey:@"length"];
        }
    }
    if ([self textIsNotNull:self.width]) {
        if (self.fuzzySearch && self.fuzzy.text) {
            int fn = [self.fuzzy.text intValue];
            int wn = [self.width.text intValue];
            NSString *hgte = [NSString stringWithFormat:@"%d",wn-fn];
            NSString *hlt = [NSString stringWithFormat:@"%d",wn+fn];
            [dict setValue:@{@"$gte":hgte,@"$lt":hlt} forKey:@"width"];
        }else{
            [dict setValue:self.width.text forKey:@"width"];
        }
    }
    
    if (self.beginDate.text.length > 0) {
        NSMutableDictionary *timedict = [NSMutableDictionary dictionary];
        NSArray *dates = [self.beginDate.text componentsSeparatedByString:@"~"];
        if (dates.count == 1) {
            NSString *beginS = dates[0];
            NSDate *tomorrow = [[NSDate dateFormDayString:beginS] dateByAddingTimeInterval:24*60*60];
            NSString *tomorrowString = [tomorrow formatOnlyDay];
            [dict setObject:@{@"$gte":beginS,@"$lt":tomorrowString} forKey:@"createdAt"];
        }else if (dates.count == 2){
            [timedict setValue:dates[0] forKey:@"$gte"];
            NSDate *endDate = [[NSDate dateFormDayString:dates[1]] dateByAddingTimeInterval:24*60*60];
            NSString *endString = [endDate formatOnlyDay];
            [timedict setValue:endString forKey:@"$lt"];
            [dict setObject:timedict forKey:@"createdAt"];
        }
    }

    if ([self textIsNotNull:self.thick]) {
        [dict setValue:self.thick.text forKey:@"category"];
    }
    if (![UserInfo shareInstance].admin) {
        [dict setValue:[UserInfo shareInstance].name forKey:@"name"];
    }else{
        if ([self textIsNotNull:self.name]) {
            [dict setValue:self.name.text forKey:@"name"];
        }
    }
    
    if ([self.finish.text isEqualToString:@"未完成"]) {
        [dict setObject:@(NO) forKey:@"finish"];
    }else if ([self.finish.text isEqualToString:@"已完成"]) {
        [dict setObject:@(YES) forKey:@"finish"];
    }
    
    SearchListViewController *VC = [[SearchListViewController alloc] initWithSearchDict:dict sort:YES];
    [self.navigationController pushViewController:VC animated:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.beginDate || textField == self.endDate ) {
        [self.view endEditing:YES];
//        STPickerDate *pickView = [[STPickerDate alloc] initWithType:PickerTypeDate];
//        pickView.finishBlock = ^(NSString *date){
//            textField.text = date;
//        };
//        [pickView show];
        ChooseDateViewController *chooseVC = [[ChooseDateViewController alloc] init];
        chooseVC.currentDate = [NSDate date];
        chooseVC.muti = YES;
        chooseVC.delegate = self;
        chooseVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:chooseVC animated:NO completion:nil];
        return NO;
    }else if (textField == self.thick){
        [self.view endEditing:YES];
        STPickerDate *pickView = [[STPickerDate alloc] initWithType:PickerTypeThick];
        pickView.finishBlock = ^(NSString *date){
            if (!date) {
                textField.text = @"全部";
            }else {
                textField.text = date;
            }
        };
        [pickView show];
        return NO;
    }else if (textField == self.finish){
        [self.view endEditing:YES];
        STPickerDate *pickView = [[STPickerDate alloc] initWithType:PickerTypeFinish];
        pickView.finishBlock = ^(NSString *date){
            if (!date) {
                textField.text = @"全部";
            }else {
                textField.text = date;
            }
        };
        [pickView show];
        return NO;
    }else {
        return YES;
    }
    
}

- (void)fuzzyStateChange:(UIButton *)sender {
//    sender.selected = !sender.selected;
    self.fuzzySearch = !self.fuzzySearch;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - ChooseDateVC delegate
- (void)chooseDateViewController:(ChooseDateViewController *)vc chooseDate:(NSArray *)dates {
    if ([dates isKindOfClass:[NSArray class]]) {
        NSString *beginS = [(NSDate *)dates[0] formatOnlyDay];
        NSString *endS = [(NSDate *)dates[1] formatOnlyDay];
        if ([beginS isEqualToString:endS]) {
            self.beginDate.text = [NSString stringWithFormat:@"%@",beginS];
        }else{
            self.beginDate.text = [NSString stringWithFormat:@"%@~%@",beginS,endS];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([UserInfo shareInstance].admin) {
        return 4;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 4;
    }else if (section == 2) {
        return self.fuzzySearch?2:1;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = @"日期";
//        self.endDate = [self currentVCTextFieldShowInCell:cell];
//        UILabel *middleView = [[UILabel alloc] init];
//        middleView.text = @"---";
//        [middleView sizeToFit];
//        [cell.contentView addSubview:middleView];
//        [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.endDate.mas_left).offset(-5);
//            make.top.bottom.mas_equalTo(0);
//        }];
        self.beginDate = [self currentVCTextField];
        self.beginDate.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:self.beginDate];
        [self.beginDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(cell.textLabel);
            make.width.mas_equalTo(200);
        }];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"规格";
            self.thick = [self currentVCTextFieldShowInCell:cell];
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"长";
            self.height = [self currentVCTextFieldShowInCell:cell];
            self.height.keyboardType = UIKeyboardTypeNumberPad;
        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"宽";
            self.width = [self currentVCTextFieldShowInCell:cell];
            self.width.keyboardType = UIKeyboardTypeNumberPad;
        }else {
            cell.textLabel.text = @"完成状态";
            self.finish = [self currentVCTextFieldShowInCell:cell];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"searchCellID2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCellID2"];
                cell.textLabel.text = @"模糊搜索";
                self.fuzzyBtn = [[UIButton alloc] init];
                [self.fuzzyBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
                [self.fuzzyBtn setImage:[UIImage imageNamed:@"unchoose"] forState:UIControlStateNormal];
                [self.fuzzyBtn addTarget:self action:@selector(fuzzyStateChange:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:self.fuzzyBtn];
                [self.fuzzyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-15);
                    make.centerY.mas_equalTo(cell.textLabel);
//                    make.width.mas_equalTo(100);
                    make.height.width.mas_equalTo(44);
                }];
            }
            self.fuzzyBtn.selected = self.fuzzySearch;
        }else {
            cell.textLabel.text = @"范围";
            self.fuzzy = [self currentVCTextFieldShowInCell:cell];
            self.fuzzy.keyboardType = UIKeyboardTypeNumberPad;
        }
    }else{
        cell.textLabel.text = @"姓名";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.name = [self currentVCTextFieldShowInCell:cell];
        self.name.userInteractionEnabled = NO;
    }
    
    return cell;
    
}

- (UITextField *)currentVCTextFieldShowInCell:(UITableViewCell *)cell {
    UITextField *textField = [self currentVCTextField];
    textField.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(cell.textLabel);
        make.width.mas_equalTo(100);
    }];
    return textField;
}

- (UITextField *)currentVCTextField {
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.font = YZ_Font(15);
    textField.borderStyle = UITextBorderStyleRoundedRect;
    return textField;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        ContactTableViewController *vc = [[ContactTableViewController alloc] initWithSelectedBlock:^(UserModel *model) {
            self.name.text = model.name;
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
