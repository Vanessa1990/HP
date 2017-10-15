//
//  HomeViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 2017/7/31.
//  Copyright © 2017年 Yizhu. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionCell.h"
#import "SearchTVC.h"
#import "MoreTVC.h"
#import "NSDate+YZBim.h"
#import "BimService.h"
#import "UserListModel.h"


@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchTVCDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *allDates;

@property (nonatomic, strong) NSMutableDictionary *dateItems;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    self.allDates = [NSArray array];
    self.dateItems = [NSMutableDictionary dictionary];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - 64);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 65) collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = YZ_WhiteColor;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[HomeCollectionCell class] forCellWithReuseIdentifier:@"HomeCollectionCellID"];
    
    [[[BimService instance] getAllDate:[UserInfo shareInstance].userID] onFulfilled:^id(NSArray *value) {
        self.allDates = [NSArray arrayWithArray:value];
        [self.collectionView reloadData];
        return self.allDates;
    }];
    
}

-(void)initNav {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SHXPromise *)getDateItems:(NSDate *)date
{
    SHXPromise *promise = [SHXPromise new];
    
    if (![self.dateItems objectForKey:[date formatOnlyDay]]) {
        NSArray *array = [NSArray array];
        NSMutableArray *itemArray = [NSMutableArray array];
        array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"List.plist" ofType:nil]];
        for (NSDictionary *dict in array) {
            ListModel *model = [ListModel modelWithDict:dict];
            [itemArray addObject:model];
        }
        
        [self.dateItems setObject:[self dealItems:itemArray] forKey:[date formatOnlyDay]];
    }
    [promise resolve:self.dateItems];
    
    return promise;
    
}

- (NSArray *)dealItems:(NSArray *)items
{
    NSMutableArray *res = [NSMutableArray array];
    NSArray *ids = [items valueForKey:@"userID"];
    NSMutableArray *resIDs = [NSMutableArray array];
    for (NSString *ID in ids) {
        if (![resIDs containsObject:ID]) {
            [resIDs addObject:ID];
        }
    }
    
    for (NSString *ID in resIDs) {
        UserListModel *model = [UserListModel new];
        model.userID = ID;
        NSUInteger totle = 0;
        NSMutableArray *lists = [NSMutableArray array];
        for (ListModel *m in items) {
            if ([m.userID isEqualToString:ID]) {
                totle += m.totalNumber;
                [lists addObject:m];
            }
        }
        model.totle = [NSString stringWithFormat:@"%zd",totle];
        model.listArray = lists;
        [res addObject:model];
    }
    return res;
}


#pragma mark - event
-(void)search {
    
    SearchTVC *searchTVC = [[UIStoryboard storyboardWithName:@"SearchTVC" bundle:nil] instantiateInitialViewController];
    searchTVC.delegate = self;
    [self.navigationController pushViewController:searchTVC animated:YES];
}

#pragma mark - SearchTVCDelegate

-(void)SearchTVC:(SearchTVC *)VC searchSuccess:(NSArray *)array {
    
    
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allDates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionCellID" forIndexPath:indexPath];
    NSDate *date = self.allDates[indexPath.row];
    cell.date = date;
    [[self getDateItems:date] onFulfilled:^id(id value) {
        NSArray *items = [self.dateItems objectForKey:[date formatOnlyDay]];
        cell.items = items;
        return value;
    }];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth, self.view.bounds.size.height - 64);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


@end
