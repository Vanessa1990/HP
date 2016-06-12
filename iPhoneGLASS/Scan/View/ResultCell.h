//
//  ResultCell.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/6/1.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ResultCell;

@protocol ResultCellDelegate <NSObject>

-(void)ResultCell:(UITableViewCell *)cell didPutaway:(NSDictionary *)glassDictionary;

@end

@interface ResultCell : UITableViewCell

@property (nonatomic, copy) void (^saveSuccessBlock)();
@property (nonatomic, strong) id <ResultCellDelegate>delegate;

@end
