//
//  HomeViewController.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/7/31.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCollectionCell.h"
#import "SearchTVC.h"
#import "MoreTVC.h"
#import "NSDate+YZBim.h"
#import "BimService.h"
#import "UserListModel.h"
#import "ListNavView.h"
#import "ListCell.h"
#import "Utils.h"
#import "UserInfo.h"
#import "NSDate+YZBim.h"

@interface HomeViewController : UIViewController

- (void)initNav;

- (void)getTableViewData;

- (NSArray *)dealItems:(NSArray *)items;

- (NSArray *)getAllSections:(NSArray *)items;

@property(nonatomic, strong) NSArray *items;

@property(nonatomic, strong) UITableView *tableView;

@end
