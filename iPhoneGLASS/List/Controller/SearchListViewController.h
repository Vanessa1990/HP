//
//  SearchListViewController.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/9/8.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface SearchListViewController : MasterViewController

- (instancetype)initWithSearchDict:(NSDictionary *)searchDict sort:(BOOL)sort;

- (instancetype)initWithSearchDict:(NSDictionary *)searchDict;

@end
