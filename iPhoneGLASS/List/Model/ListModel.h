//
//  ListModel.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/31.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

+(ListModel *)modelWithDict:(NSDictionary *)dict;

@property (nonatomic ,strong) NSString *thick;//厚度

@property (nonatomic ,strong) NSString *name;

@property (nonatomic ,strong) NSString *color;//颜色

@property (nonatomic ,strong) NSString *date;//日期

@property (nonatomic ,assign) NSUInteger number;

@property (nonatomic ,assign) NSUInteger totalNumber;

@property (nonatomic ,strong) NSString *width;

@property (nonatomic ,strong) NSString *height;

@property (nonatomic ,assign) BOOL wind;//弯钢

@property (nonatomic ,assign) BOOL isFinish;//完成

@property(nonatomic,strong) NSString *glassID;

@property (nonatomic, strong) NSString *userID;

@property(nonatomic, strong) NSString *mark;

@property(nonatomic, strong) NSArray *deliverymans;

@end
