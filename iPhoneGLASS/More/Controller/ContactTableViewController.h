//
//  ContactTableViewController.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/21.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

typedef void(^SelecteBlock)(UserModel *model);

@interface ContactTableViewController : UIViewController

- (instancetype)initWithSelectedBlock:(SelecteBlock)selecteBlock;

@property(nonatomic, strong) NSArray *contacts;

@end
