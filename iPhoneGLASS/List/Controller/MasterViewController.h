//
//  MasterViewController.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2018/3/13.
//  Copyright © 2018年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserListModel.h"
#import "ListModel.h"

@interface MasterViewController : UIViewController

@property(nonatomic, strong) UITableView *tableView;

- (void)initNav;

- (void)getTableViewData;

- (NSArray *)dealItems:(NSArray *)items;

- (NSArray *)getAllSections:(NSArray *)items;

@property(nonatomic, strong) NSArray *items;

@end
