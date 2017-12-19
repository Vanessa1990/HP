//
//  ResultCell.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/6/1.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"
@class ResultCell;

@protocol ResultCellDelegate <NSObject>

- (void)ResultCell:(UITableViewCell *)cell didPutaway:(ListModel *)model;

@end

@interface ResultCell : UITableViewCell

@property (nonatomic, copy) void (^saveSuccessBlock)();
@property (nonatomic, strong) id <ResultCellDelegate>delegate;
@property(nonatomic, strong) ListModel *model;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *length;
@property (weak, nonatomic) IBOutlet UILabel *width;
@property (weak, nonatomic) IBOutlet UILabel *writeCount;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
