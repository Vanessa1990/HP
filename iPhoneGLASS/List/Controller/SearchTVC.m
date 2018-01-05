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
#import "UserInfo.h"
#import "UserModel.h"
#import "MBProgressHUD.h"

@interface SearchTVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *beginDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
@property (weak, nonatomic) IBOutlet UITextField *thick;
@property (weak, nonatomic) IBOutlet UITextField *width;
@property (weak, nonatomic) IBOutlet UITextField *height;
@property (weak, nonatomic) IBOutlet UISegmentedControl *finishState;
@property (weak, nonatomic) IBOutlet UITextField *name;

@property(nonatomic,strong) NSMutableDictionary *searchDic;

@end

@implementation SearchTVC

-(NSMutableDictionary *)searchDic {
    
    if (_searchDic == nil) {
        _searchDic = [NSMutableDictionary dictionary];
    }
    return _searchDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
    
    if (![UserInfo shareInstance].isAdmin) {
        self.name.text = [UserInfo shareInstance].name;
        self.name.userInteractionEnabled = NO;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sure)];
    [self.finishState addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventValueChanged];
    
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
- (IBAction)resetSearchDict:(id)sender {
    self.beginDate.text = @"";
    self.endDate.text = @"";
    self.thick.text = @"";
    self.width.text = @"";
    self.height.text = @"";
    self.finishState.selectedSegmentIndex = 0;
    self.name.text = @"";
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
    if ([self textIsNotNull:self.beginDate] && [self textIsNotNull:self.endDate]) {
        if ([self lessThenSevenDay:self.beginDate.text end:self.endDate.text]) {
            NSMutableDictionary *timedict = [NSMutableDictionary dictionary];
            [timedict setValue:self.beginDate.text forKey:@"$gte"];
            [timedict setValue:self.endDate.text forKey:@"$lt"];
            if (timedict.count > 0) {
                [dict setObject:timedict forKey:@"createdAt"];
            }
        }else {
            [self showHudWithTitle:@"只能查看相差7天的数据"];
            return;
        }
    }else{
        [self showHudWithTitle:@"日期必须选择"];
        return;
    }
    if ([self textIsNotNull:self.height]) {
        [dict setValue:self.height.text forKey:@"length"];
    }
    if ([self textIsNotNull:self.width]) {
        [dict setValue:self.width.text forKey:@"width"];
    }
    if ([self textIsNotNull:self.thick]) {
        [dict setValue:self.thick.text forKey:@"category"];
    }
    if ([self textIsNotNull:self.name]) {
        [dict setValue:self.name.text forKey:@"name"];
    }
    int finish = (int)self.finishState.selectedSegmentIndex;
    if (finish > 0) {
        [dict setObject:@(finish == 2) forKey:@"finish"];
    }
    
    SearchListViewController *VC = [[SearchListViewController alloc] initWithSearchDict:dict sort:YES];
    [self.navigationController pushViewController:VC animated:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.beginDate || textField == self.endDate ) {
        [self.view endEditing:YES];
        STPickerDate *pickView = [[STPickerDate alloc]initWithType:PickerTypeDate];
        pickView.finishBlock = ^(NSString *date){
            textField.text = date;
        };
        [pickView show];
        return NO;
    }else if (textField == self.thick){
        [self.view endEditing:YES];
        STPickerDate *pickView = [[STPickerDate alloc]initWithType:PickerTypeThick];
        pickView.finishBlock = ^(NSString *date){
            textField.text = date;
        };
        [pickView show];
        return NO;
    }else {
        return YES;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([UserInfo shareInstance].isAdmin) {
        return 3;
    }
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        ContactTableViewController *vc = [[ContactTableViewController alloc] initWithSelectedBlock:^(UserModel *model) {
            self.name.text = model.name;
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
