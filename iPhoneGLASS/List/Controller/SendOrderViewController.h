//
//  SendOrderViewController.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/25.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserListModel.h"

@interface SendOrderViewController : UIViewController

- (instancetype)initWithModels:(NSArray *)models;

@property(nonatomic, strong) NSArray *models;

@end
