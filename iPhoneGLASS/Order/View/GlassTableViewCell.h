//
//  GlassTableViewCell.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/6/15.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlassTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLable;
@property(nonatomic, assign) int num;
@property(nonatomic, copy) void(^changeNumberBlock)(NSString *numberString);

+(instancetype)glassCell;

@end
