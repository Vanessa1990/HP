//
//  MoreTVC.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/17.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "MoreTVC.h"
#import "PrefixHeader.pch"
#import "AppDelegate.h"
#import "WWLoadVC.h"
#import "AboutViewController.h"
#import "UIView+MJExtension.h"
#import "RegistViewController.h"
#import "MBProgressHUD.h"
#import "ContactTableViewController.h"
#import "BimService.h"

@interface MoreTVC ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *telLable;
@property(nonatomic, strong) UITextField *pwdTextField;

@end

@implementation MoreTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.telLable.text = HP_Delegate.name;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = YZ_ThemeGrayColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(quit:)];
    [self setShowTabItem];
    
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tabBarController setTabBarVisible:NO animated:YES completion:nil];
//    });
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

- (void)quit:(id)sender
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"hp_glass.db"];
    NSString *tableName = @"hp_glass_table";
    [store clearTable:tableName];
    
    // 清空本地数据
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{}];
    HS_PERSISTENT_SET_OBJECT(data, USER_INFO);
    
    //进入登录页面
    WWLoadVC *loadVC = [[WWLoadVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loadVC];
    HP_Delegate.window.rootViewController = nav;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.01;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 10;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([UserInfo shareInstance].admin) {
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"关于我们";
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"客户资料";
        }
    }else{
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"修改密码";
        }
        else if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"关于我们";
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        if ([UserInfo shareInstance].admin) {
            ContactTableViewController *contactVC = [[ContactTableViewController alloc] initWithSelectedBlock:nil add:YES];
            [self.navigationController pushViewController:contactVC animated:YES];
        }else{
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self resetPwd];
            }];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"修改密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                self.pwdTextField = textField;
                textField.font = YZ_Font_XL;
                textField.placeholder = @"请输入新的密码";
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:sureAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }else if (indexPath.row == 1) {
        AboutViewController *aboutVC = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

- (void)resetPwd {
    [[[BimService instance] updateUser:[UserInfo shareInstance].userID newDict:@{@"password":self.pwdTextField.text}] onFulfilled:^id(id value) {
        [self quit:nil];
        return value;
    }];
}

@end
