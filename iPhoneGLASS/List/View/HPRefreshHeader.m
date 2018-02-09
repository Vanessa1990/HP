//
//  HPRefreshHeader.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2018/2/8.
//  Copyright © 2018年 Yizhu. All rights reserved.
//

#import "HPRefreshHeader.h"

@implementation HPRefreshHeader

- (void)prepare {
    [super prepare];
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"刷新..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"刷新完成" forState:MJRefreshStateNoMoreData];
    [self setTitle:@"刷新..." forState:MJRefreshStateWillRefresh];
    self.lastUpdatedTimeLabel.hidden = YES;
}

@end
