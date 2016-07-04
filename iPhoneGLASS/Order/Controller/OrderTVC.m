//
//  OrderTVC.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/5/17.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "OrderTVC.h"
#import "HeadView.h"
#import "ListModel.h"
#import "GlassTableViewCell.h"
#import "MBProgressHUD.h"
#import "OrderPreViewViewController.h"

@interface OrderTVC ()<HeadViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//型号
@property(nonatomic,strong) NSArray *headArray;
@property(nonatomic,strong) UIButton *addOrderPicture;
//key:型号 value:数组
@property(nonatomic,strong) NSMutableDictionary *glassDic;
@property(nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation OrderTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"call.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(call)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(upload)];
    
    //型号
    self.headArray = @[@"5cm白玻",@"6cm白玻",@"8cm白玻",@"10cm白玻",@"12cm白玻"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GlassTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderID"];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.addOrderPicture];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.addOrderPicture removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)call {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"13852689266"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)upload {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在上传";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.glassDic = nil;
        [self.tableView reloadData];
        [hud hideAnimated:YES];
    });
}

-(void)addPictureClick:(UIButton *)button {
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.toValue = [NSNumber numberWithFloat: M_PI * 0.5 ];
    anim.duration = 0.5;
    anim.cumulative = YES;
    anim.repeatCount = 1;
    [button.layer addAnimation:anim forKey:nil];
    
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:@"选择图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"图片", nil];
    [alertV show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if(buttonIndex == 1) {
            [self addPhotoForTopic:UIImagePickerControllerSourceTypeCamera];
        } else if(buttonIndex == 2) {
            [self addPhotoForTopic:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    } else {
        if(buttonIndex == 1) {
            [self addPhotoForTopic:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
}

- (void)addPhotoForTopic:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.navigationBar.tintColor = [UIColor colorWithRed:72.0/255.0 green:106.0/255.0 blue:154.0/255.0 alpha:1.0];
    imagePickerController.sourceType = type;
    imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    OrderPreViewViewController *vc = [[OrderPreViewViewController alloc]init];
    [self dismissViewControllerAnimated:NO completion:nil];
    vc.image = image;
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.headArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HeadView *headView = [[[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:nil options:nil] lastObject];
    headView.nameLable.text = self.headArray[section];
    headView.glassArray = self.glassDic[self.headArray[section]];
    headView.delegate = self;
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *keyStr = self.headArray[section];
    NSMutableArray *array = self.glassDic[keyStr];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GlassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //取出模型
    
    //赋值
    
    //cell的block修改模型
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source

        NSMutableArray *array = self.glassDic[self.headArray[indexPath.section]];
        [array removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



#pragma mark - HeadViewDelegate
-(void)HeadView:(HeadView *)view didClickAddGlass:(ListModel *)model {
    
    NSMutableArray *array = self.glassDic[view.nameLable.text];
    if (array == nil) {
        array = [NSMutableArray array];
    }
    [array addObject:model];
    self.glassDic[view.nameLable.text] = array;
    [self.tableView reloadData];
}


-(NSMutableDictionary *)glassDic {
    
    if (_glassDic == nil) {
        _glassDic = [NSMutableDictionary dictionary];
    }
    return _glassDic;
}

- (UIButton *)addOrderPicture {
    
    if (_addOrderPicture == nil) {
        _addOrderPicture = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addOrderPicture setImage:[UIImage imageNamed:@"add_green.png"] forState:UIControlStateNormal];
        _addOrderPicture.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, [UIScreen mainScreen].bounds.size.height - 109, 35,35);
        [_addOrderPicture addTarget:self action:@selector(addPictureClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addOrderPicture;
}

@end
