    //
//  BimService.m
//  BIM
//
//  Created by Dion Chen on 15/5/12.
//  Copyright (c) 2015年 Pu Mai. All rights reserved.
//

#import "BimService.h"
//#import "SDWebImageManager.h"
#import "Utils.h"

@interface BimService()

@end

@implementation BimService

- (instancetype)init
{
    if (self = [super init]) {
//        self.address = @"http://localhost:3000";
        self.address = @"http://47.96.157.244:3000";
        // 陈鹏
//        self.address = @"http://192.168.1.239:3000";
    }
    return self;
}

+ (BimService *)instance
{
    static BimService* _instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[BimService alloc] init];
        }
    });
    return _instance;
}

- (NSString *)baseAPI
{
    if ([self.address hasSuffix:@"/"]) {
        return [NSString stringWithFormat:@"%@api/", self.address];
    }
    return [NSString stringWithFormat:@"%@/api/", self.address];
}

#pragma mark - requestTask

// 取消所有下载
+ (void)cancelRequestTask
{
    [AFNetworkingHelper cancelRequestTask];
}

// 暂停所有下载
+ (void)pauseRequestTask
{
    [AFNetworkingHelper pauseRequestTask];
}

// 继续所有下载
+ (void)resumeRequestTask
{
    [AFNetworkingHelper resumeRequestTask];
}

#pragma mark - file task

/**
 下载文件
 
 @param fileId 文件id
 @param destination 本地存放路径
 @param cacheDestination 本地临时路径
 @param progress 进度回调
 @param range 是否断点
 @return SHXPromise
 */
- (SHXPromise *)getFile:(NSString *)fileId destination:(NSString *)destination cacheDestination:(NSString *)cacheDestination progress:(TProgress)progress range:(BOOL)range
{
    if (!fileId || [@"" isEqualToString:fileId]) {
        SHXPromise *promise = [[SHXPromise alloc] init];
        NSError *error = [[NSError alloc] initWithDomain:@"fileId is nil" code:404 userInfo:nil];
        [promise reject:error];
        return promise;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@files/%@", [self baseAPI], fileId];
    NSLog(@"request file url = %@", urlString);
    
    return [[AFNetworkingHelper resumeGetFile:urlString
                                  destination:destination
                             cacheDestination:cacheDestination
                                     progress:progress
                                        range:range] onFulfilled:^id(id value) {
        return value;
    } rejected:^id(NSError *reason) {
        // 清空已经下载部分
//        [[NSFileManager defaultManager] removeItemAtPath:destination error:nil];
        return reason;
    }];
}

// 取消文件下载
- (void)cancelFile:(NSString *)fileId
{
    NSString *urlString = [NSString stringWithFormat:@"%@files/%@", [self baseAPI], fileId];
    [AFNetworkingHelper cancelFileDownloadWithUrl:urlString];
}

// 暂停文件下载
- (void)pauseFile:(NSString *)fileId
{
    NSString *urlString = [NSString stringWithFormat:@"%@files/%@", [self baseAPI], fileId];
    [AFNetworkingHelper pauseFileDownloadWithUrl:urlString];
}

// 继续文件下载
- (void)resumeFile:(NSString *)fileId
{
    NSString *urlString = [NSString stringWithFormat:@"%@files/%@", [self baseAPI], fileId];
    [AFNetworkingHelper resumeFileDownloadWithUrl:urlString];
}

#pragma mark - image task

// 获取图片网络地址
- (NSString *)getImageUrlString:(NSString *)pictureId
{
    return [NSString stringWithFormat:@"%@pictures/%@", self.baseAPI, pictureId];
}

/**获取图片SD*/
- (SHXPromise *)getImageByPictureId:(NSString *)pictureId projectId:(NSString *)projectId progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progress
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
//    if ([Utils isNilOrNull:pictureId] || [@"" isEqualToString:pictureId]) {
//        NSError *error = [[NSError alloc] initWithDomain:@"空的id" code:404 userInfo:nil];
//        [promise reject:error];
//        return promise;
//    }
//    
//    if ([pictureId hasPrefix:@"/"]) {
//        // 本地路径,复查app路径
//        [promise fulfill:[UIImage imageWithContentsOfFile:[Utils reviewPath:pictureId]]];
//        return promise;
//    }
//    
//    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[[BimService instance] getImageUrlString:pictureId]]  options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        if (![Utils isNilOrNull:progress]) {
//            progress(receivedSize, expectedSize);
//        }
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//        if (error) {
//            [promise reject:error];
//        } else {
//            [promise fulfill:image];
//        }
//    }];
//    
    return promise;
}

// 上传本地图片
- (SHXPromise *)postPictures:(NSArray *)picPathArray projectID:(NSString *)projectID
{
    return nil;
//    NSString *url = [NSString stringWithFormat:@"%@pictures", self.baseAPI];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:[NSString stringWithFormat:@"%lu",(unsigned long)picPathArray.count] forKey:@"fileSize"];
//    [dic setValue:projectID forKey:@"projectId"];
//
//    return [[AFNetworkingHelper postResource:url
//                                  parameters:dic
//                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (int i = 0; i < picPathArray.count; i++) {
//            [formData appendPartWithFileURL:[NSURL fileURLWithPath:[Utils reviewPath:picPathArray[i]]] name:[NSString stringWithFormat:@"picture%d",i] error:nil];
//        }
//    }] onFulfilled:^id(id value) {
//        return value;
//    }];
}

// 测试
- (SHXPromise *)test
{
    NSString *url = [NSString stringWithFormat:@"%@/test", self.baseAPI];
    return [AFNetworkingHelper getResource:url parameters:nil];
//    return [AFNetworkingHelper postResource:url parameters:@{@"First Name":@"111",@"last Name":@"111"}];
}

// 获取所有用户
- (SHXPromise *)getAllUsers {
    NSString *url = [NSString stringWithFormat:@"%@users", self.baseAPI];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 注册新用户
- (SHXPromise *)registNewUser:(NSString *)name phone:(NSString *)phone pwd:(NSString *)pwd
{
    NSString *url = [NSString stringWithFormat:@"%@user/add", self.baseAPI];
    NSDictionary *dict = @{@"name":name,@"phone":phone,@"password":pwd};
    
    return [[self checkSameUser:phone] onFulfilled:^id(NSArray *value) {
        if (value && value.count > 0) {
            return nil;
        }
        return [AFNetworkingHelper postResource:url parameters:dict];
    } rejected:^id(NSError *reason) {
        
        return [AFNetworkingHelper postResource:url parameters:dict];
    }];
    
}

- (SHXPromise *)checkSameUser:(NSString *)phone {
    NSString *url = [NSString stringWithFormat:@"%@user/%@", self.baseAPI,phone];
    return [AFNetworkingHelper getResource:url parameters:nil];
}

// 登录
- (SHXPromise *)load:(NSString *)phone pwd:(NSString *)pwd
{
    // @"http://localhost:8081/api/login"
    NSString *url = [NSString stringWithFormat:@"%@login", self.baseAPI];
    NSDictionary *dict = @{@"phone":phone,@"password":pwd};
    return [AFNetworkingHelper getResource:url parameters:dict];
}

// 查询数据
- (SHXPromise *)getListAttach:(NSString *)attach searchDict:(NSDictionary *)searchDict
{
    NSString *url = [NSString stringWithFormat:@"%@order", self.baseAPI];
//    url = [url stringByAppendingString:[NSString stringWithFormat:@"?%@",attach]];
    NSString *string = [Utils jsonString:searchDict];
//    url = [url stringByAppendingString:[NSString stringWithFormat:@"&where=%@",string]];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"?where=%@",string]];
    return [AFNetworkingHelper getResource:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil];
}

// 获取用户下单日期
- (SHXPromise *)getAllDate:(NSString *)userID
{
    SHXPromise *promise = [SHXPromise new];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        NSDate *date = [calendar dateByAddingUnit:NSCalendarUnitDay value:i toDate:[NSDate date] options:0];
        [array insertObject:date atIndex:0];
    }
    [promise resolve:array];
    return promise;
}

// 更新数据
- (SHXPromise *)updateGlassInfo:(NSString *)glassId newDict:(NSDictionary *)newDict {
    NSString *url = [NSString stringWithFormat:@"%@order/%@", self.baseAPI,glassId];
    return [AFNetworkingHelper updateResource:url parameters:newDict];
}

// 更新用户
- (SHXPromise *)updateUser:(NSString *)userId newDict:(NSDictionary *)newDict {
    NSString *url = [NSString stringWithFormat:@"%@user/resetPwd/%@", self.baseAPI,userId];
    return [AFNetworkingHelper updateResource:url parameters:newDict];
}

- (SHXPromise *)deleteGlasses:(NSArray *)glassIds {
    NSMutableArray *ps = [NSMutableArray array];
    for (NSString *glassId in glassIds) {
        SHXPromise *p = [self deleteGlass:glassId];
        [ps addObject:p];
    }
    return [SHXPromise all:ps];
}

- (SHXPromise *)deleteGlass:(NSString *)glassId {
    NSString *url = [NSString stringWithFormat:@"%@deleteOrder/%@", self.baseAPI,glassId];
    return [AFNetworkingHelper deleteResource:url parameters:nil];
}

@end
