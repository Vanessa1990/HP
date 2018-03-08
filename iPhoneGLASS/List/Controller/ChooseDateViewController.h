//
//  ChooseDateViewController.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2018/3/8.
//  Copyright © 2018年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChooseDateViewController;

@protocol ChooseDateViewControllerDelegate

- (void)chooseDateViewController:(ChooseDateViewController *)vc chooseDate:(id)date;

@end

@interface ChooseDateViewController : UIViewController

@property(nonatomic, strong) NSDate *currentDate;

@property (assign, nonatomic) BOOL muti;

@property(nonatomic, strong) NSArray *dates;

@property(nonatomic, strong) id <ChooseDateViewControllerDelegate>delegate;

@end
