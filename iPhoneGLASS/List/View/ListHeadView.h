//
//  ListHeadView.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/31.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserListModel.h"
@class ListHeadView;

typedef void(^ChooseBlock)(UserListModel *model,BOOL choose);

@protocol ListHeadViewDelegate

- (void)listHeadView:(ListHeadView *)view model:(UserListModel *)model open:(BOOL)open;
- (void)listHeadViewSendOrders:(ListHeadView *)view model:(UserListModel *)model;

@end

@interface ListHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame chooseClick:(ChooseBlock)chooseClick;

@property(nonatomic, strong) UserListModel *model;

@property (assign, nonatomic) BOOL edit;

@property (assign, nonatomic) BOOL choosed;

@property(nonatomic, strong) id <ListHeadViewDelegate>delgate;


@end
