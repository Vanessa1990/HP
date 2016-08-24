//
//  NetService.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/8/23.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "NetService.h"
#import "AFNetworking.h"

@interface NetService()

@property(nonatomic,strong,readonly) NSString *address;

@property(nonatomic,strong) AFHTTPSessionManager *manager;

@end

@implementation NetService

-(instancetype)init {
    
    if (self = [super init]) {
        _address = @"http://localhost:12306";
        _manager = [AFHTTPSessionManager manager];
    }
    return self;
}

-(void)getlogin:(NSString *)urlstring parameters:(NSDictionary *)parameter success:(void (^)(NSDictionary *dict))successBlock failure:(void (^)())failureBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",self.address,urlstring];
    
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [_manager GET:url parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = [NSArray arrayWithArray:responseObject];
        successBlock([array firstObject]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock();
        NSLog(@"失败%@",error);
    }];
}


/*******************************列表相关API***********************************************/
//获取网络数据
-(void)getListArray:(NSString *)urlstring parameters:(NSDictionary *)parameter finish:(void (^)(NSArray *array))finishBlock failure:(void (^)())failureBlock
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",self.address,urlstring];
//    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [_manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arrary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        finishBlock(arrary);
    } failure:nil];
    
}


-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

@end
