//
//  Global.h
//  BIM
//
//  Created by binartist on 01/09/2014.
//  Copyright (c) 2014 Pu Mai. All rights reserved.
//

#ifndef BIM_Global_h
#define BIM_Global_h

#endif

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "SHXPromise.h"
#import "Underscore.h"

/**
 下载进度条

 @param bytesRead                本次下载
 @param totalBytesRead           本次已下载
 @param totalBytesExpectedToRead 总大小
 @param speedBytes               速度
 */
typedef void (^TProgress)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead, long long speedBytes);

#endif
