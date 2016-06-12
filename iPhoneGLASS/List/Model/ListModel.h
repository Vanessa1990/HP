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

@property (nonatomic ,assign) NSInteger color;//颜色

@property (nonatomic ,strong) NSString *date;//日期

@property (nonatomic ,strong) NSString *number;

@property (nonatomic ,strong) NSString *width;

@property (nonatomic ,strong) NSString *height;

@property (nonatomic ,assign) BOOL wind;//弯钢

@property (nonatomic ,assign) BOOL isFinish;//完成

@end
