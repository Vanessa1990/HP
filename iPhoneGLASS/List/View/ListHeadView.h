//
//  ListHeadView.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/31.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *totleLable;

@property (weak, nonatomic) IBOutlet UILabel *dateLable;

+(instancetype)headView;

@end
