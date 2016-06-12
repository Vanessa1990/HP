//
//  ListHeadView.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/31.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "ListHeadView.h"

@implementation ListHeadView

+(instancetype)headView {
    
    return [[[NSBundle mainBundle]loadNibNamed:@"ListHeadView" owner:nil options:nil] lastObject];
}

@end
