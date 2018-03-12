//
//  BasicTableController.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2018/3/9.
//  Copyright © 2018年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BasicTableController;

@protocol BasicTableControllerDelegate

- (void)basicTableController:(BasicTableController *)vc chooseItem:(NSString *)item;


@end

@interface BasicTableController : UITableViewController

@property (assign, nonatomic) BOOL addEnable;

@property(nonatomic, strong) NSArray *items;

@property(nonatomic, strong) id <BasicTableControllerDelegate>delegate;

@end
