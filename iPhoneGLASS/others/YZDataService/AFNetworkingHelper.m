//
//  Utils+AFNetworking.m
//  BIM
//
//  Created by Dion Chen on 15/5/12.
//  Copyright (c) 2015年 Pu Mai. All rights reserved.
//

#define DEF_TIME_OUT_INTERVAL 25

#import "AFNetworkingHelper.h"

typedef void(^TDownloadComplete)(id task, NSError *error);

@interface DownloadTask : NSObject

- (void)newStart:(unsigned long long)downloadedBytes;
- (void)cancel;

@property (atomic, strong) NSString *urlString;             // 网络地址
@property (atomic, strong) NSString *destination;           // 文件路径
@property (atomic, strong) NSString *cacheDestination;      // 文件临时路径
@property (atomic, strong) TProgress progressDel;           // 下载进度回调
@property (atomic, strong) TDownloadComplete completeDel;   // 下载完成回调
@property (atomic, strong) NSString *filePath;              // 下载完成文件路径
@property (atomic, strong) NSURLSessionTask *downloadTask;  // 下载任务

/**最新累计下载量*/
@property (atomic, assign) long long totalRead;
/**最后一次计算速度时间*/
@property (atomic, strong) NSDate *lastDate;
/**下载速度*/
@property (atomic, assign) long long speedBytes;

@end

@implementation DownloadTask

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)cancel
{
    [self.downloadTask cancel];
}

- (void)pause
{
    [self.downloadTask suspend];
}

- (void)resume
{
    [self.downloadTask resume];
}

- (void)newStart:(unsigned long long)downloadedBytes
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    BOOL append = NO;
    if (downloadedBytes > 0) {
        NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
        [mutableURLRequest setValue:[NSString stringWithFormat:@"bytes=%llu-", downloadedBytes] forHTTPHeaderField:@"Range"];
        request = mutableURLRequest;
        append = YES;
    }

    //[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:self.urlString]
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/octet-stream"];
    
    DownloadTask* __weak weak_p = self;
    
    self.downloadTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        if (weak_p.progressDel) {
            // 获取当前时间
            NSDate *currentDate = [NSDate date];
            if (!weak_p.lastDate) {
                weak_p.lastDate = currentDate;
            }
            
            // 当前时间和上一秒时间做对比，大于等于0.5秒就去计算
            if ([currentDate timeIntervalSinceDate:weak_p.lastDate] >= 0.5) {
                // 时间差
                double time = [currentDate timeIntervalSinceDate:weak_p.lastDate];
                // 计算速度
                weak_p.speedBytes = (self.downloadTask.countOfBytesReceived - weak_p.totalRead) / time;
                
                // 维护变量，将计算过的复位
                weak_p.totalRead = self.downloadTask.countOfBytesReceived;
                // 维护变量，记录这次计算的时间
                weak_p.lastDate = currentDate;
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                weak_p.progressDel(0, self.downloadTask.countOfBytesReceived + downloadedBytes, self.downloadTask.countOfBytesExpectedToReceive + downloadedBytes, weak_p.speedBytes);
            });
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            // 下载完成, 从临时路径移动到固定路径
            [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:weak_p.destination] error:nil];
            [[NSFileManager defaultManager] moveItemAtURL:[NSURL fileURLWithPath:weak_p.cacheDestination] toURL:[NSURL fileURLWithPath:weak_p.destination] error:nil];
        }
        if (weak_p) {
            weak_p.filePath = weak_p.destination;
            weak_p.completeDel(weak_p, error);
        }
    }];

    // 是否断点下载
    if (!append) {
        [[NSFileManager defaultManager] removeItemAtPath:self.cacheDestination error:nil];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:weak_p.cacheDestination]) {
        [[NSFileManager defaultManager] createFileAtPath:weak_p.cacheDestination contents:nil attributes:nil];
    }
    // 下载文件到临时路径
    [manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:weak_p.cacheDestination];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        [fileHandle closeFile];
    }];
    
    [self.downloadTask resume];
}

@end

@interface DownloadTaskManager : NSObject

+ (DownloadTaskManager *)instance;
- (void)addTask:(DownloadTask *)task;
- (void)cancelTaskWithUrl:(NSString *)url;
- (void)removeTask:(DownloadTask *)task;

- (void)cancelAllTask;
- (void)pauseAllTask;
- (void)resumeAllTask;

@property (atomic, strong) NSMutableArray* downloadTasks;

@end

@implementation DownloadTaskManager

+ (id)instance {
    static DownloadTaskManager* _instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[DownloadTaskManager alloc] init];
        }
    });
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.downloadTasks = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)addTask:(DownloadTask *)task
{
    TDownloadComplete taskComplete = task.completeDel;
    task.completeDel = ^void(id task, id error) {
        taskComplete(task, error);
        [self removeTask:task];
    };
    
    [self.downloadTasks addObject:task];
}

- (void)removeTask:(DownloadTask *)task
{
    [self.downloadTasks removeObject:task];
}

- (void)cancelTaskWithUrl:(NSString *)url
{
    DownloadTask *task = Underscore.find(self.downloadTasks, ^BOOL(DownloadTask* task) {
        return [task.urlString isEqualToString:url];
    });
    if (task) {
        [task cancel];
        [self removeTask:task];
    }
}

- (void)pauseTaskWithUrl:(NSString *)url
{
    DownloadTask *task = Underscore.find(self.downloadTasks, ^BOOL(DownloadTask* task) {
        return [task.urlString isEqualToString:url];
    });
    if (task) {
        [task pause];
    }
}

- (void)resumeTaskWithUrl:(NSString *)url
{
    DownloadTask *task = Underscore.find(self.downloadTasks, ^BOOL(DownloadTask* task) {
        return [task.urlString isEqualToString:url];
    });
    if (task) {
        [task resume];
    }
}

//取消全部
- (void)cancelAllTask
{
    Underscore.arrayEach(self.downloadTasks, ^(DownloadTask* task) {
        if (task) {
            [task cancel];
        }
    });
    [self.downloadTasks removeAllObjects];
}

//暂停全部
- (void)pauseAllTask
{
    Underscore.arrayEach(self.downloadTasks, ^(DownloadTask* task) {
        if (task) {
            [task pause];
        }
    });
}

//继续全部
- (void)resumeAllTask
{
    Underscore.arrayEach(self.downloadTasks, ^(DownloadTask* task) {
        if (task) {
            [task resume];
        }
    });
}

@end

@implementation AFNetworkingHelper

+ (SHXPromise *)getResource:(NSString *)URLString
                 parameters:(NSDictionary *)parameters
{
    SHXPromise *promise = [[SHXPromise alloc] init];

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    session.requestSerializer.timeoutInterval = DEF_TIME_OUT_INTERVAL;
    session.responseSerializer = [AFJSONResponseSerializer serializer];

    [session GET:URLString
      parameters:parameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [promise fulfill:responseObject];
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSError *e = error;
            if (task.description) {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[task.description dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:NSJSONReadingMutableContainers
                                                                               error:nil];
                e = [NSError errorWithDomain:error.domain code:error.code userInfo:responseDict];
            }
            [promise reject:e];
        }];
    return promise;
}

+ (SHXPromise *)postResource:(NSString *)URLString
                  parameters:(id)parameters
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
//    session.requestSerializer.timeoutInterval = DEF_TIME_OUT_INTERVAL;
 
    [session POST:URLString
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [promise fulfill:responseObject];
         }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSError *e = error;
             if (task.description) {
                 NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[task.description dataUsingEncoding:NSUTF8StringEncoding]
                                                                              options:NSJSONReadingMutableContainers
                                                                                error:nil];
                 e = [NSError errorWithDomain:error.domain code:error.code userInfo:responseDict];
             }
             [promise reject:e];
         }];
    return promise;
}

+ (SHXPromise *)postResource:(NSString *)URLString
                  parameters:(id)parameters
   constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = DEF_TIME_OUT_INTERVAL;
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [session POST:URLString
       parameters:parameters
    constructingBodyWithBlock:block
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [promise fulfill:responseObject];
         }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSError *e = error;
             if (task.description) {
                 NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[task.description dataUsingEncoding:NSUTF8StringEncoding]
                                                                              options:NSJSONReadingMutableContainers
                                                                                error:nil];
                 e = [NSError errorWithDomain:error.domain code:error.code userInfo:responseDict];
             }
             [promise reject:e];
         }];
    return promise;
}

+ (SHXPromise *)updateResource:(NSString *)URLString
                    parameters:(id)parameters
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    session.requestSerializer.timeoutInterval = DEF_TIME_OUT_INTERVAL;
//    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];

    [session PUT:URLString
      parameters:parameters
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [promise fulfill:responseObject];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSError *e = error;
             if (task.description) {
                 NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[task.description dataUsingEncoding:NSUTF8StringEncoding]
                                                                              options:NSJSONReadingMutableContainers
                                                                                error:nil];
                 e = [NSError errorWithDomain:error.domain code:error.code userInfo:responseDict];
             }
             [promise reject:e];
         }];
    return promise;
}

+ (SHXPromise *)updateResource:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
  
    SHXPromise *promise = [[SHXPromise alloc] init];
    
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    session.requestSerializer.timeoutInterval = DEF_TIME_OUT_INTERVAL;
//
//    NSError *serializationError = nil;
//    NSMutableURLRequest *request = [session.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:session.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
//    if (serializationError) {
//        dispatch_async(session.completionQueue ?: dispatch_get_main_queue(), ^{
//            [promise reject:serializationError];
//        });
//        return promise;
//    }
//
//    __block NSURLSessionDataTask *task = [session uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
//        if (error) {
//            [promise reject:error];
//        } else {
//            [promise fulfill:responseObject];
//        }
//    }];
//
//    [task resume];
    
    return promise;
}

+ (SHXPromise *)deleteResource:(NSString *)URLString
                 parameters:(id)parameters
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = DEF_TIME_OUT_INTERVAL;
    
    [session DELETE:URLString
         parameters:parameters
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [promise fulfill:responseObject];
            }
            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSError *e = error;
                if (task.description) {
                    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[task.description dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:NSJSONReadingMutableContainers
                                                                                   error:nil];
                    e = [NSError errorWithDomain:error.domain code:error.code userInfo:responseDict];
                }
                [promise reject:e];
            }];
    return promise;
}

// range字段用于决定是否断点下载
+ (SHXPromise *)resumeGetFile:(NSString *)urlString destination:(NSString *)destination cacheDestination:(NSString *)cacheDestination progress:(TProgress)prgoressDelegate range:(BOOL)range
{
    SHXPromise *promise = [[SHXPromise alloc]init];
    
    // 临时路径复查
    if (!cacheDestination) {
        cacheDestination = [NSTemporaryDirectory() stringByAppendingString:[[destination componentsSeparatedByString:@"/"] lastObject]];
    }
    
    unsigned long long downloadedBytes = 0;
    if (range && [[NSFileManager defaultManager] fileExistsAtPath:cacheDestination]) {
        downloadedBytes = [self fileSizeForPath:cacheDestination];
    } else {
        downloadedBytes = 0;
    }
    
    void (^complete)(id task, id error) = ^void(DownloadTask* task, id error) {
        if (error) {
            [promise reject:error];
        } else {
            [promise resolve:task.filePath];
        }
    };
    
    DownloadTask *task = [[DownloadTask alloc]init];
    task.urlString = urlString;
    task.destination = destination;
    task.cacheDestination = cacheDestination;
    task.completeDel = complete;
    task.progressDel = prgoressDelegate;
    [[DownloadTaskManager instance] addTask:task];
    [task newStart:downloadedBytes];

    return promise;
}

//获取已下载的文件大小
+ (unsigned long long)fileSizeForPath:(NSString *)path {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

+ (void)cancelFileDownloadWithUrl:(NSString *)url
{
    [[DownloadTaskManager instance] cancelTaskWithUrl:url];
}

+ (void)pauseFileDownloadWithUrl:(NSString *)url
{
    [[DownloadTaskManager instance] pauseTaskWithUrl:url];
}

+ (void)resumeFileDownloadWithUrl:(NSString *)url
{
    [[DownloadTaskManager instance] resumeTaskWithUrl:url];
}

//取消所有下载
+ (void)cancelRequestTask
{
    [[DownloadTaskManager instance] cancelAllTask];
}

//暂停所有下载
+ (void)pauseRequestTask
{
    [[DownloadTaskManager instance] pauseAllTask];
}

//继续所有下载
+ (void)resumeRequestTask
{
    [[DownloadTaskManager instance] resumeAllTask];
}

@end
