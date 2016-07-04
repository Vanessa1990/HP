//
//  OrderPreViewViewController.m
//  iPhoneGLASS
//
//  Created by 尤维维 on 16/6/16.
//  Copyright © 2016年 Yizhu. All rights reserved.
//

#import "OrderPreViewViewController.h"

@interface OrderPreViewViewController ()

@end

@implementation OrderPreViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (IBAction)upload:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)setImage:(UIImage *)image {
    
    _image = image;
    self.imageView.image = image;
}

-(UIImageView *)imageView {
    
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 84)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}


@end
