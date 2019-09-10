//
//  MainHomeViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/10/15.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "MainHomeViewController.h"
#import "WriteInViewController.h"
#import "HomeViewController.h"
#import "MoreTVC.h"
#import "RegistViewController.h"
#import "JSViewController.h"
#import "ADScrollView.h"
#import "FuctionButton.h"
#import "MessageHeadView.h"
#import "MessageTableViewCell.h"

typedef enum : NSUInteger {
    ButtonMe = 110,
    ButtonList,
    ButtonWrite,
    ButtonJS,
} ButtonType;

@interface MainHomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) ADScrollView *adScrollView;
@property (assign, nonatomic) CGFloat buttonWidth;
@property (assign, nonatomic) CGFloat buttonHeight;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *messages;
@property (assign, nonatomic) int fucCount;

@end

static CGFloat const margin = 20;
static CGFloat const left = 35;
static CGFloat const top = 10;
static CGFloat const cellHeight = 66;
static int const maxRow = 3;

@implementation MainHomeViewController

+ (void)load {
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.buttonWidth = ([UIScreen mainScreen].bounds.size.width - 2 * left - (maxRow-1) * margin)/maxRow;
    self.buttonHeight = self.buttonWidth + 20;
    
    self.title = @"和平钢化玻璃";
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = YZ_WhiteColor;
    
    // 广告页
    [self initAD];
    
    // 初始化功能按钮
    [self initFucButtons];
    
    // 初始化消息列表
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"plist"];
    NSMutableArray *message = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    self.messages = message;
    [self initTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initAD {
    NSArray *ads = [[NSArray alloc] initWithObjects:@"1.png",@"2.png",@"1.png",@"2.png", nil];
    ADScrollView *adscrollV = [[ADScrollView alloc] initWithFrame:CGRectMake(0, 600, kScreenWidth, 200) imageSrcs:ads];
    [self.scrollView addSubview:adscrollV];
    self.adScrollView = adscrollV;
    
    [self.adScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(200);
    }];
}

- (void)initFucButtons {
    NSMutableArray *titles = [NSMutableArray arrayWithObjects:@"订单列表", nil];
    NSMutableArray *images = [NSMutableArray arrayWithObjects:@"tab_list", nil];
    NSMutableArray *tags = [NSMutableArray arrayWithObjects:@111, nil];
    if ([UserInfo shareInstance].admin) {
        [titles addObject:@"玻璃管理"];
        [images addObject:@"tab_manager"];
        [tags addObject:@112];
    }
    if ([UserInfo shareInstance].JSPermission) {
        [titles addObject:@"计算"];
        [images addObject:@"tab_js"];
        [tags addObject:@113];
    }
    [titles addObject:@"设置"];
    [images addObject:@"tab_more"];
    [tags addObject:@110];
    self.fucCount = images.count;
    // add fuc bg view
    UIView *buttonBGView = [[UIView alloc] init];
    buttonBGView.backgroundColor = YZ_WhiteColor;
    [self.scrollView addSubview:buttonBGView];
    [buttonBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200+top);
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo((images.count>maxRow?2:1)*self.buttonHeight+margin);
    }];
    
    
    int section = 0;
    int row = 0;
    for (NSString *item in titles) {
        if (row > maxRow - 1) {
            section += 1;
            row = 0;
        }
        NSInteger tag = [tags[section * maxRow + row] integerValue];
        FuctionButton *button = [self setButtonWithTitle:item image:images[section*maxRow+row] tag:tag];
        [buttonBGView addSubview:button];
        button.frame = CGRectMake(left + (self.buttonWidth + margin) * row, (self.buttonHeight + margin) * section, self.buttonWidth, self.buttonHeight);
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        row++;
    }
    
}

- (void)initTableView {
    [self.scrollView addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(self.adScrollView.mas_bottom).mas_offset((self.fucCount>maxRow?2:1)*self.buttonHeight+margin*2);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(cellHeight*self.messages.count+cellHeight);
    }];
    [self.tableView layoutIfNeeded];
    CAShapeLayer *mask = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.tableView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(22, 22)];
    mask.path = path.CGPath;
    self.tableView.layer.mask = mask;
    self.tableView.separatorColor = YZ_GrayColor61;
}

- (FuctionButton *)setButtonWithTitle:(NSString *)title image:(NSString *)imageSrc tag:(NSInteger)tagNumber {
    FuctionButton *button = [FuctionButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageSrc] forState:UIControlStateNormal];
    button.tag = tagNumber;
    return button;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}


- (void)btnClick:(UIButton *)button {
    if (button.tag == ButtonMe) {
        MoreTVC *vc = [[MoreTVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (button.tag == ButtonList) {
        HomeViewController *addressVC = [[HomeViewController alloc] init];
        addressVC.view.backgroundColor = YZ_ThemeGrayColor;
        [self.navigationController pushViewController:addressVC animated:YES];
    } else if (button.tag == ButtonWrite) {
        WriteInViewController *vc = [[WriteInViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (button.tag == ButtonJS) {
        JSViewController *vc = [[JSViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.self.messages.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MessageHeadView *view = [[NSBundle mainBundle] loadNibNamed:@"MessageHeadView" owner:nil options:@{}][0];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    cell.message = self.messages[indexPath.row];
    return cell;
}

#pragma mark - lazy
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenSize.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = YZ_ThemeColor;
    }
    return _tableView;
}

@end
