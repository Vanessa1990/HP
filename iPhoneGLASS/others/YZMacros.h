//
//  YZMacros.h
//  iPhoneBIM
//
//  Created by cyhll on 2016/11/22.
//  Copyright © 2016年 Dev. All rights reserved.
//

#ifndef YZMacros_h
#define YZMacros_h

//-----------------------------------------------------------------------------------
#pragma mark - Font Size

#define YZ_FontSize_S 12
#define YZ_FontSize_M 15
#define YZ_FontSize_L 17
#define YZ_FontSize_XL 19
#define YZ_FontSize_XXL 22


//-----------------------------------------------------------------------------------
#pragma mark - Font

#define YZ_Font(_fSize) [UIFont systemFontOfSize:_fSize]
#define YZ_Font_S [UIFont systemFontOfSize:YZ_FontSize_S]
#define YZ_Font_M [UIFont systemFontOfSize:YZ_FontSize_M]
#define YZ_Font_L [UIFont systemFontOfSize:YZ_FontSize_L]
#define YZ_Font_XL [UIFont systemFontOfSize:YZ_FontSize_XL]
#define YZ_Font_XXL [UIFont systemFontOfSize:YZ_FontSize_XXL]


//-----------------------------------------------------------------------------------
#pragma mark - Color
#define YZ_Color(r,g,b,a)  [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

// 灰色(参数)
#define YZ_GrayColor(g) YZ_Color(g, g, g, 1)

// 白色
#define YZ_WhiteColor YZ_Color(255, 255, 255, 1)

// #主题色#5c90dc 100%
#define YZ_ThemeColor [UIColor colorWithRed:(92 / 255.0) green:(144 / 255.0) blue:(220 / 255.0) alpha:1]
// #40dd8e 用于主要功能模块的图标.按钮
#define YZ_GreenColor [UIColor colorWithRed:(64 / 255.0) green:(221 / 255.0) blue:(142 / 255.0) alpha:1]
// 4dc3f1
#define YZ_BlueColor [UIColor colorWithRed:(77 / 255.0) green:(195 / 255.0) blue:(241 / 255.0) alpha:1]
// f6923e
#define YZ_OrangeColor [UIColor colorWithRed:(246 / 255.0) green:(146 / 255.0) blue:(62 / 255.0) alpha:1]
// ff7f6a
#define YZ_PinkColor [UIColor colorWithRed:(255 / 255.0) green:(127 / 255.0) blue:(106 / 255.0) alpha:1]

// #主题灰色#f4f4f4 100% 主要用于功能模块底色,图标,按钮
#define YZ_ThemeGrayColor YZ_GrayColor(244)
#define YZ_GrayColorDE YZ_GrayColor(222)
// 用于文字,辅助文字信息
#define YZ_GrayColor33 YZ_GrayColor(51)
#define YZ_GrayColorB3 YZ_GrayColor(179)

#define YZ_GrayColor61 YZ_GrayColor(97)
#define YZ_GrayColor81 YZ_GrayColor(129)
#define YZ_GrayColor9B YZ_GrayColor(155)
#define YZ_GrayColor26 YZ_GrayColor(38)


//-----------------------------------------------------------------------------------
#pragma mark - Size

#define YZ_ImageSize_S 150
#define YZ_ImageSize_M 500
#define YZ_ImageSize_L 1000

//-----------------------------------------------------------------------------------
#pragma mark - other

#define GT_Image(source) [UIImage imageNamed:source]


//-----------------------------------------------------------------------------------
#pragma mark - Path Key

//-----------------------------------------------------------------------------------
#pragma mark - Url

#define YZ_BASE_URL @"http://cloud.ezbim.net"


//-----------------------------------------------------------------------------------
#pragma mark - Add Info
#define YZKeyWindow [[UIApplication sharedApplication].delegate window]

// TODO: 版本号追加(Beta)
#define YZ_ADD_VERSION @""

// TODO: 调试服务器
#ifdef DEBUG
#define YZ_DEBUG_URL  @"http://180.168.170.198:3000"
#define YZ_DEBUG_URL2 @"http://192.168.1.64:3000"
#define YZLog(...) NSLog(__VA_ARGS__)
#else
#define YZ_DEBUG_URL  @""
#define YZ_DEBUG_URL2 @""
#define YZLog(...)
#endif

#endif /* YZMacros_h */
