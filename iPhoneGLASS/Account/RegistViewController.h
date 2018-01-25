//
//  RegistViewController.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/7/31.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@protocol RegistViewControllerDelegate

- (void)registSuccess;

@end

@interface RegistViewController : UIViewController

@property(nonatomic, strong) id<RegistViewControllerDelegate>delegate;

@property(nonatomic, strong) UserModel *user;

@end
