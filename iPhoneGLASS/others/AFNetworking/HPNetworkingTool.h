//
//  HPNetworkingTool.h
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/8/23.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPNetworkingTool : NSObject

+(instancetype)shareNetworkingTool;

/*******************************登录相关API***********************************************/

-(void)getlogin:(NSString *)urlstring parameters:(NSDictionary *)parameter finish:(void (^)(NSDictionary *dict))finishBlock failure:(void (^)())failureBlock;


/*******************************列表相关API***********************************************/
//获取网络数据
-(void)getListArray:(NSString *)urlstring parameters:(NSDictionary *)parameter finish:(void (^)(NSArray *array))finishBlock failure:(void (^)())failureBlock;
//获取本地数据
-(void)getLocalListArray:(void (^)(NSArray *array))finishBlock;

@end
