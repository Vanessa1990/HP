//
//  HPNetworkingTool.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/8/23.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "HPNetworkingTool.h"
#import "NetService.h"
#import "LocalService.h"

@interface HPNetworkingTool()

@property(nonatomic,strong) NetService *netWorker;

@property(nonatomic,strong) LocalService *localWorker;

@end


@implementation HPNetworkingTool

+(instancetype)shareNetworkingTool {
    
    static HPNetworkingTool *tool;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc]init];
    });
    return tool;
}

-(instancetype)init {
    
    if (self = [super init]) {
        _netWorker = [[NetService alloc]init];
        _localWorker = [[LocalService alloc]init];
    }
    return self;
}

-(void)getlogin:(NSString *)urlstring parameters:(NSDictionary *)parameter finish:(void (^)(NSDictionary *dict))finishBlock  failure:(void (^)())failureBlock
{
    [_netWorker getlogin:urlstring parameters:parameter success:finishBlock failure:failureBlock];
}


/*******************************列表相关API***********************************************/
-(void)getListArray:(NSString *)urlstring parameters:(NSDictionary *)parameter finish:(void (^)(NSArray *array))finishBlock failure:(void (^)())failureBlock
{
    [_netWorker getListArray:urlstring parameters:parameter finish:finishBlock failure:failureBlock];
}

-(void)getLocalListArray:(void (^)(NSArray *array))finishBlock
{
    NSArray *listArray = [_localWorker getLocalListArray];
    finishBlock(listArray);
}

@end
