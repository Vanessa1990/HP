//
//  HeadView.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/6/14.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "HeadView.h"
#import "ListModel.h"
#import "AppDelegate.h"
#import "PrefixHeader.pch"
/*
 @property (nonatomic ,strong) NSString *thick;//厚度
 
 @property (nonatomic ,strong) NSString *name;
 
 @property (nonatomic ,assign) NSInteger color;//颜色
 
 @property (nonatomic ,strong) NSString *date;//日期
 
 @property (nonatomic ,strong) NSString *number;
 
 @property (nonatomic ,strong) NSString *width;
 
 @property (nonatomic ,strong) NSString *height;
 
 @property (nonatomic ,assign) BOOL wind;//弯钢
 
 @property (nonatomic ,assign) BOOL isFinish;//完成
 */

@implementation HeadView


- (IBAction)add:(id)sender {
    
    ListModel *model = [[ListModel alloc]init];
    model.thick = self.nameLable.text;
    model.name = HP_Delegate.name;
    model.color = 0;
    model.date = [NSString stringWithFormat:@"%@",[NSDate date]];

//    [self.glassArray addObject:model];
    if ([self.delegate respondsToSelector:@selector(HeadView:didClickAddGlass:)]) {
        [self.delegate HeadView:self didClickAddGlass:model];
    }
    
    
}

@end
