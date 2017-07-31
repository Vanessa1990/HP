//
//  Utils.h
//  BIM
//
//  Created by binartist on 11/8/14.
//  Copyright (c) 2014 Pu Mai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

#import "NSDate+YZBim.h"

@interface Utils : NSObject

+ (CGSize)sizeOfString:(NSString *)string
              withSize:(CGSize)size
                  font:(UIFont *)font;

+ (int)convertToInt:(NSString*)strtemp;

+ (int)cpuType;

+ (BOOL)cpu64Bit;

+ (NSString *)getDocumentDir;

+ (NSString *)getCaches;

+ (SHXPromise *)asyncOperation:(id(^)())block;

+ (BOOL)isNull:(id)data;

+ (BOOL)isNilOrNull:(id)val;

+ (BOOL)isEmptyObject:(id)var;

+ (NSString *)prettySize:(long long)size;

// 获得文件的大小
+ (long long)fileSizeAtPath:(NSString *)filePath;

// 遍历文件夹获得文件夹大小
+ (CGFloat)folderSizeAtPath:(NSString *)folderPath;

+ (UILabel *)getFilletLabel:(CGRect)frame
                       text:(NSString *)text
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor
                      color:(UIColor *)color
                     radius:(CGFloat)radius;

+ (NSString *)randomString;

+ (NSString *)jsonString:(id)data;

+ (CGFloat)getCPUUsage;

// 复查本地路径
+ (NSString *)reviewPath:(NSString *)path;

/**
 格式化数据大小显示
 
 @param size 字节大小
 
 @return 格式化字符串
 */
+ (NSString*)formatByteCount:(long long)size;

#pragma mark - 设备内存
/**
 *  获取当前设备可用内存
 *
 *  @return 单位:MB
 */
+ (CGFloat)availableMemory;

/**
 *  获取当前任务所占用的内存
 *
 *  @return 单位:MB
 */
+ (CGFloat)usedMemory;

/**
 *  输出当前内存状况
 */
+ (void)memoryInfo;

#pragma mark - YZPath
// 创建目录
+ (NSString *)createPath:(NSString *)path;
// 获得app缓存大小
+ (CGFloat)getCacheFileSize;
// 删除app缓存
+ (SHXPromise *)removeCacheFile;

#pragma mark - Picture Path
// 表单html路径
+ (NSString *)getSpreadSheetPath;
// 获取一个表单缓存图片路径(用以替换html中网络表单图片)
+ (NSString *)createSpreadSheetCacheImagePath:(NSString *)imageName projectId:(NSString *)projectId;
// 获取一个表单本地图片路径(用以保存本地图片以上传)
+ (NSString *)createSpreadSheetLocalImagePath:(NSString *)imageName projectId:(NSString *)projectId;

// 获取一个缓存图片路径(用以保存网络图片)
+ (NSString *)createCacheImagePath:(NSString *)imageName projectId:(NSString *)projectId __attribute__((deprecated("iOSCommon 1.2.0 版本已过期")));
// 获取一个本地图片路径(用以保存本地图片以上传)
+ (NSString *)createLocalImagePath:(NSString *)imageName projectId:(NSString *)projectId;

#pragma mark - Project Path
// 获取工程根路径
+ (NSString *)getProjectRootPath:(NSString *)projectId;
// 模型文件夹路径(存放模型相关数据:db文件\预处理后的文件)
+ (NSString *)getProjectModelRootPath:(NSString *)projectId;
// 数据文件夹路径(存放非模型\非缓存数据)
+ (NSString *)getProjectDocumentRootPath:(NSString *)projectId;
// 缓存文件夹路径(存放缓存数据)
+ (NSString *)getProjectCacheRootPath:(NSString *)projectId;
// 模型资料数据路径(属于Document的子文件夹)
+ (NSString *)getProjectDocumentFilepath:(NSString *)projectId;


@end
