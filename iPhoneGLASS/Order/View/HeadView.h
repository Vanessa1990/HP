//
//  HeadView.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/6/14.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeadView,ListModel;

@protocol HeadViewDelegate <NSObject>

-(void)HeadView:(HeadView *)view didClickAddGlass:(ListModel *)model;

@end

@interface HeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property(nonatomic,strong) NSMutableArray *glassArray;
@property (nonatomic, strong) id <HeadViewDelegate>delegate;

@end
