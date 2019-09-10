//
//  ADScrollView.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2019/9/9.
//  Copyright © 2019年 Yizhu. All rights reserved.
//

#import "ADScrollView.h"

@interface  ADScrollView()

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIButton *chooseButton;
@property(nonatomic, strong) NSArray *imageSrcs;
@property(nonatomic, strong) NSTimer *timer;
@property (assign, nonatomic) NSInteger currentPage;
@property(nonatomic, strong) ADPageControl *pageView;

@end

@implementation ADScrollView
- (instancetype)initWithFrame:(CGRect)frame imageSrcs:(NSArray *)imageSrcs {
    if (self = [super initWithFrame:frame]) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        // add scroll view
        self.scrollView.frame = CGRectMake(0, 0, width, height);
        [self addSubview:self.scrollView];
        // add 图片数组
        self.imageSrcs = imageSrcs;
        for (int i = 0; i < imageSrcs.count; i++) {
            UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageSrcs[i]]];
            imageV.frame = CGRectMake(i * frame.size.width, 0, frame.size.width, frame.size.height);
            [self.scrollView addSubview:imageV];
        }
        // add timer
        self.currentPage = -1;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (self.currentPage == imageSrcs.count - 1) {
                self.currentPage = 0;
            }else {
                self.currentPage++;
            }
            [self.scrollView setContentOffset:CGPointMake(self.currentPage*frame.size.width, 0) animated:YES];
            self.pageView.currentPage = self.currentPage;
        }];
        // add page view
        CGFloat pw = 200;
        self.pageView.frame = CGRectMake((width-pw)/2, height - 50, pw, 60);
        [self addSubview:self.pageView];
    }
    return self;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (ADPageControl *)pageView
{
    if (!_pageView) {
        _pageView = [[ADPageControl alloc] init];
        _pageView.currentPage = self.currentPage;
        _pageView.numberOfPages = self.imageSrcs.count;
        _pageView.currentPageIndicatorTintColor = YZ_ThemeColor;
        _pageView.pageIndicatorTintColor = YZ_GrayColor9B;
    }
    return _pageView;
}


@end

@implementation ADPageControl

- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 10;
        size.width = 10;
        subview.layer.cornerRadius = 5;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,size.width,size.height)];
        
    }
}
    
@end
