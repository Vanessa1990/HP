//
//  SingleInstance.h
//
//  Created by 王顺子 on 15/8/16.
//  Copyright (c) 2015年 Vanessa. All rights reserved.
//

#define SingleInstance_interface(name) +(instancetype)share##name

#if __has_feature(objc_arc)

//是ARC
#define SingleInstance_implementation(name) + (instancetype)share##name\
{\
return [[self alloc] init];\
}\
static id _instans;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instans = [super allocWithZone:zone];\
    });\
    return _instans;\
}\
- (id)copyWithZone:(NSZone *)zone{\
    return _instans;\
}\
- (id)mutableCopyWithZone:(NSZone *)zone{\
    return _instans;\
}

#else
//不是MRC

#define SingleInstance_implementation(name) + (instancetype)share##name\
{ \
return [[self alloc] init]; \
} \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone \
{ \
return _instance; \
}\
- (oneway void)release \
{} \
- (instancetype)retain \
{ \
return _instance; \
} \
- (NSUInteger)retainCount \
{ \
return MAXFLOAT; \
}
#endif