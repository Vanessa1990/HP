//
//  SendOrderCell.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/25.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"

@protocol SendOrderCellDelegate

- (void)sendOrderCellCountClick:(ListModel *)model count:(NSInteger)count;

@end

@interface SendOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLable;

@property(nonatomic, strong) ListModel *model;

@property(nonatomic, strong) id <SendOrderCellDelegate>delegate;


@end
