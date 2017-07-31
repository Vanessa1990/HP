//
//  Utils+AFNetworking.h
//  BIM
//
//  Created by Dion Chen on 15/5/12.
//  Copyright (c) 2015年 Pu Mai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Global.h"

@class SHXPromise;

@interface AFNetworkingHelper : NSObject

+ (SHXPromise *)getResource:(NSString *)URLString
                 parameters:(id)parameters;

+ (SHXPromise *)postResource:(NSString *)URLString
                 parameters:(id)parameters;

+ (SHXPromise *)postResource:(NSString *)URLString
                  parameters:(id)parameters
   constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;

+ (SHXPromise *)updateResource:(NSString *)URLString
                    parameters:(id)parameters;

+ (SHXPromise *)updateResource:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;

+ (SHXPromise *)deleteResource:(NSString *)URLString
                    parameters:(id)parameters;

+ (SHXPromise *)resumeGetFile:(NSString *)urlString
                  destination:(NSString*)destination
             cacheDestination:(NSString *)cacheDestination
                     progress:(TProgress)prgoressDelegate
                        range:(BOOL)range;

+ (void)cancelFileDownloadWithUrl:(NSString *)url;

+ (void)pauseFileDownloadWithUrl:(NSString *)url;
+ (void)resumeFileDownloadWithUrl:(NSString *)url;

//取消所有下载
+ (void)cancelRequestTask;

//暂停所有下载
+ (void)pauseRequestTask;

//继续所有下载
+ (void)resumeRequestTask;

@end
