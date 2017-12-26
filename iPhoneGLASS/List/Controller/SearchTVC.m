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
#import "UserInfo.h"

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

- (BOOL)textIsNotNull:(UITextField *)textField {
    if ([@"全部" isEqualToString:textField.text]) {
        return NO;
    }
    return textField.text && textField.text.length > 0;
}

-(void)sure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
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
    if (self.beginDate.text || self.endDate.text) {
        NSMutableDictionary *timedict = [NSMutableDictionary dictionary];
        if ([self textIsNotNull:self.beginDate]) {
            [timedict setValue:self.beginDate.text forKey:@"$gte"];
        }
        if ([self textIsNotNull:self.endDate]) {
            [timedict setValue:self.endDate.text forKey:@"$lt"];
        }
        if (timedict.count > 0) {
            [dict setObject:timedict forKey:@"createdAt"];
        }
    }
    int finish = (int)self.finishState.selectedSegmentIndex;
    if (finish > 0) {
        [dict setObject:@(finish == 2) forKey:@"finish"];
    }
    
    SearchListViewController *VC = [[SearchListViewController alloc] initWithSearchDict:dict];
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



@end
