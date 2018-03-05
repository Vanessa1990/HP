//
//  HPChooseView.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2018/3/5.
//  Copyright © 2018年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPChooseViewButton: UIButton


@end

@protocol HPChooseViewDelegate

- (void)chooseViewChooseName;
- (void)chooseViewChooseState;
- (void)chooseViewChooseMonth;
- (void)chooseViewChooseYear;
- (void)chooseViewClear;


@end

@interface HPChooseView : UIView

@property (weak, nonatomic) IBOutlet HPChooseViewButton *nameBtn;
@property (weak, nonatomic) IBOutlet HPChooseViewButton *finishBtn;
@property (weak, nonatomic) IBOutlet HPChooseViewButton *yearBtn;
@property (weak, nonatomic) IBOutlet HPChooseViewButton *monthBtn;

@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) BOOL finish;
@property(nonatomic, strong) NSString *year;
@property(nonatomic, strong) NSString *month;


@property(nonatomic, strong) id <HPChooseViewDelegate>delegate;

@end


