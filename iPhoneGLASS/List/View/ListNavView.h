//
//  ListNavView.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/18.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListNavViewDelegate

- (void)getNewDateGlassDataWithPre:(BOOL)preDay;
- (void)chooseDate:(BOOL)open;

@end

@interface ListNavView : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

@property(nonatomic, strong) UILabel *currenDateLabel;
@property(nonatomic, strong) UIButton *dataBtn;
@property(nonatomic, strong) id <ListNavViewDelegate>delegate;

@end
