//
//  ListCell.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/9/8.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListModel;

@interface ListCell : UITableViewCell

@property(nonatomic,strong) ListModel *listModel;

@end
