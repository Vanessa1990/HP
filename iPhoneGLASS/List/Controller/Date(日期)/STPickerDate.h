//
//  STPickerDate.h
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/16.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PickerTypeDate,
    PickerTypeThick,
    PickerTypeFinish,
    PickerTypeFinishTwo,
} PickerType;

@interface STPickerDate : UIButton

- (instancetype)initWithType:(PickerType)type;

- (void)show;

@property (nonatomic,assign) PickerType type;
@property (nonatomic, copy) void (^finishBlock)(NSString *date);

@end
NS_ASSUME_NONNULL_END
