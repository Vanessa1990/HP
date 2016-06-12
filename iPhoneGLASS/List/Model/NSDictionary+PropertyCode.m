//
//  NSDictionary+PropertyCode.m
//  06-Runtime(字典转模型KVC实现)
//
//  Created by 1 on 15/12/10.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "NSDictionary+PropertyCode.h"
/*
 else if ([value isKindOfClass:[NSDictionary class]]){
 //    Bool
 code = [NSString stringWithFormat:@"@property (nonatomic ,assign) NSInteger %@;",key];
 }
 */

// isKindOfClass:判断是否是当前类或者它的子类

@implementation NSDictionary (PropertyCode)
- (void)createPropertyCode
{
    NSMutableString *strM = [NSMutableString string];
    /*
        解析字典,生成对应属性代码
        1.遍历字典,取出所有key,每个key对应一个属性代码
     
     */
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSLog(@"%@ %@",key,[value class]);
        
        // @property (nonatomic ,strong) NSString *source;
        // @property(nonatomic ,assign) int reposts_count;
        NSString *code = nil;
        if ([value isKindOfClass:[NSString class]]) {
            // NSString
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSString *%@;",key];
            
        } else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            //    Bool
            code = [NSString stringWithFormat:@"@property (nonatomic ,assign) BOOL %@;",key];
        }else if ([value isKindOfClass:[NSNumber class]]){
            //    NSInteger
            code = [NSString stringWithFormat:@"@property (nonatomic ,assign) NSInteger %@;",key];
        }else if ([value isKindOfClass:[NSArray class]]){
            //    NSArray
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSArray *%@;",key];
        }else if ([value isKindOfClass:[NSDictionary class]]){
            //    NSDictionary
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSDictionary *%@;",key];
            
        }
        

        
        [strM appendFormat:@"\n%@\n",code];
        // 获取所有key
    }];
    
    NSLog(@"%@",strM);
    
}
@end
