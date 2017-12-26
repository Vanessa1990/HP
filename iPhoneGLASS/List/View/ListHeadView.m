//
//  ListHeadView.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/31.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "ListHeadView.h"

@interface  ListHeadView()

@property(nonatomic, strong) SeeMoreBlock blcok;

@end

@implementation ListHeadView

+ (instancetype)headViewWithSeeMoreInfoBlock:(SeeMoreBlock)seeBlcok {
    ListHeadView *headView = [[[NSBundle mainBundle]loadNibNamed:@"ListHeadView" owner:nil options:nil] lastObject];
    headView.blcok = seeBlcok;
    return headView;
}
- (IBAction)seeMore:(id)sender {
    if (self.blcok) {
        self.blcok();
    }
}

@end
