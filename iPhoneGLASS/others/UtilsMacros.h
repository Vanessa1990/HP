//
//  UtilsMacros.h
//  iPhoneBIM
//
//  Created by cyhll on 2016/11/22.
//  Copyright © 2016年 Dev. All rights reserved.
//

#ifndef UtilsMacros_h
#define UtilsMacros_h

//-----------------------------------------------------------------------------------------------------------------
#pragma mark - OS Version

// 系统版本
#undef  IOS7_OR_LATER
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#undef  IOS8_OR_LATER
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
#undef  IOS9_OR_LATER
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending)
#undef  IOS11_OR_LATER
#define IOS11_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"11.0"] != NSOrderedAscending)

// 软件版本
#define HSAppBundleVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define HSAppBuildVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]


//-----------------------------------------------------------------------------------------------------------------
#pragma mark - UI Tool

// 屏幕
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenSize   [[UIScreen mainScreen] bounds].size

#define IsPortrait ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)

#define IS_IPAD    (fabs((IsPortrait?kScreenHeight:kScreenWidth) - 1024)<0.1)
#define IS_IPADPRO (fabs((IsPortrait?kScreenHeight:kScreenWidth) - 1366)<0.1)
#define IS_IPHONE4 (fabs((IsPortrait?kScreenHeight:kScreenWidth) - 480)<0.1)
#define IS_IPHONE5 (fabs((IsPortrait?kScreenHeight:kScreenWidth) - 568)<0.1)
#define IS_IPHONE6 (fabs((IsPortrait?kScreenHeight:kScreenWidth) - 667)<0.1)
#define IS_IPHONE6plus (fabs((IsPortrait?kScreenHeight:kScreenWidth) - 736)<0.1)

//宏定义常用的导航栏，tabbar，状态栏高度
#define TabBarH ((kheight == 812) ? 83 : 49)
#define NavH ((kScreenHeight == 812) ? 88 : 64)//这个包含状态栏在内
#define StuBarH ((kheight == 812) ? 44 : 20)


//-----------------------------------------------------------------------------------------------------------------
#pragma mark -

// TODO: Log
#ifdef DEBUG
#define HSLog(...) NSLog(__VA_ARGS__)
#else
#define HSLog(...)
#endif


// TODO: NSUserDefaults
/**
 *	永久存储对象
 *
 *	@param	object    需存储的对象
 *	@param	key    对应的key
 */
#define HS_PERSISTENT_SET_OBJECT(_object, _key)\
({\
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];\
[defaults setObject:_object forKey:_key];\
[defaults synchronize];\
})

/**
 *	取出永久存储的对象
 *
 *	@param	key    所需对象对应的key
 *	@return	key所对应的对象
 */
#define HS_PERSISTENT_GET_OBJECT(_key) [[NSUserDefaults standardUserDefaults] objectForKey:_key]


// TODO: 数据判断
#define VALID_STRING(_str) (_str && [_str isKindOfClass:[NSString class]] && [_str length]>0)
#define IsNilOrNull(_ref)  (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))


// TODO: GCD helper
#define HS_DISPATCH_MAIN_SYNC_SAFE(_block)\
if ([NSThread isMainThread]) {\
_block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), _block);\
}

#define HS_DISPATCH_MAIN_ASYNC_SAFE(_block)\
if ([NSThread isMainThread]) {\
_block();\
} else {\
dispatch_async(dispatch_get_main_queue(), _block);\
}


// TODO: TimeStamp
#define getTimeStamp [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]


// TODO: 角度转弧度
#define DEGREES_TO_RADIANS(_d) (_d * M_PI / 180)

// TODO: Path
#define HS_CREATE_PATH(_path)\
if (![[NSFileManager defaultManager] fileExistsAtPath:_path]) {\
[[NSFileManager defaultManager] createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:nil];\
}

#endif /* UtilsMacros_h */
