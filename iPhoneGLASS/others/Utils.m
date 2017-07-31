//
//  Utils.m
//  BIM
//
//  Created by binartist on 11/8/14.
//  Copyright (c) 2014 Pu Mai. All rights reserved.
//

#import "Utils.h"

// 获取当前设备信息
#import "sys/utsname.h"
#import <mach/mach.h>
#import <sys/sysctl.h>

#define CPU32BIT 0
#define CPU64BIT 1

@implementation Utils

+ (CGSize)sizeOfString:(NSString *)string withSize:(CGSize)size font:(UIFont *)font {
    // 判空
    if ([self isNilOrNull:string] || [@"" isEqualToString:string]) {
        return CGSizeMake(size.width, 0);
    }
    
    CGSize endSize = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
    return endSize;
}

+ (int)convertToInt:(NSString *)strtemp {
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

+ (NSString *)deviceType {
    struct utsname systeminfo;
    uname(&systeminfo);
    NSString *deviceString = [NSString stringWithCString:systeminfo.machine encoding:NSUTF8StringEncoding];
    
    //iPad mini
    if ([deviceString isEqualToString:@"iPad2,5"])      return@"iPad Mini";
    
    if ([deviceString isEqualToString:@"iPad2,6"])      return@"iPad Mini";
    
    if ([deviceString isEqualToString:@"iPad2,7"])      return@"iPad Mini";
    
    if ([deviceString isEqualToString:@"iPad4,4"])      return@"iPad Mini2";
    
    if ([deviceString isEqualToString:@"iPad4,5"])      return@"iPad Mini2";
    
    if ([deviceString isEqualToString:@"iPad4,6"])      return@"iPad Mini2";
    
    if ([deviceString isEqualToString:@"iPad4,7"])      return@"iPad Mini3";
    
    if ([deviceString isEqualToString:@"iPad4,8"])      return@"iPad Mini3";
    
    if ([deviceString isEqualToString:@"iPad4,9"])      return@"iPad Mini3";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return@"iPad 3";
    
    if ([deviceString isEqualToString:@"iPad5,1"])      return@"iPad Air2";
    
    if ([deviceString isEqualToString:@"iPad5,2"])      return@"iPad Air2";
    
    if ([deviceString isEqualToString:@"iPad5,3"])      return@"iPad Air2";
    
    //ipad
    if ([deviceString isEqualToString:@"iPad3,4"])      return@"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad3,5"])      return@"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad3,6"])      return@"iPad 4";
    
    //iphone
    if ([deviceString isEqualToString:@"iPhone5,2"])    return@"iPhone 5";
    
    if ([deviceString isEqualToString:@"iPhone5,4"])    return@"iPhone 5C";
    
    if ([deviceString isEqualToString:@"iPhone6,2"])    return@"iPhone 5S";
    
    if ([deviceString isEqualToString:@"iPhone7,2"])    return@"iPhone 6";
    
    if ([deviceString isEqualToString:@"iPhone7,1"])    return@"iPhone 6Plus";
    
    return deviceString;
}

+ (int)cpuType {
    NSString *devicetype = [Utils deviceType];
    if (([devicetype isEqualToString:@"iPad Mini2"]) ||
        ([devicetype isEqualToString:@"iPad Air2"])  ||
        ([devicetype isEqualToString:@"iPad 4"])     ||
        ([devicetype isEqualToString:@"iPhone 5"])   ||
        ([devicetype isEqualToString:@"iPhone 5C"])  ||
        ([devicetype isEqualToString:@"iPhone 5S"])  ||
        ([devicetype isEqualToString:@"iPhone 6"])   ||
        ([devicetype isEqualToString:@"iPhone 6Plus"])) {
        return CPU64BIT;
    }
    return CPU32BIT;
}

+ (BOOL)cpu64Bit {
    return [self cpuType] == CPU64BIT;
}

+ (NSString *)getDocumentDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)getCaches {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)prettySize:(long long)size {
    double kb = size / 1024;
    double mb = kb / 1024;
    if (mb < 1) {
        return [NSString stringWithFormat:@"%.2fK", kb];
    } else {
        return [NSString stringWithFormat:@"%.2fM", mb];
    }
}

// 获得文件的大小
+ (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 遍历文件夹获得文件夹大小
+ (CGFloat)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

+ (UILabel *)getFilletLabel:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor color:(UIColor *)color radius:(CGFloat)radius {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColor;
    label.layer.masksToBounds = YES;
    label.backgroundColor = color;
    label.layer.cornerRadius = radius;
    
    return label;
}

+ (NSString *)randomString {
    static int len = 7;
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((u_int32_t)[letters length])]];
    }
    
    return randomString;
}

+ (NSString *)jsonString:(id)data {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

+ (SHXPromise *)asyncOperation:(id(^)())block {
    SHXPromise* promise = [[SHXPromise alloc]init];
    __block id result = nil;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        result = block();
        dispatch_async(dispatch_get_main_queue(), ^{
            [promise fulfill:result];
        });
    });
    return promise;
}

+ (BOOL)isNull:(id)data {
    return (NSNull *)data == [NSNull null];
}

+ (BOOL)isNilOrNull:(id)val {
    return !val || [Utils isNull:val];
}

+ (BOOL)isEmptyObject:(id)var {
    if ([var isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([var isKindOfClass:[NSString class]]) {
        if ([(NSString *)var length] == 0) {
            return YES;
        }
    }
    
    if ([var isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)var count] == 0) {
            return YES;
        }
    }
    
    if ([var isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)var count] == 0) {
            return YES;
        }
    }
    
    return NO;
}

+ (CGFloat)getCPUUsage {
    CGFloat cpu = cpu_usage();
    return cpu;
}

float cpu_usage() {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

// 复查本地路径
+ (NSString *)reviewPath:(NSString *)path {
    if (!path) {
        return path;
    }
    
    NSString *urlRegEx = @"/var/mobile/Containers/Data/Application/(.*?)/Library";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:NSRegularExpressionAnchorsMatchLines error:nil];
    NSArray *array = [reg matchesInString:path options:NSMatchingReportCompletion range:NSMakeRange(0, [path length])];
    
    if (array.count > 0) {
        NSTextCheckingResult *matc = array[0];
        NSRange range = [matc range];
        NSString *newPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
        path = [path stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:newPath];
    }
    
    return path;
}

/**
 格式化数据大小显示

 @param size 字节大小

 @return 格式化字符串
 */
+ (NSString*)formatByteCount:(long long)size {
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}

#pragma mark - 设备内存
/**
 *  获取当前设备可用内存
 *
 *  @return 单位:MB
 */
+ (CGFloat)availableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

/**
 *  获取当前任务所占用的内存
 *
 *  @return 单位:MB
 */
+ (CGFloat)usedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

/**
 *  输出当前内存状况
 */
+ (void)memoryInfo {
    vm_statistics_data_t vmStats;
    if (memoryInfo(&vmStats)) {
        NSLog(@"free: %f\nactive: %f\ninactive: %f\nwire: %f\nzero fill: %f\nreactivations: %f\npageins: %f\npageouts: %f\nfaults: %u\ncow_faults: %u\nlookups: %u\nhits: %u",
              vmStats.free_count * vm_page_size/1024/1024.0,
              vmStats.active_count * vm_page_size/1024/1024.0,
              vmStats.inactive_count * vm_page_size/1024/1024.0,
              vmStats.wire_count * vm_page_size/1024/1024.0,
              vmStats.zero_fill_count * vm_page_size / 1.0,
              vmStats.reactivations * vm_page_size/1024/1024.0,
              vmStats.pageins * vm_page_size/1024/1024.0,
              vmStats.pageouts * vm_page_size/1024/1024.0,
              vmStats.faults,
              vmStats.cow_faults,
              vmStats.lookups,
              vmStats.hits
              );
    }
}

BOOL memoryInfo(vm_statistics_data_t *vmStats) {
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)vmStats, &infoCount);
    
    return kernReturn == KERN_SUCCESS;
}

#pragma mark - YZPath
// 创建目录
+ (NSString *)createPath:(NSString *)path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

// 获得app缓存大小
+ (CGFloat)getCacheFileSize
{
    CGFloat fileSize1 = [self folderSizeAtPath:[self getSpreadSheetCacheImagePath:nil]];
    CGFloat fileSize2 = [self folderSizeAtPath:[self getImageCachePath:nil]];
    CGFloat fileSize3 = 0;//[[SDImageCache sharedImageCache] getSize];
    
    return fileSize1 + fileSize2 + fileSize3;
}

// 删除app缓存
+ (SHXPromise *)removeCacheFile
{
    SHXPromise *promise = [[SHXPromise alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        BOOL res1 = [[NSFileManager defaultManager] removeItemAtPath:[self getSpreadSheetCacheImagePath:nil] error:&error];
        BOOL res2 = [[NSFileManager defaultManager] removeItemAtPath:[self getImageCachePath:nil] error:&error];
        
//        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
//            [promise fulfill:[NSNumber numberWithBool:(res1 && res2)]];
//
//        }];
    });
    return promise;
}

#pragma mark - Picture Path
// 表单html路径
+ (NSString *)getSpreadSheetPath
{
    return [self createPath:[[self getCaches] stringByAppendingPathComponent:@"spreadsheet"]];
}

// 表单html缓存图片目录路径(清理缓存时清空)
+ (NSString *)getSpreadSheetCacheImagePath:(NSString *)projectId
{
    NSString *projectPath = projectId?[NSString stringWithFormat:@"/%@", projectId]:@"";
    return [self createPath:[NSString stringWithFormat:@"%@/cache%@", [self getSpreadSheetPath], projectPath]];
}

// 获取一个表单缓存图片路径(用以替换html中网络表单图片)
+ (NSString *)createSpreadSheetCacheImagePath:(NSString *)imageName projectId:(NSString *)projectId
{
    return [[self getSpreadSheetCacheImagePath:projectId] stringByAppendingPathComponent:imageName?imageName:[self randomString]];
}

// 表单html本地图片目录路径(清理缓存也不会清空, 删除项目时清空对应项目路径)
+ (NSString *)getSpreadSheetLocalImagePath:(NSString *)projectId
{
    NSString *projectPath = projectId?[NSString stringWithFormat:@"/%@", projectId]:@"";
    return [self createPath:[NSString stringWithFormat:@"%@/local%@", [self getSpreadSheetPath], projectPath]];
}

// 获取一个表单本地图片路径(用以保存本地图片以上传)
+ (NSString *)createSpreadSheetLocalImagePath:(NSString *)imageName projectId:(NSString *)projectId
{
    return [[self getSpreadSheetLocalImagePath:projectId] stringByAppendingPathComponent:imageName?imageName:[self randomString]];
}

// 图片路径
+ (NSString *)getImageRootPath
{
    return [self createPath:[[self getCaches] stringByAppendingPathComponent:@"imageCache"]];
}

// 图片缓存路径(请求网络上的图片, 清理缓存时清空)
+ (NSString *)getImageCachePath:(NSString *)projectId
{
    NSString *projectPath = projectId?[NSString stringWithFormat:@"/%@", projectId]:@"";
    return [self createPath:[NSString stringWithFormat:@"%@/cache%@", [self getImageRootPath], projectPath]];
}

// 获取一个缓存图片路径(用以保存网络图片)
+ (NSString *)createCacheImagePath:(NSString *)imageName projectId:(NSString *)projectId __attribute__((deprecated("iOSCommon 1.2.0 版本已过期")))
{
    return [[self getImageCachePath:projectId] stringByAppendingPathComponent:imageName?imageName:[self randomString]];
}

// 本地图片缓存路径(创建离线数据时的图片, 尽可能不要清理)
+ (NSString *)getImageLocalPath:(NSString *)projectId
{
    NSString *projectPath = projectId?[NSString stringWithFormat:@"/%@", projectId]:@"";
    return [self createPath:[NSString stringWithFormat:@"%@/local%@", [self getImageRootPath], projectPath]];
}

// 获取一个本地图片路径(用以保存本地图片以上传)
+ (NSString *)createLocalImagePath:(NSString *)imageName projectId:(NSString *)projectId
{
    return [[self getImageLocalPath:projectId] stringByAppendingPathComponent:imageName?imageName:[self randomString]];
}

#pragma mark - Project Path
// 获取工程根路径
+ (NSString *)getProjectRootPath:(NSString *)projectId
{
    return [self createPath:[NSString stringWithFormat:@"%@/%@", [self getCaches], projectId?projectId:@"otherProject"]];
}

// 模型文件夹路径(存放模型相关数据:db文件\预处理后的文件)
+ (NSString *)getProjectModelRootPath:(NSString *)projectId
{
    return [self createPath:[NSString stringWithFormat:@"%@/model", [self getProjectRootPath:projectId]]];
}

// 数据文件夹路径(存放非模型\非缓存数据)
+ (NSString *)getProjectDocumentRootPath:(NSString *)projectId
{
    return [self createPath:[NSString stringWithFormat:@"%@/document", [self getProjectRootPath:projectId]]];
}

// 缓存文件夹路径(存放缓存数据)
+ (NSString *)getProjectCacheRootPath:(NSString *)projectId
{
    return [self createPath:[NSString stringWithFormat:@"%@/cache", [self getProjectRootPath:projectId]]];
}

// 模型资料数据路径(属于Document的子文件夹)
+ (NSString *)getProjectDocumentFilepath:(NSString *)projectId
{
    return [self createPath:[NSString stringWithFormat:@"%@/ProjectDocumentFile", [self getProjectDocumentRootPath:projectId]]];
}


@end

