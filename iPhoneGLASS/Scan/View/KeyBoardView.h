//
//  KeyBoardView.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/12/30.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyBoardViewDelegate

- (void)chooseNumber:(int)number;
- (void)deleteNumber;
- (void)searchFunc;
- (void)addSeparator;

@end

@interface KeyBoardView : UIView

@property(nonatomic, strong) id<KeyBoardViewDelegate>delegate;

@end
