//
//  ListTableViewCell.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/31.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListModel;

@interface ListTableViewCell : UITableViewCell

@property(nonatomic,strong) ListModel *listModel;

@end
