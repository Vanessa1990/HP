//
//  ScanViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/6/1.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ResultViewController.h"
#import <objc/runtime.h>

@interface ScanViewController ()<UISearchBarDelegate, AVCaptureMetadataOutputObjectsDelegate,AVCaptureMetadataOutputObjectsDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *scanView;
//扫码
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *scanLineImageV;
@property (nonatomic, strong) NSTimer *scanLineTimer;
@property (assign, nonatomic)  BOOL scan;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"搜索";

    // 主要实现扫描功能
    [self isOnorOffCamera];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //6.启动会话
    [self.session startRunning];
    self.scan = YES;
}

#pragma mark 2.判断 有无摄像头
- (void)isOnorOffCamera{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        input = nil;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置-隐私-中打开相机权限" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        //       3. 设置扫描功能
        [self initViewAndSubViews];
    }
    
}
#pragma mark 3.设置扫描功能
- (void)initViewAndSubViews {
    
    CGRect scaneBounds = [[UIScreen mainScreen] bounds];
    self.view.frame = scaneBounds;
    
    CGRect viewFrame = self.view.frame;
    CGSize viewSize = CGSizeMake(viewFrame.size.width - 80, viewFrame.size.width - 80);
    
    
    // 1 实例化摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2 设置输入
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    // 3 设置输出
    AVCaptureMetadataOutput *outPut = [[AVCaptureMetadataOutput alloc] init];
    CGRect scanCrop =
    CGRectMake((viewFrame.size.width - viewSize.width)/2,
               (viewFrame.size.height - viewSize.height)/2,
               viewSize.width,
               viewSize.height);
    //设置扫描范围
    outPut.rectOfInterest =
    CGRectMake(scanCrop.origin.y/viewFrame.size.height,
               scanCrop.origin.x/viewFrame.size.width,
               scanCrop.size.height/viewFrame.size.height,
               scanCrop.size.width/viewFrame.size.width
               );
    
    // 4 设置输出的代理
    
    [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 5 拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPreset640x480;
    // 添加session的输入和输出
    [session addInput:input];
    [session addOutput:outPut];
    // 6 设置输出的格式
    [outPut setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 7 设置预览图层(用来让用户能够看到扫描情况)
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    // 7.1 设置preview图层的属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    // 7.2设置preview图层的大小
    
    [preview setFrame:self.scanView.bounds];
    //7.3将图层添加到视图的图层
    [self.scanView.layer insertSublayer:preview atIndex:0];
    self.previewLayer = preview;
    
    self.session = session;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"搜索");
    ResultViewController *rvc = [[ResultViewController alloc]initWithCode:searchBar.text];
    [self.navigationController pushViewController:rvc animated:YES];
    searchBar.text = @"";
    [self.view endEditing:YES];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (self.scan == NO) {
        return;
    }
    if (metadataObjects.count>0) {
        [session stopRunning];
        self.scan = NO;
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        ResultViewController *rvc = [[ResultViewController alloc]initWithCode:metadataObject.stringValue];
        [self.navigationController pushViewController:rvc animated:YES];
        [self.view endEditing:YES];
    }
}

@end
