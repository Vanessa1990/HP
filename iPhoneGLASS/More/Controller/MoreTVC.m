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

@interface MoreTVC ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *telLable;

@end

@implementation MoreTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.telLable.text = HP_Delegate.name;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = YZ_ThemeGrayColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(quit:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

- (void)quit:(id)sender
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"hp_glass.db"];
    NSString *tableName = @"hp_glass_table";
    [store clearTable:tableName];
    
    NSString *name = @"";
    NSString *pwd = @"";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:@"user"];
    
    HP_Delegate.name = name;
    HP_Delegate.pwd = pwd;
    
    //进入登录页面
    WWLoadVC *loadVC = [[WWLoadVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loadVC];
    HP_Delegate.window.rootViewController = nav;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
    }
    
    // Configure the cell...
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"清除缓存";
    }
    
    else if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"修改密码";
    }
    
    else if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"关于我们";
    }
    
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"注册";
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        AboutViewController *aboutVC = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
        
    }
    
    else if (indexPath.row == 3) {
        RegistViewController *registVC = [[RegistViewController alloc]init];
        [self.navigationController pushViewController:registVC animated:YES];
        
    }
    
}

@end
