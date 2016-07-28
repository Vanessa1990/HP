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
    
    [self.tabBarController.tabBar setHidden:YES];
    if (![HP_Delegate.name isEqualToString:@"和平"]) {
        self.name.text = HP_Delegate.name;
        self.name.userInteractionEnabled = NO;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sure)];
    [self.finishState addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventValueChanged];
    
  
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
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

-(void)sure {
    
    //假数据
    //列表数据初始化
    NSArray *array = [NSArray array];
    NSMutableArray *itemArray = [NSMutableArray array];
    array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"List.plist" ofType:nil]];
    for (NSDictionary *dict in array) {
        ListModel *model = [ListModel modelWithDict:dict];
        [itemArray addObject:model];
    }
    //返回数据,刷新list列表
    if ([self.delegate respondsToSelector:@selector(SearchTVC:searchSuccess:)]) {
        [self.delegate SearchTVC:self searchSuccess:@[itemArray[0]]];
    }
    //返回
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ([HP_Delegate.name isEqualToString:@"和平钢化"]) {
        if (indexPath.section == 3 || indexPath.row == 0) {
            ScanViewController *scanVC = [[ScanViewController alloc]init];
            [self.navigationController pushViewController:scanVC animated:YES];
        }
//    } else {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"非管理者不能管理库存!!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
//    }

}



@end
