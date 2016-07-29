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

@interface MoreTVC ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *telLable;

@end

@implementation MoreTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCellID" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCellID"];
    }
    
    // Configure the cell...
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"关于我们";
    }else {
        UILabel *lable = [[UILabel alloc]initWithFrame:cell.contentView.bounds];
        lable.textColor = [UIColor redColor];
        lable.text = @"退出登录";
        lable.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:lable];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 35;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        AboutViewController *aboutVC = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
        
    } else {
        
        NSString *name = @"";
        NSString *pwd = @"";
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setBool:NO forKey:@"logged"];
        [user setValue:name forKey:@"name"];
        [user setValue:pwd forKey:@"pwd"];
        
        HP_Delegate.name = name;
        HP_Delegate.pwd = pwd;
        
        //进入登录页面
        WWLoadVC *loadVC = [[WWLoadVC alloc]init];
        HP_Delegate.window.rootViewController = loadVC;
    }
}

@end
